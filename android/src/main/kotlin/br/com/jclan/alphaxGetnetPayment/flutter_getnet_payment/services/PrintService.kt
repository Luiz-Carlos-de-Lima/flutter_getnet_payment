package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.services

import android.os.Bundle
import com.getnet.posdigital.PosDigital
import com.getnet.posdigital.PosDigitalRuntimeException
import com.getnet.posdigital.printer.AlignMode
import com.getnet.posdigital.printer.FontFormat
import com.getnet.posdigital.printer.IPrinterService
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import com.getnet.posdigital.printer.IPrinterCallback
import com.getnet.posdigital.printer.PrinterStatus
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


class PrintService {
    private var printer: IPrinterService? = null

    fun start(
        printerCallback: IPrinterCallback,
        printableContent: List<Bundle>?,
        binding: ActivityPluginBinding
    ): Bundle {
        try {
            if (PosDigital.getInstance().isInitiated){
                Worker.postToWorkerThread {
                    try {
                        validatePrintContent(printableContent)
                        printer =  PosDigital.getInstance().printer
                        printer!!.init()

                        val bitmap: Bitmap = GenerateBitmap()
                            .convertPrintableItemsToBitmap(binding.activity, printableContent!!)
                            ?: throw IllegalStateException("Não foi possível gerar o bitmap de impressão!")

                        printer!!.addImageBitmap(0, bitmap)
                        printer!!.printAndRemovePaper(printerCallback)

                        if (printer!!.status == PrinterStatus.OK || printer!!.status == PrinterStatus.PRINTING) {
                            printerCallback.onSuccess()
                        } else {
                            printerCallback.onError(printer!!.status)
                        }
                    } catch (e: IllegalArgumentException) {
                        printerCallback.onError(1000)
                    } catch (e: IllegalStateException) {
                        printerCallback.onError(1000)
                    } catch (e: Exception) {
                        printerCallback.onError(1000)
                    }
                }

                return Bundle().apply {
                    putString("code", "SUCCESS")
                    putBoolean("data", true)
                }
            } else {
                return Bundle().apply {
                    putString("code", "ERROR")
                    putString("message", "Instance of PosDigital not initialized") }
            }
        } catch (e: PosDigitalRuntimeException) {
            return Bundle().apply {
                putString("code", "ERROR")
                putString("message", e.message)
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

    private fun validatePrintContent(printableContent: List<Bundle>?) {
        if (printableContent == null) {
            throw IllegalArgumentException("Invalid print data: printable_content")
        }

        for (content: Bundle in printableContent) {
            val type: String? = content.getString("type")
            if (type == "text") {
                val contentOfType: String? = content.getString("content")
                val align: String? = content.getString("align")
                val size: String? = content.getString("size")

                if (contentOfType == null) throw IllegalArgumentException("Invalid printable_content data: content can't null when type equal 'text'")
                if (align !in listOf("center", "right", "left")) throw IllegalArgumentException("Invalid printable_content data: align cannot be different from 'center | right | left' when type equal 'text'")
                if (size !in listOf("big", "medium","small")) throw IllegalArgumentException("Invalid printable_content data: size  cannot be different from 'big | medium | small' when type equal 'text'")
            } else if (type == "line") {
                if(content.getString("content") == null) {
                    throw IllegalArgumentException("Invalid printable_content data: content can't null when type equal 'text'")
                }
            } else if (type == "image") {
                if (content.getString("imagePath") == null) {
                    throw IllegalArgumentException("Invalid printable_content data: content can't null when type equal 'text'")
                }
            }
        }
    }

    private fun setValuePrint (printableContent: List<Bundle>) {
        if (printer != null) {
            for (content: Bundle in printableContent) {
                val type: String = content.getString("type")!!
                when (type) {
                    "text" -> {
                        val contentOfType: String? = content.getString("content")
                        val align: String? = content.getString("align")
                        val size: String? = content.getString("size")

                        val formatSize = when (size) {
                            "small" -> {
                                FontFormat.SMALL
                            }

                            "medium" -> {
                                FontFormat.MEDIUM
                            }

                            "big" -> {
                                FontFormat.LARGE
                            }

                            else -> {
                                FontFormat.MEDIUM
                            }
                        }

                        val alignMode = when (align) {
                            "left" -> {
                                AlignMode.LEFT
                            }

                            "center" -> {
                                AlignMode.CENTER
                            }

                            "right" -> {
                                AlignMode.RIGHT
                            }

                            else -> {
                                AlignMode.LEFT
                            }
                        }


                        printer!!.defineFontFormat(formatSize)
                        printer!!.addText(alignMode, contentOfType ?: "Conteúdo para imprimir null")
                    }
                    "line" -> {
                        printer!!.defineFontFormat(FontFormat.MEDIUM)
                        printer!!.addText(AlignMode.LEFT, content.getString("content") ?: "Conteúdo para imprimir null")
                    }
                    "image" -> {
                        val imagePath = content.getString("imagePath")
                        printer!!.addImageBitmap(AlignMode.CENTER, decodeBase64ToBitmap(imagePath))
                    }
                    else -> {
                        throw IllegalArgumentException("Invalid printable_content data: Invalid type")
                    }
                }
            }
            printer!!.addText(AlignMode.LEFT, "\n\n")
        }
    }

    private fun decodeBase64ToBitmap(base64String: String?): Bitmap {
        val decodedBytes: ByteArray = Base64.decode(base64String, Base64.DEFAULT)
        return BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
    }
}