package com.zelenaya.sms.zelenaya_sms.sms

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.telephony.SmsMessage
import io.flutter.plugin.common.EventChannel

class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action != "android.provider.Telephony.SMS_RECEIVED") {
            return
        }

        val extras = intent.extras ?: return
        val pdus = extras.get("pdus") as? Array<*> ?: return
        val format = extras.getString("format")

        for (pdu in pdus) {
            val smsMessage = createMessage(pdu, format) ?: continue
            eventSink?.success(
                hashMapOf(
                    "sender" to (smsMessage.displayOriginatingAddress ?: "unknown"),
                    "body" to (smsMessage.displayMessageBody ?: ""),
                    "dateTimeMillis" to smsMessage.timestampMillis,
                )
            )
        }
    }

    private fun createMessage(pdu: Any?, format: String?): SmsMessage? {
        val pduBytes = pdu as? ByteArray ?: return null
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            SmsMessage.createFromPdu(pduBytes, format)
        } else {
            @Suppress("DEPRECATION")
            SmsMessage.createFromPdu(pduBytes)
        }
    }

    companion object {
        var eventSink: EventChannel.EventSink? = null
    }
}
