package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.PaymentDeeplink.Companion
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class StatusDeeplink: Deeplink() {
    companion object {
        const val REQUEST_CODE = 10002
    }
    override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        try {
            val callerId: String = bundle.getString("callerId")
                ?: throw IllegalArgumentException("Invalid payment details: callerId")
            val allowPrintCurrentTransaction: Boolean = bundle.getBoolean("allowPrintCurrentTransaction") ?: false

            val uriBuilder = Uri.Builder().apply {
                scheme("getnet")
                authority("pagamento")
                appendPath("v1")
                appendPath("checkstatus")
                appendQueryParameter("callerId", callerId)
                appendQueryParameter("allowPrintCurrentTransaction", allowPrintCurrentTransaction.toString())
            }

            val paymentIntent = Intent(Intent.ACTION_VIEW)
            paymentIntent.data = uriBuilder.build()
            binding.activity.startActivityForResult(paymentIntent, StatusDeeplink.REQUEST_CODE)

            return Bundle().apply {
                putString("code", "SUCCESS")
            }
        } catch (e: IllegalArgumentException) {
            return Bundle().apply {
                putString("code", "ERROR")
                putString("message", e.message)
            }
        } catch (e: Exception) {
            return Bundle().apply {
                putString("code", "ERROR")
                putString("message", e.message ?: "An unexpected error occurred")
            }
        }
    }
}