package br.com.jclan.alphaxStonePayment.flutter_getnet_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.core.app.ActivityCompat.startActivityForResult
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


class PaymentDeeplink: Deeplink {
    companion object {
        const val REQUEST_CODE = 10001
    }

    override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("getnet://pagamento/v3/payment"))
            binding.activity.startActivityForResult(intent, REQUEST_CODE)
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

    override fun validateIntent(intent: Intent?): Map<String, Any?> {
        TODO("Not yet implemented")
    }
}