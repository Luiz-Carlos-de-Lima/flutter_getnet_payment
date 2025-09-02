package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.services

import android.util.Log
import java.util.concurrent.Executors

object Worker {
    private val executor = Executors.newSingleThreadExecutor { r ->
        Thread(r, "Getnet-Worker").apply { isDaemon = true }
    }

    fun postToWorkerThread(task: () -> Unit) {
        executor.execute {
            try { task() } catch (t: Throwable) {
                Log.e("Worker", "Erro no worker", t)
            }
        }
    }
}
