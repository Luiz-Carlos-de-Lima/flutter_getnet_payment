package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


class PaymentDeeplink: Deeplink {
    companion object {
        const val REQUEST_CODE = 10001
    }

    override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        try {
            val paymentType: String? = bundle.getString("paymentType")
            val amount: String? = bundle.getString("amount")
            val callerId: String? = bundle.getString("callerId")
            val orderId: String? = bundle.getString("orderId")

            if ((paymentType.equals("credit") || paymentType.equals("debit") || paymentType.equals("voucher") || paymentType.equals("pix")).not()) {
                throw IllegalArgumentException("Invalid payment details: paymentType")
            }
            if (amount == null) {
                throw IllegalArgumentException("Invalid payment details: amount")
            }
            if (callerId == null) {
                throw IllegalArgumentException("Invalid payment details: callerId")
            }


            val uriBuilder = Uri.Builder().apply {
                scheme("getnet")
                authority("pagamento")
                appendPath("v3")
                appendPath("payment")
                appendQueryParameter("paymentType", paymentType)
                appendQueryParameter("amount", amount)
                appendQueryParameter("callerId", callerId)
                appendQueryParameter("orderId", orderId)
            }

            if (paymentType.equals("credit")) {
                val creditType: String? = bundle.getString("creditType")
                val installments: String? = bundle.getString("installments")
                if ((creditType.equals("creditMerchant") || creditType.equals("creditIssuer")).not()) {
                    throw IllegalArgumentException("Invalid payment details of paymentType.credit: the value of creditType cannot different 'creditMerchant' or 'creditIssuer'")
                }
                if (installments == null) {
                    throw IllegalArgumentException("Invalid payment details of paymentType.credit: the value of 'installments' cannot null")
                }
                uriBuilder.appendQueryParameter("creditType", creditType)
                uriBuilder.appendQueryParameter("installments", installments)
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

    override fun validateIntent(intent: Intent?): Map<String, Any?> {
        try {
            if (intent == null) {
                return mapOf(
                    "code" to "ERROR",
                    "message" to "no intent data"
                )
            }

            val extras: Bundle? = intent.extras

            when (val status: String? = extras?.getString("result")) {
                "0" -> {
                    val data: MutableMap<String, Any?> = mutableMapOf()

                    for (key: String in extras.keySet()) {
                        data[key] = extras.get(key)
                    }

                    return mapOf(
                        "code" to "SUCCESS",
                        "data" to data
                    )
                }
                "5" -> {
                    return mapOf(
                        "code" to "PENDING",
                        "data"  to ""
                    )
                }
                else -> {
                    var message: String = "Erro não identificado"

                    when (status) {
                        "1" -> {
                            message = "Negada"
                        }

                        "2" -> {
                            message = "Cancelada"
                        }

                        "3" -> {
                            message = "Falha"
                        }

                        "4" -> {
                            message = "Desconhecido"
                        }
                    }

                    return mapOf(
                        "code" to "ERROR",
                        "message" to message
                    )
                }
            }
        } catch (e: Exception) {
            return mapOf(
                "code" to "ERROR",
                "message" to e.toString()
            )
        }
    }
}