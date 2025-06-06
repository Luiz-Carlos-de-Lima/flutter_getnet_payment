package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


class PaymentDeeplink: Deeplink() {
    companion object {
        const val REQUEST_CODE = 10001
    }

    override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        try {
            val paymentType: String? = bundle.getString("paymentType")
            val amount: String? = bundle.getString("amount")
            val callerId: String? = bundle.getString("callerId")
            val currencyPosition: String? = bundle.getString("currencyPosition")
            val currencyCode: Int = bundle.getInt("currencyCode")
            val orderId: String? = bundle.getString("orderId")
            val allowPrintCurrentTransaction: Boolean = bundle.getBoolean("allowPrintCurrentTransaction") ?: false

            if ((paymentType.equals("credit") || paymentType.equals("debit") || paymentType.equals("voucher") || paymentType.equals("pix")).not()) {
                throw IllegalArgumentException("Invalid payment details: paymentType")
            }
            if (amount == null) {
                throw IllegalArgumentException("Invalid payment details: amount")
            }
            if (callerId == null) {
                throw IllegalArgumentException("Invalid payment details: callerId")
            }
            Log.d("currencyCode", "$currencyCode")
            val uriBuilder = Uri.Builder().apply {
                scheme("getnet")
                authority("pagamento")
                appendPath("v3")
                appendPath("payment")
                appendQueryParameter("paymentType", paymentType)
                appendQueryParameter("amount", amount)
                appendQueryParameter("callerId", callerId)
                appendQueryParameter("orderId", orderId)
                if (currencyPosition != null) {
                    appendQueryParameter("currencyPosition", currencyPosition)
                }
                if (currencyCode > 0) {
                    appendQueryParameter("currencyCode", currencyCode.toString())
                }
                appendQueryParameter("allowPrintCurrentTransaction", allowPrintCurrentTransaction.toString())
            }

            if (paymentType.equals("credit")) {
                val creditType: String? = bundle.getString("creditType")
                val installments: Int = bundle.getInt("installments", 0)
                Log.d("creditType", creditType.toString())
                if ((creditType.equals("creditMerchant") || creditType.equals("creditIssuer")) && installments <= 1) {
                    throw IllegalArgumentException("Installments cannot be null and must be greater than 1 when paymentType is 'credit' and creditType is 'creditMerchant' or 'creditIssuer'")
                }

                if (creditType != null) {
                    uriBuilder.appendQueryParameter("creditType", creditType)
                    uriBuilder.appendQueryParameter("installments", installments.toString())
                }
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