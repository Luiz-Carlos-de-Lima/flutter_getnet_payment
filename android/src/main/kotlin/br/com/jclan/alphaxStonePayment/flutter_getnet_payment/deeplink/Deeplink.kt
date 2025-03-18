package br.com.jclan.alphaxStonePayment.flutter_getnet_payment.deeplink

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

interface Deeplink {
    fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle) : Bundle
    fun validateIntent(intent: Intent?): Map<String, Any?>
}