package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class InfoDeeplink: Deeplink() {
    companion object {
        const val REQUEST_CODE = 10006
    }

    override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        try {
            val uriBuilder = Uri.Builder().apply {
                scheme("getnet")
                authority("pagamento")
                appendPath("v1")
                appendPath("getinfos")
            }

            val paymentIntent = Intent(Intent.ACTION_VIEW)
            paymentIntent.data = uriBuilder.build()
            binding.activity.startActivityForResult(paymentIntent, REQUEST_CODE)

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