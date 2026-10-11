package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment

import android.os.Bundle
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Binder
import android.os.IBinder

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.Deeplink
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.InfoDeeplink
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.PaymentDeeplink
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.PreAuthorizationDeeplink
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.RefundDeeplink
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.ReprintDeeplink
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.StatusDeeplink
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.services.DeviceInfo
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.services.PrintService
import com.getnet.posdigital.PosDigital
import com.getnet.posdigital.printer.IPrinterCallback
import com.getnet.posdigital.printer.PrinterStatus

class FlutterGetnetPaymentPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private val paymentDeeplink = PaymentDeeplink()
  private val statusDeeplink = StatusDeeplink()
  private val refundDeeplink = RefundDeeplink()
  private val preAuthorizationDeeplink = PreAuthorizationDeeplink()
  private val reprintDeeplink = ReprintDeeplink()
  private val infoDeeplink = InfoDeeplink()
  private var binding: ActivityPluginBinding? = null
  private var resultScope: Result? = null
  private lateinit var applicationContext: Context
  private var reconnectAttempts = 0

  companion object {
    private const val TAG = "FlutterGetnetPayment"
    private const val MAX_RECONNECT_ATTEMPTS = 3
  }

  private val activityResultListener = PluginRegistry.ActivityResultListener { requestCode: Int, resultCode: Int, intent: Intent? ->
    val knownRequest = requestCode == PaymentDeeplink.REQUEST_CODE ||
      requestCode == StatusDeeplink.REQUEST_CODE ||
      requestCode == PreAuthorizationDeeplink.REQUEST_CODE ||
      requestCode == RefundDeeplink.REQUEST_CODE ||
      requestCode == ReprintDeeplink.REQUEST_CODE ||
      requestCode == InfoDeeplink.REQUEST_CODE

    if (!knownRequest) {
      return@ActivityResultListener false
    }

    if (Activity.RESULT_OK == resultCode) {
      val responseMap: Map<String, Any?> = when (requestCode) {
        PaymentDeeplink.REQUEST_CODE -> paymentDeeplink.validateIntent(intent)
        StatusDeeplink.REQUEST_CODE -> statusDeeplink.validateIntent(intent)
        PreAuthorizationDeeplink.REQUEST_CODE -> preAuthorizationDeeplink.validateIntent(intent)
        RefundDeeplink.REQUEST_CODE -> refundDeeplink.validateIntent(intent)
        ReprintDeeplink.REQUEST_CODE -> reprintDeeplink.validateIntent(intent)
        InfoDeeplink.REQUEST_CODE -> infoDeeplink.validateIntent(intent)
        else -> mapOf("code" to "ERROR", "message" to "Unknown request")
      }
      sendResultData(responseMap)
    } else {
      // RESULT_CANCELED / outros: fecha o MethodChannel pra UI não ficar no await.
      val message = when (resultCode) {
        Activity.RESULT_CANCELED -> "Operação cancelada na maquininha."
        else -> "Pagamento sem retorno da maquininha (resultCode=$resultCode)."
      }
      resultScope?.error("CANCELLED", message, null)
      resultScope = null
    }
    true
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_getnet_payment")
    channel.setMethodCallHandler(this)
    connectPosDigitalService()
  }

  override fun onAttachedToActivity(newBinding: ActivityPluginBinding) {
    binding = newBinding
    newBinding.addActivityResultListener(activityResultListener)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    detachActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    detachActivity()
  }

  private fun detachActivity() {
    binding?.removeActivityResultListener(activityResultListener)
    binding = null
  }

  override fun onDetachedFromEngine(newBinding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    disconnectPosDigitalService()
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    resultScope = result

    val activityBinding = binding ?: run {
      Log.e(TAG, "${call.method}: nenhuma Activity anexada ao plugin")
      result.error(
        "UNAVAILABLE",
        "Tela do aplicativo indisponível. Feche e abra o app e tente novamente.",
        mapOf("stage" to "start")
      )
      resultScope = null
      return
    }

    when (call.method) {
      "pay" -> {
        val bundle = Bundle().apply {
          putString("amount", call.argument<String>("amount"))
          putString("currencyPosition", call.argument<String>("currencyPosition"))
          putInt("currencyCode", call.argument<Int>("currencyCode") ?: 986)
          putString("paymentType", call.argument<String>("paymentType"))
          putString("callerId", call.argument<String>("callerId"))
          putString("orderId", call.argument<String>("orderId"))
          putString("creditType", call.argument<String>("creditType"))
          putInt("installments", call.argument<Int>("installments") ?: 0)
          putBoolean("allowPrintCurrentTransaction", call.argument<Boolean>("allowPrintCurrentTransaction") ?: false)
        }
        starDeeplink(activityBinding, paymentDeeplink, bundle)
      }
      "statusPayment" -> {
        val bundle = Bundle().apply {
          putString("callerId", call.argument<String>("callerId"))
          putBoolean("allowPrintCurrentTransaction", call.argument<Boolean>("allowPrintCurrentTransaction") ?: false)
        }
        starDeeplink(activityBinding, statusDeeplink, bundle)
      }
      "preAuthorization" -> {
        val bundle = Bundle().apply {
          putString("amount", call.argument<String>("amount"))
          putString("currencyPosition", call.argument<String>("currencyPosition"))
          putInt("currencyCode", call.argument<Int>("currencyCode") ?: 986)
          putString("callerId", call.argument<String>("callerId"))
          putBoolean("allowPrintCurrentTransaction", call.argument<Boolean>("allowPrintCurrentTransaction") ?: false)
          putString("orderId", call.argument<String>("orderId"))
        }
        starDeeplink(activityBinding, preAuthorizationDeeplink, bundle)
      }
      "refund" -> {
        val bundle = Bundle().apply {
          putString("amount", call.argument<String>("amount"))
          putString("transactionDate", call.argument<String>("transactionDate"))
          putString("cvNumber", call.argument<String>("cvNumber"))
          putString("originTerminal", call.argument<String>("originTerminal"))
          putBoolean("allowPrintCurrentTransaction", call.argument<Boolean>("allowPrintCurrentTransaction") ?: false)
        }
        starDeeplink(activityBinding, refundDeeplink, bundle)
      }
      "print" -> {
        val listPrintContent: List<HashMap<String, Any?>>? = call.argument<List<HashMap<String, Any?>>>("printable_content")

        if (!PosDigital.getInstance().isInitiated()) {
          Log.e(TAG, "print: PosDigital não iniciado, reconectando")
          reconnectPosDigitalService()
          resultScope?.error("ERROR", PrintService.PRINT_UNAVAILABLE_MESSAGE, null)
          resultScope = null
          return
        }

        val bundleResult = PrintService().start(
          PrinterCallback(
            onCompleted = {
              resultScope?.success(mapOf(
                "code" to "SUCCESS",
                "data" to true
              ))
              resultScope = null
            },
            onFailure = { message ->
              resultScope?.error("ERROR", message, null)
              resultScope = null
            }
          ),
          listPrintContent?.toBundleList(),
          activityBinding
        )

        if (bundleResult.getString("code") == "ERROR") {
          val message: String = (bundleResult.getString("message") ?: "result error").toString()
          resultScope?.error((bundleResult.getString("code") ?: "ERROR").toString(), message, null)
          resultScope = null
        }
      }
      "reprint" -> {
        starDeeplink(activityBinding, reprintDeeplink, Bundle())
      }
      "info" -> {
        starDeeplink(activityBinding, infoDeeplink, Bundle())
      }
      "getSerialNumberAndDeviceModel" -> {
        val deviceInfo = DeviceInfo().getSerialNumberAndDeviceModel()
        resultScope?.success(mapOf(
          "code" to "SUCCESS",
          "data" to deviceInfo
        ))
      }
      else ->  {
        resultScope?.error("ERROR", "Value of ", null)
      }
    }
  }

  private fun starDeeplink(activityBinding: ActivityPluginBinding, deeplink: Deeplink, bundle: Bundle) {
    val bundleStartDeeplink: Bundle = deeplink.startDeeplink(activityBinding, bundle)
    val code: String = bundleStartDeeplink.getString("code") ?: "ERROR"

    if (code == "ERROR") {
      val message: String = (bundleStartDeeplink.getString("message") ?: "start deeplink error").toString()
      resultScope?.error(code, message, mapOf("stage" to "start"))
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
      val details = mapOf(
        "stage" to "result",
        "result" to paymentData["result"],
        "resultDetails" to paymentData["resultDetails"]
      )
      resultScope?.error((paymentData["code"] ?: "ERROR").toString(), message, details)
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

  private fun connectPosDigitalService() {
    Log.d(TAG, "PosDigital connecting!")
    try {
      if (PosDigital.getInstance().isInitiated())
        PosDigital.unregister(applicationContext)
      PosDigital.register(applicationContext, bindCallback)
    } catch (e: Exception) {
      Log.e(TAG, "Falha ao registrar PosDigital", e)
    }
  }

  private fun disconnectPosDigitalService() {
    try {
      if (PosDigital.getInstance().isInitiated())
        PosDigital.unregister(applicationContext)
    } catch (e: Exception) {
      Log.e(TAG, "Falha ao desregistrar PosDigital", e)
    }
  }

  private fun reconnectPosDigitalService() {
    reconnectAttempts = 0
    connectPosDigitalService()
  }

  private val bindCallback = object : PosDigital.BindCallback {
    override fun onError(e: Exception) {
      Log.e(TAG, "PosDigital onError (tentativa ${reconnectAttempts + 1}/$MAX_RECONNECT_ATTEMPTS)", e)
      if (reconnectAttempts >= MAX_RECONNECT_ATTEMPTS) {
        Log.e(TAG, "PosDigital: limite de reconexões atingido")
        return
      }
      reconnectAttempts++
      connectPosDigitalService()
    }
    override fun onConnected() {
      reconnectAttempts = 0
      Log.d(TAG, "PosDigital connected successfully!")
    }
    override fun onDisconnected() {
      Log.d(TAG, "PosDigital disconnected!")
    }
  }
}

class PrinterCallback(
  private val onCompleted: () -> Unit,
  private val onFailure: ( String) -> Unit
) : IPrinterCallback {

  override fun asBinder(): IBinder {
    return Binder()
  }

  override fun onSuccess() {
    onCompleted()
  }

  override fun onError(p0: Int) {
    when(p0) {
      PrinterStatus.ERROR_NOT_INIT -> {
        onFailure("Impressora não iniciada")
      }

      PrinterStatus.ERROR_OVERHEAT -> {
        onFailure("Impressora superaquecida")
      }

      PrinterStatus.ERROR_BUFOVERFLOW -> {
        onFailure("Fila de impressão muito grande")
      }

      PrinterStatus.ERROR_PARAM -> {
        onFailure("Parâmetros incorretos")
      }

      PrinterStatus.ERROR_LIFTHEAD -> {
        onFailure("Porta da impressora aberta")
      }

      PrinterStatus.ERROR_LOWTEMP -> {
        onFailure("Temperatura baixa demais para impressão")
      }

      PrinterStatus.ERROR_LOWVOL -> {
        onFailure("Sem bateria suficiente para impressão")
      }

      PrinterStatus.ERROR_MOTORERR -> {
        onFailure("Motor de passo com problemas")
      }

      PrinterStatus.ERROR_NO_PAPER -> {
        onFailure("Sem bobina")
      }

      PrinterStatus.ERROR_PAPERENDING -> {
        onFailure("Bobina acabando")
      }

      PrinterStatus.ERROR_PAPERJAM -> {
        onFailure("Papel atolado")
      }

      PrinterStatus.UNKNOW -> {
        onFailure("Não foi possível definir o erro")
      }
      else -> {
        onFailure(PrintService.PRINT_UNAVAILABLE_MESSAGE)
      }
    }
  }
}
