package com.fondeadora.au10tix_flutter

import android.content.Context
import android.content.Intent
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import androidx.annotation.NonNull
import com.fondeadora.au10tix_flutter.views.fragments.ID_TYPE
import com.fondeadora.au10tix_flutter.views.fragments.TOKEN

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** Au10tixFlutterPlugin */
class Au10tixFlutterPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var context: Context

  /// The MethodChannel that will the communication between Flutter  and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "au10tix_flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext;

  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "verifyId") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
      val intent = Intent(context, Au10tixMainActivity :: class.java)
      intent.addFlags(FLAG_ACTIVITY_NEW_TASK);
      intent.putExtra(TOKEN,call.argument<String>("token"))
      intent.putExtra(ID_TYPE,call.argument<String>("identification"))
      context.startActivity(intent);
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
