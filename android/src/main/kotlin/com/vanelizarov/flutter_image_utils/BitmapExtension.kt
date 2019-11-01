package com.vanelizarov.flutter_image_utils

import android.graphics.Bitmap
import android.graphics.Matrix
import java.io.ByteArrayOutputStream

fun Bitmap.crop(x: Int, y: Int, width: Int, height: Int, angle: Int): Bitmap {
    // compared to iOS cropping Android does not support rect overlapping
    // so we need to constrain dest width and height

    var sw = this.width
    var sh = this.height

    var dx = 0
    var dy = 0
    var dw = 0
    var dh = 0

    when (angle) {
        0 -> {
            dx = x
            dy = y
            dw = width
            dh = height
        }
        90 -> {
            dx = y
            dy = sh - x - width
            dw = height
            dh = width
        }
        180 -> {
            dx = sw - x - width
            dy = sh - y - height
            dw = width
            dh = height
        }
        270 -> {
            dx = sh - y - height
            dy = x
            dw = height
            dh = width
        }
    }

    dx = dx.coerceIn(0, sw)
    dy = dy.coerceIn(0, sh)
    dw = dw.coerceIn(0, sw - dx)
    dh = dh.coerceIn(0, sh - dy)

    val matrix = Matrix()
    matrix.preRotate(angle.toFloat())

    return  Bitmap.createBitmap(this, dx, dy, dw, dh, matrix, true)
}

fun Bitmap.rotate(angle: Int): Bitmap {
    return if (angle % 360 != 0) {
        val matrix = Matrix()
        matrix.setRotate(angle.toFloat())
        Bitmap.createBitmap(this, 0, 0, width, height, matrix, false)
    } else {
        this
    }
}

fun Bitmap.resize(destWidth: Int, destHeight: Int, angle: Int): Bitmap {
    return Bitmap.createScaledBitmap(this, destWidth, destHeight, true)
            .rotate(angle)
}

fun Bitmap.resizeToMax(maxSize: Int, angle: Int): Bitmap {

    var nextWidth = maxSize
    var nextHeight = maxSize

    if (this.width > this.height) {
        nextHeight = this.height * maxSize / this.width
    } else if (this.height > this.width) {
        nextWidth = this.width * maxSize / this.height
    }

    return Bitmap.createScaledBitmap(this, nextWidth, nextHeight, true)
            .rotate(angle)
}

fun Bitmap.toByteArray(quality: Int, format: Int): ByteArray {
    val stream = ByteArrayOutputStream()
    if (format == 0) { // jpeg
        this.compress(Bitmap.CompressFormat.JPEG, quality, stream)
    } else { // png
        this.compress(Bitmap.CompressFormat.PNG, quality, stream)
    }
    return stream.toByteArray()
}


























