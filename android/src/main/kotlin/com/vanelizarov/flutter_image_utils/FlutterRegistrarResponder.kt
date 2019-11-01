package com.vanelizarov.flutter_image_utils

import android.app.Activity

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

abstract class FlutterRegistrarResponder {
    protected var flutterRegistrar: PluginRegistry.Registrar? = null

    protected fun replySuccess(result: MethodChannel.Result, response: Any?) {
        runOnMainThread(Runnable { result.success(response) })
    }

    private fun runOnMainThread(runnable: Runnable) {
        (flutterRegistrar!!.activeContext() as Activity).runOnUiThread(runnable)
    }
}