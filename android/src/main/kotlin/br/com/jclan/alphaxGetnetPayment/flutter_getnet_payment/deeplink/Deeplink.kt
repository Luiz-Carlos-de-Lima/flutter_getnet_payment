package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.deeplink

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

abstract class Deeplink {
    open fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle) : Bundle {
        throw NotImplementedError()
    }

    open fun validateIntent(intent: Intent?): Map<String, Any?> {
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