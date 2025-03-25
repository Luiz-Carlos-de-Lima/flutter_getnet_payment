package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.services

import android.os.Bundle
import com.getnet.posdigital.PosDigital
import com.getnet.posdigital.PosDigitalRuntimeException
import com.getnet.posdigital.printer.AlignMode
import com.getnet.posdigital.printer.FontFormat
import com.getnet.posdigital.printer.IPrinterService
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Binder
import android.os.IBinder
import android.util.Base64;
import com.getnet.posdigital.printer.PrinterStatus


class PrintService {
    private val printer: IPrinterService = PosDigital.getInstance().printer

    fun start(printableContent: List<Bundle>?) : Bundle {
        try {
            if (PosDigital.getInstance().isInitiated){
            validatePrintContent(printableContent)
            printer.init()
            printer.setGray(5)
            setValuePrint(printableContent!!)

            val callback = object : com.getnet.posdigital.printer.IPrinterCallback {
                override fun asBinder(): IBinder {
                    return Binder()
                }

                override fun onSuccess() {
                    println("Impressão concluída com sucesso!")
                }

                override fun onError(p0: Int) {
                    println("Impressão não concluída")
                }
            }

            printer.printAndRemovePaper(callback)

            when(printer.status) {
                PrinterStatus.OK -> {
                    return Bundle().apply {
                        putString("code", "SUCCESS")
                        putString("message", "OK")
                    }
                }
                PrinterStatus.PRINTING -> {
                    return Bundle().apply {
                        putString("code", "SUCCESS")
                        putString("message", "Imprimindo")
                    }
                }
                PrinterStatus.ERROR_NOT_INIT -> return Bundle().apply {
                    putString("code", "ERROR")
                    putString("message", "Impressora não iniciada")
                }
                PrinterStatus.ERROR_OVERHEAT -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Impressora não iniciada")
                    }
                }
                PrinterStatus.ERROR_BUFOVERFLOW -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Impressora superaquecida")
                    }
                }
                PrinterStatus.ERROR_PARAM -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Fila de impressão muito grande")
                    }
                }
                PrinterStatus.ERROR_LIFTHEAD -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Parâmetros incorretos")
                    }
                }
                PrinterStatus.ERROR_LOWTEMP -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Porta da impressora aberta")
                    }
                }
                PrinterStatus.ERROR_LOWVOL -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Temperatura baixa demais para impressão")
                    }
                }
                PrinterStatus.ERROR_MOTORERR -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Sem bateria suficiente para impressão")
                    }
                }
                PrinterStatus.ERROR_NO_PAPER -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Motor de passo com problemas")
                    }
                }
                PrinterStatus.ERROR_PAPERENDING -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Sem bobina")
                    }
                }
                PrinterStatus.ERROR_PAPERJAM -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Bobina acabando")
                    }
                }
                PrinterStatus.UNKNOW -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Não foi possível definir o erro")
                    }
                }
                else -> {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Impressora não iniciada")
                    }
                }
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


                    printer.defineFontFormat(formatSize)
                    printer.addText(alignMode, contentOfType ?: "Conteúdo para imprimir null")
                }
                "line" -> {
                    printer.defineFontFormat(FontFormat.MEDIUM)
                    printer.addText(AlignMode.LEFT, content.getString("content") ?: "Conteúdo para imprimir null")
                }
                "image" -> {
                    val imagePath = content.getString("imagePath")
                    printer.addImageBitmap(AlignMode.CENTER, decodeBase64ToBitmap(imagePath))
                }
                else -> {
                    throw IllegalArgumentException("Invalid printable_content data: Invalid type")
                }
            }
        }
        printer.addText(AlignMode.LEFT, "\n\n")
    }

    private fun decodeBase64ToBitmap(base64String: String?): Bitmap {
        val decodedBytes: ByteArray = Base64.decode(base64String, Base64.DEFAULT)
        return BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
    }
}