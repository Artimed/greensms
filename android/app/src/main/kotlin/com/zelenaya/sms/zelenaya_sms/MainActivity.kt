package com.zelenaya.sms.zelenaya_sms

import android.Manifest
import android.content.pm.PackageManager
import android.telephony.SmsManager
import androidx.core.content.ContextCompat
import com.zelenaya.sms.zelenaya_sms.sms.SmsBridge
import com.zelenaya.sms.zelenaya_sms.sms.SmsReceiver
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "readLatestSms" -> {
                    if (!hasSmsPermission()) {
                        result.error(
                            "PERMISSION_DENIED",
                            "READ_SMS permission is required",
                            null,
                        )
                        return@setMethodCallHandler
                    }

                    val limit = call.argument<Int>("limit") ?: 10
                    try {
                        val smsList = SmsBridge.readLatestSms(contentResolver, limit)
                        result.success(smsList)
                    } catch (error: Exception) {
                        result.error("SMS_READ_FAILED", error.message, null)
                    }
                }

                "sendDirectSms" -> {
                    if (!hasSendSmsPermission()) {
                        result.error(
                            "PERMISSION_DENIED",
                            "SEND_SMS permission is required",
                            null,
                        )
                        return@setMethodCallHandler
                    }

                    val address = call.argument<String>("address")
                    val body = call.argument<String>("body")
                    if (address.isNullOrBlank() || body.isNullOrBlank()) {
                        result.error(
                            "INVALID_ARGUMENTS",
                            "address and body are required",
                            null,
                        )
                        return@setMethodCallHandler
                    }

                    try {
                        @Suppress("DEPRECATION")
                        val smsManager = SmsManager.getDefault()
                        val parts = smsManager.divideMessage(body)
                        if (parts.size > 1) {
                            smsManager.sendMultipartTextMessage(address, null, parts, null, null)
                        } else {
                            smsManager.sendTextMessage(address, null, body, null, null)
                        }
                        result.success(true)
                    } catch (error: Exception) {
                        result.error("SMS_SEND_FAILED", error.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL,
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                SmsReceiver.eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                SmsReceiver.eventSink = null
            }
        })
    }

    private fun hasSmsPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.READ_SMS,
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun hasSendSmsPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.SEND_SMS,
        ) == PackageManager.PERMISSION_GRANTED
    }

    companion object {
        private const val METHOD_CHANNEL = "zelenaya_sms/sms_method"
        private const val EVENT_CHANNEL = "zelenaya_sms/sms_events"
    }
}
