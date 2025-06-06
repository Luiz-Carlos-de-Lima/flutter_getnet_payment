package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class RefundDeeplink: Deeplink() {
    companion object {
        const val REQUEST_CODE = 10004
    }

    override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        try {
            val amount: String? = bundle.getString("amount")
            val transactionDate: String? = bundle.getString("transactionDate")
            val cvNumber: String? = bundle.getString("cvNumber")
            val originTerminal: String? = bundle.getString("originTerminal")
            val allowPrintCurrentTransaction: Boolean = bundle.getBoolean("allowPrintCurrentTransaction") ?: false

            val uriBuilder = Uri.Builder().apply {
                scheme("getnet")
                authority("pagamento")
                appendPath("v1")
                appendPath("refund")
                if(amount != null) {
                    appendQueryParameter("amount", amount)
                }
                if (transactionDate != null) {
                    appendQueryParameter("transactionDate", transactionDate)
                }
                if (cvNumber != null) {
                    appendQueryParameter("cvNumber", cvNumber)
                }
                if (originTerminal != null) {
                    appendQueryParameter("originTerminal", originTerminal)
                }

                appendQueryParameter("allowPrintCurrentTransaction", allowPrintCurrentTransaction.toString())
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