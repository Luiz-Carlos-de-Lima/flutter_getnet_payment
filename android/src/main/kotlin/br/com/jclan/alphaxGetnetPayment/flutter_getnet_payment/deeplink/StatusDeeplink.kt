package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink.PaymentDeeplink.Companion
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class StatusDeeplink: Deeplink {
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
                    val data: MutableMap<String, Any?> = mutableMapOf()

                    for (key: String in extras.keySet()) {
                        data[key] = extras.get(key)
                    }

                    return mapOf(
                        "code" to "PENDING",
                        "data"  to data
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