package com.vanelizarov.flutter_image_utils

import android.app.Activity
import android.graphics.BitmapFactory
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class CallHandler(var call: MethodCall, var result: MethodChannel.Result) {
    companion object {
        @JvmStatic
        private val executor = Executors.newFixedThreadPool(5)
    }

    fun handle(activity: Activity) {
        executor.execute {
            when (call.method) {
                "crop" -> {
                    val bytes = call.argument<ByteArray>("bytes")!!
                    val x = call.argument<Int>("x")!!
                    val y = call.argument<Int>("y")!!
                    val width = call.argument<Int>("width")!!
                    val height = call.argument<Int>("height")!!
                    val quality = call.argument<Int>("quality")!!

                    try {

                        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.count())
                        val exifRotation = Exif.getRotationDegrees(bytes)

                        activity.runOnUiThread(java.lang.Runnable {
                            result.success(bitmap.crop(x, y, width, height, exifRotation).toByteArray(quality))
                        })
                    } catch (e: Exception) {
                        activity.runOnUiThread(java.lang.Runnable {
                            result.success(null)
                        })
                    }
                }

                "rotate" -> {
                    val bytes = call.argument<ByteArray>("bytes")!!
                    val angle = call.argument<Int>("angle")!!
                    val quality = call.argument<Int>("quality")!!

                    try {

                        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.count())
                        val exifRotation = Exif.getRotationDegrees(bytes)

                        activity.runOnUiThread(java.lang.Runnable {
                            result.success(bitmap.rotate(angle + exifRotation).toByteArray(quality))
                        })

                    } catch (e: Exception) {
                        activity.runOnUiThread(java.lang.Runnable {
                            result.success(null)
                        })
                    }
                }

                "resize" -> {
                    val bytes = call.argument<ByteArray>("bytes")!!
                    val destWidth = call.argument<Int>("destWidth")!!
                    val destHeight = call.argument<Int>("destHeight")!!
                    val quality = call.argument<Int>("quality")!!

                    try {

                        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.count())
                        val exifRotation = Exif.getRotationDegrees(bytes)

                        activity.runOnUiThread(java.lang.Runnable {
                            result.success(bitmap.resize(destWidth, destHeight, exifRotation).toByteArray(quality))
                        })
                    } catch (e: Exception) {
                        activity.runOnUiThread(java.lang.Runnable {
                            result.success(null)
                        })
                    }
                }

                "resizeToMax" -> {
                    val bytes = call.argument<ByteArray>("bytes")!!
                    val maxSize = call.argument<Int>("maxSize")!!
                    val quality = call.argument<Int>("quality")!!

                    try {

                        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.count())
                        val exifRotation = Exif.getRotationDegrees(bytes)

                        activity.runOnUiThread(java.lang.Runnable {
                            result.success(bitmap.resizeToMax(maxSize, exifRotation).toByteArray(quality))
                        })
                    } catch (e: Exception) {
                        activity.runOnUiThread(java.lang.Runnable {
                            result.success(null)
                        })

                    }
                }
            }
        }
    }
}