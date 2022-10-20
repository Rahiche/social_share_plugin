package com.cygnati.social_share_plugin

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import java.io.File

/**
 * SocialSharePlugin
 */
class SocialSharePlugin : FlutterPlugin, ActivityAware, MethodCallHandler,
  ActivityResultListener {
  private var activity: Activity? = null
  private var channel: MethodChannel? = null
  override fun onAttachedToEngine(binding: FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "social_share_plugin")
    channel!!.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
  }
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    binding.addActivityResultListener(this)
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    binding.addActivityResultListener(this)
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (requestCode == TWITTER_REQUEST_CODE) {
      if (resultCode == Activity.RESULT_OK) {
        Log.d("SocialSharePlugin", "Twitter share done.")
        channel!!.invokeMethod("onSuccess", null)
      } else if (resultCode == Activity.RESULT_CANCELED) {
        Log.d("SocialSharePlugin", "Twitter cancelled.")
        channel!!.invokeMethod("onCancel", null)
      }
      return true
    }
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    val pm = activity!!.packageManager
    when (call.method) {
      "getPlatformVersion" -> result.success("Android " + Build.VERSION.RELEASE)
      "shareToTwitterLink" -> try {
        pm.getPackageInfo(TWITTER_PACKAGE_NAME, PackageManager.GET_ACTIVITIES)
        twitterShareLink(call.argument("text"), call.argument("url"))
        result.success(true)
      } catch (e: PackageManager.NameNotFoundException) {
        openPlayStore(TWITTER_PACKAGE_NAME)
        result.success(false)
      }
      else -> result.notImplemented()
    }
  }

  private fun openPlayStore(packageName: String) {
    try {
      val playStoreUri = Uri.parse("market://details?id=$packageName")
      val intent = Intent(Intent.ACTION_VIEW, playStoreUri)
      activity!!.startActivity(intent)
    } catch (e: ActivityNotFoundException) {
      val playStoreUri = Uri.parse("https://play.google.com/store/apps/details?id=$packageName")
      val intent = Intent(Intent.ACTION_VIEW, playStoreUri)
      activity!!.startActivity(intent)
    }
  }


  private fun twitterShareLink(text: String?, url: String?) {
    val tweetUrl = String.format("https://twitter.com/intent/tweet?text=%s&url=%s", text, url)
    val uri = Uri.parse(tweetUrl)
    activity!!.startActivityForResult(Intent(Intent.ACTION_VIEW, uri), TWITTER_REQUEST_CODE)
  }

  companion object {
    private const val TWITTER_PACKAGE_NAME = "com.twitter.android"
    private const val TWITTER_REQUEST_CODE = 0xc0ce
  }
}
