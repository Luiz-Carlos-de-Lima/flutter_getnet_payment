package br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment.services

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.os.Bundle
import android.util.Base64
import android.util.Log

class GenerateBitmap {
    fun convertPrintableItemsToBitmap(context: Context, data: List<Bundle>): Bitmap? {
        try {
            val listMap = convertPrintableContentInMapAndReturn(data)


            val bitmaps = mutableListOf<Bitmap>()

            listMap.forEach { item ->
                if (item["type"] == "image") {
                    val originalBase64 = item["imagePath"] ?: ""
                    if (originalBase64.isNotBlank()) {
                        val decodedBytes = Base64.decode(originalBase64, Base64.DEFAULT)
                        val originalBitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
                        originalBitmap?.let {
                            val resized = resizeBitmapToPrinterWidth(it)
                            bitmaps.add(ensureWhiteBackground(resized))
                        }
                    }
                } else {
                    Log.d("condicional Content", "Inicio")

                    val content = item["content"] ?: ""
                    if (content.isNotBlank()) {
                        val align = item["align"] ?: "left"
                        val size = item["size"] ?: "small"
                        val textBitmap = createTextBitmap(context, content, align, size)
                        bitmaps.add(convertTo1BitBitmap(textBitmap))
                    }
                }
            }

            if (bitmaps.isEmpty()) {
                bitmaps.add(Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888).apply {
                    eraseColor(Color.WHITE)
                })
            }

            return mergeBitmapsVertically(bitmaps)
        } catch (e: Exception) {
            return null;
        }
    }

    private fun resizeBitmapToPrinterWidth(bitmap: Bitmap, targetWidth: Int = 384): Bitmap {
        val aspectRatio = bitmap.height.toFloat() / bitmap.width.toFloat()
        val targetHeight = (targetWidth * aspectRatio).toInt()
        return Bitmap.createScaledBitmap(bitmap, targetWidth, targetHeight, true)
    }

    private fun mergeBitmapsVertically(bitmaps: List<Bitmap>): Bitmap {
        if (bitmaps.isEmpty()) {
            return Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888).apply { eraseColor(Color.WHITE) }
        }

        val width = maxOf(1, bitmaps.maxOf { it.width })
        val totalHeight = maxOf(1, bitmaps.sumOf { it.height })

        val result = Bitmap.createBitmap(width, totalHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(result)
        canvas.drawColor(Color.WHITE)

        var currentHeight = 0
        for (bmp in bitmaps) {
            canvas.drawBitmap(bmp, 0f, currentHeight.toFloat(), null)
            currentHeight += bmp.height
        }

        return result
    }

    private fun ensureWhiteBackground(source: Bitmap): Bitmap {
        val result = Bitmap.createBitmap(
            maxOf(1, source.width),
            maxOf(1, source.height),
            Bitmap.Config.ARGB_8888
        )
        val canvas = Canvas(result)
        canvas.drawColor(Color.WHITE)
        canvas.drawBitmap(source, 0f, 0f, null)
        return result
    }

    private fun convertTo1BitBitmap(source: Bitmap): Bitmap {
        val width = source.width
        val height = source.height
        val bwBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)

        val canvas = Canvas(bwBitmap)
        val paint = Paint()
        canvas.drawColor(Color.WHITE)

        for (y in 0 until height) {
            for (x in 0 until width) {
                val pixel = source.getPixel(x, y)
                val r = Color.red(pixel)
                val g = Color.green(pixel)
                val b = Color.blue(pixel)
                val gray = (0.299 * r + 0.587 * g + 0.114 * b).toInt()
                val color = if (gray < 128) Color.BLACK else Color.WHITE
                paint.color = color
                canvas.drawPoint(x.toFloat(), y.toFloat(), paint)
            }
        }

        return bwBitmap
    }

    private fun convertPrintableContentInMapAndReturn(printableContent: List<Bundle>): MutableList<Map<String, String>> {
        val newListPrintable: MutableList<Map<String, String>> = ArrayList()
        for (content: Bundle in printableContent) {
            val map: Map<String, String> = content.keySet().associateWith { key ->
                content.getString(key).toString()
            }
            newListPrintable.add(map)
        }
        return newListPrintable
    }

    private fun createTextBitmap(
        context: Context,
        content: String,
        align: String,
        size: String
    ): Bitmap {
        val maxCharsPerLine = when (size) {
            "big", "medium" -> 32
            "small" -> 48
            else -> 48
        }

        val fontSize = when (size) {
            "big" -> 20f
            "medium" -> 18f
            "small" -> 14f
            else -> 14f
        }

        val paint = Paint().apply {
            color = Color.BLACK
            textSize = fontSize
            typeface = Typeface.createFromAsset(context.assets, "fonts/JetBrainsMono-Bold.ttf")
            isAntiAlias = true
        }

        val lines = if (content.isEmpty()) listOf(" ")
        else content.split("\n").flatMap { line ->
            if (line.trim().isEmpty()) {
                listOf(line)
            } else {
                splitLine(line, maxCharsPerLine)
            }
        }

        val metrics = paint.fontMetrics
        val lineHeight = maxOf(1, (metrics.bottom - metrics.top).toInt())
        val width = 384
        val height = maxOf(1, lineHeight * lines.size)

        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        canvas.drawColor(Color.WHITE)

        lines.forEachIndexed { index, line ->
            val x = when (align) {
                "center" -> (width - paint.measureText(line)) / 2
                "right" -> (width - paint.measureText(line))
                else -> 0f
            }
            val y = (index * lineHeight) - paint.fontMetrics.top

            if (line.trim().isEmpty()) {

                canvas.drawPoint(0f, y, Paint().apply { color = Color.TRANSPARENT })
            } else {
                canvas.drawText(line, x, y, paint)
            }
        }

        return bitmap
    }

    private fun splitLine(text: String, maxChars: Int): List<String> {
        val result = mutableListOf<String>()
        var start = 0
        while (start < text.length) {
            val end = minOf(start + maxChars, text.length)
            result.add(text.substring(start, end))
            start = end
        }
        return result
    }
}