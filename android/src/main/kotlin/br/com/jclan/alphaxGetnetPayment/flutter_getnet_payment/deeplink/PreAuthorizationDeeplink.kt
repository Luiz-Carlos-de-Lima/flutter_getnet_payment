package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class PreAuthorizationDeeplink: Deeplink() {
    companion object {
        const val REQUEST_CODE = 10003
    }

     override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        try {
            val amount: String? = bundle.getString("amount")
            val currencyPosition: String? = bundle.getString("currencyPosition")
            val currencyCode: String = bundle.getString("currencyCode") ?: "986"
            val callerId: String? = bundle.getString("callerId")
            val allowPrintCurrentTransaction: Boolean = bundle.getBoolean("allowPrintCurrentTransaction") ?: false
            val orderId: String? = bundle.getString("orderId")


            if (amount == null) {
                throw IllegalArgumentException("Invalid pre authorization details: amount")
            }
            if (currencyPosition == null) {
                throw IllegalArgumentException("Invalid pre authorization details: currencyPosition")
            }
            if (callerId == null) {
                throw IllegalArgumentException("Invalid pre authorization details: callerId")
            }


            val uriBuilder = Uri.Builder().apply {
                scheme("getnet")
                authority("pagamento")
                appendPath("v2")
                appendPath("pre-authorization")
                appendQueryParameter("amount", amount)
                appendQueryParameter("currencyPosition", currencyPosition)
                appendQueryParameter("currencyCode", currencyCode)
                appendQueryParameter("callerId", callerId)
                appendQueryParameter("allowPrintCurrentTransaction", allowPrintCurrentTransaction.toString())
                appendQueryParameter("orderId", orderId)
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