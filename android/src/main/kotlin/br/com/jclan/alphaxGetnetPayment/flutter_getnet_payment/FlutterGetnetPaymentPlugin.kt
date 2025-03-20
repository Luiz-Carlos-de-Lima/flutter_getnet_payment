package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment

import android.os.Bundle
import android.app.Activity
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.Deeplink
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.PaymentDeeplink
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.StatusDeeplink
import com.getnet.posdigital.PosDigital

class FlutterGetnetPaymentPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private val paymentDeeplink = PaymentDeeplink()
  private val statusDeeplink = StatusDeeplink()
  private var binding: ActivityPluginBinding? = null
  private var resultScope: Result? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_getnet_payment")
    channel.setMethodCallHandler(this)
  }

  override fun onAttachedToActivity(newBinding: ActivityPluginBinding) {
    binding = newBinding
    PosDigital.register(binding!!.activity, bindCallback)
    binding?.addActivityResultListener { requestCode: Int, resultCode: Int, intent: Intent? ->
      if(Activity.RESULT_OK == resultCode) {
        var responseMap: Map<String, Any?> = mapOf()
        if (requestCode == PaymentDeeplink.REQUEST_CODE) {
          responseMap = paymentDeeplink.validateIntent(intent)
        } else if (requestCode == StatusDeeplink.REQUEST_CODE) {
          responseMap = statusDeeplink.validateIntent(intent)
        }

        sendResultData(responseMap)
      }
      true
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {
    binding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    try {
      if (PosDigital.getInstance().isInitiated){
        PosDigital.unregister(binding!!.activity)
        binding = null
      }
    } catch (e: Exception) {
      Log.e("error", "Erro de exception no Destroy da Activity")
    }
  }

  override fun onDetachedFromEngine(newBinding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    try {
      if (PosDigital.getInstance().isInitiated)
        PosDigital.unregister(binding!!.activity)
    } catch (e: Exception) {
      Log.e("error", "Erro de exception no Destroy da Activity")
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    resultScope = result

    if ((binding?.activity is Activity).not()) {
      resultScope!!.error("UNAVAILABLE", "Activity is not available", null)
      return
    }

    when (call.method) {
      "pay" -> {
        val bundle = Bundle().apply {
          putString("amount", call.argument<String>("amount"))
          putString("paymentType", call.argument<String>("paymentType"))
          putString("callerId", call.argument<String>("callerId"))
          putString("creditType", call.argument<String>("creditType"))
          putString("installments", call.argument<String>("installments"))
        }
        starDeeplink(paymentDeeplink, bundle)
      }
      "getStatusPayment" -> {
        val bundle = Bundle().apply {
          putString("callerId", call.argument<String>("callerId"))
          putBoolean("allowPrintCurrentTransaction", call.argument<Boolean>("allowPrintCurrentTransaction") ?: false)
        }
        starDeeplink(paymentDeeplink, bundle)
      }
      "refund" -> {
//        val bundle = Bundle().apply {
//          putString("amount", call.argument<String>("amount"))
//          putString("atk", call.argument<String>("atk"))
//          putBoolean("editable_amount", call.argument<Boolean?>("editable_amount") ?: false)
//        }
//        starDeeplink(cancelDeeplink, bundle)
      }
      "print" -> {
//        val bundle = Bundle().apply {
//          putBoolean("show_feedback_screen", call.argument<Boolean>("show_feedback_screen") ?: false)
//          val listPrintContent: List<HashMap<String, Any?>>? = call.argument<List<HashMap<String, Any?>>>("printable_content")
//          putParcelableArrayList("printable_content", listPrintContent?.toBundleList())
//        }
//        starDeeplink(printDeeplink, bundle)
      }
      "reprint" -> {
//        val bundle = Bundle().apply {
//          putBoolean("show_feedback_screen", call.argument<Boolean>("show_feedback_screen") ?: false)
//          putString("atk", call.argument<String>("atk"))
//          putString("type_customer", call.argument<String>("type_customer"))
//        }
//        starDeeplink(reprintDeeplink, bundle)
      }
      else ->  {
        resultScope?.error("ERROR", "Value of ", null)
      }
    }
  }

  private fun starDeeplink(deeplink: Deeplink, bundle: Bundle) {
    val bundleStartDeeplink: Bundle = deeplink.startDeeplink(binding!!, bundle)
    val code: String = bundleStartDeeplink.getString("code") ?: "ERROR"

    if (code == "ERROR") {
      val message: String = (bundleStartDeeplink.getString("message") ?: "start deeplink error").toString()
      resultScope?.error(code, message, null)
      resultScope = null
    }
  }

  private fun sendResultData(paymentData: Map<String, Any?>) {
    if (paymentData["code"] == "SUCCESS" && paymentData["data"] != null) {
      resultScope?.success(paymentData)
      resultScope = null
    } else if (paymentData["code"] == "PENDING" && paymentData["data"] != null) {
      resultScope?.success(paymentData)
      resultScope = null
    } else  {
      val message: String = (paymentData["message"] ?: "result error").toString()
      resultScope?.error((paymentData["code"] ?: "ERROR").toString(), message, null)
      resultScope = null
    }
  }

  private fun List<Map<String, Any?>>.toBundleList(): ArrayList<Bundle> {
    val bundleList = ArrayList<Bundle>()
    for (map in this) {
      bundleList.add(map.toBundle())
    }
    return bundleList
  }

  private fun Map<String, Any?>.toBundle(): Bundle {
    val bundle = Bundle()
    for ((key, value) in this) {
      when (value) {
        is String -> bundle.putString(key, value)
        is Int -> bundle.putInt(key, value)
        is Boolean -> bundle.putBoolean(key, value)
        is Double -> bundle.putDouble(key, value)
        is Float -> bundle.putFloat(key, value)
        is Long -> bundle.putLong(key, value)
        is Map<*, *> -> {
          @Suppress("UNCHECKED_CAST")
          bundle.putBundle(key, (value as? Map<String, Any?>)?.toBundle())
        }
      }
    }
    return bundle
  }

  private val bindCallback: PosDigital.BindCallback
    get() = object : PosDigital.BindCallback {
      override fun onError(e: Exception) {
        if (PosDigital.getInstance().isInitiated)
          PosDigital.unregister(binding!!.activity)
        connectPosDigitalService()
      }
      override fun onConnected() {}
      override fun onDisconnected() {}
    }

  private fun connectPosDigitalService() {
    PosDigital.register(binding!!.activity, bindCallback)
  }
}
