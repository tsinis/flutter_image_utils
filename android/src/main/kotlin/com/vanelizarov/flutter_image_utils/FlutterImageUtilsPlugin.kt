package com.vanelizarov.flutter_image_utils

import android.graphics.BitmapFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterImageUtilsPlugin(registrar: Registrar): MethodCallHandler, FlutterRegistrarResponder() {

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_image_utils")
      channel.setMethodCallHandler(FlutterImageUtilsPlugin(registrar))
    }
  }

  init {
    this.flutterRegistrar = registrar
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    handle(call, result)
  }

  private fun handle(call: MethodCall, result: Result) {
    when (call.method) {
      "crop" -> {
        val bytes = call.argument<ByteArray>("bytes")!!
        val x = call.argument<Int>("x")!!
        val y = call.argument<Int>("y")!!
        val width = call.argument<Int>("width")!!
        val height = call.argument<Int>("height")!!
        val quality = call.argument<Int>("quality")!!
        val format = call.argument<Int>("format")!!

        try {

          val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.count())
          val exifRotation = Exif.getRotationDegrees(bytes)

          replySuccess(result, bitmap.crop(x, y, width, height, exifRotation).toByteArray(quality, format))
        } catch (e: Exception) {
          replySuccess(result, null)
        }
      }

      "rotate" -> {
        val bytes = call.argument<ByteArray>("bytes")!!
        val angle = call.argument<Int>("angle")!!
        val quality = call.argument<Int>("quality")!!
        val format = call.argument<Int>("format")!!

        try {

          val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.count())
          val exifRotation = Exif.getRotationDegrees(bytes)

          replySuccess(result, bitmap.rotate(angle + exifRotation).toByteArray(quality, format))
        } catch (e: Exception) {
          replySuccess(result, null)
        }
      }

      "resize" -> {
        val bytes = call.argument<ByteArray>("bytes")!!
        val destWidth = call.argument<Int>("destWidth")!!
        val destHeight = call.argument<Int>("destHeight")!!
        val quality = call.argument<Int>("quality")!!
        val format = call.argument<Int>("format")!!

        try {

          val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.count())
          val exifRotation = Exif.getRotationDegrees(bytes)

          replySuccess(result, bitmap.resize(destWidth, destHeight, exifRotation).toByteArray(quality, format))
        } catch (e: Exception) {
          replySuccess(result, null)
        }
      }

      "resizeToMax" -> {
        val bytes = call.argument<ByteArray>("bytes")!!
        val maxSize = call.argument<Int>("maxSize")!!
        val quality = call.argument<Int>("quality")!!
        val format = call.argument<Int>("format")!!

        try {

          val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.count())
          val exifRotation = Exif.getRotationDegrees(bytes)

          replySuccess(result, bitmap.resizeToMax(maxSize, exifRotation).toByteArray(quality, format))
        } catch (e: Exception) {
          replySuccess(result, null)
        }
      }
    }
  }
}
