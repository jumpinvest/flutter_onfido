package com.fluencybank.flutter_onfido

import android.content.Context
import androidx.annotation.NonNull
import com.onfido.android.sdk.capture.OnfidoFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterOnfidoPlugin */
class FlutterOnfidoPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var onfidoSdk: OnfidoSdk
  private lateinit var activityListener: OnfidoSdkActivityEventListener
  private lateinit var methodChannel: MethodChannel
  private lateinit var applicationContext: Context
  private lateinit var pluginBinding: ActivityPluginBinding

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    onAttachedToEngine(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }

  @Suppress("UNCHECKED_CAST")
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "start") {
      val arguments = call.arguments as HashMap<*, *>
      val config = arguments["config"] as HashMap<String, Any?>
      val listenToUserEvents = arguments["listenToUserEvents"] as? Boolean ?: false
      onfidoSdk.start(config, listenToUserEvents, result)
    } else {
      result.notImplemented()
    }
  }

  private fun onAttachedToEngine(context: Context, messenger: BinaryMessenger) {
    applicationContext = context
    methodChannel = MethodChannel(messenger, "flutter_onfido")
    methodChannel.setMethodCallHandler(this)
    val onfidoClient = OnfidoFactory.create(context).client
    activityListener = OnfidoSdkActivityEventListener(onfidoClient)
    onfidoSdk = OnfidoSdk(null, activityListener, onfidoClient, methodChannel, null)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    onfidoSdk.setActivity(null)
    pluginBinding.removeActivityResultListener(activityListener)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onReattachedToActivityForConfigChanges(binding)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    onfidoSdk.setActivity(binding.activity)
    pluginBinding = binding
    pluginBinding.addActivityResultListener(activityListener)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivityForConfigChanges()
  }
}
