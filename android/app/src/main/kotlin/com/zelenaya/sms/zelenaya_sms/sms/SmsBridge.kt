package com.zelenaya.sms.zelenaya_sms.sms

import android.content.ContentResolver
import android.provider.Telephony

object SmsBridge {

    // Номера, от которых ожидаем банковские уведомления.
    // Dart-парсер дополнительно фильтрует OTP и неизвестные форматы.
    private val bankSenders = setOf("900")

    // Читаем заведомо больше, чем нужно — Dart отфильтрует OTP и возьмёт нужное количество.
    private const val READ_BATCH = 200

    fun readLatestSms(contentResolver: ContentResolver, limit: Int): List<Map<String, Any?>> {
        val smsList = mutableListOf<Map<String, Any?>>()
        val projection = arrayOf(
            Telephony.Sms._ID,
            Telephony.Sms.ADDRESS,
            Telephony.Sms.BODY,
            Telephony.Sms.DATE,
        )

        // WHERE address IN ('900', ...)
        val placeholders = bankSenders.joinToString(",") { "?" }
        val selection = "${Telephony.Sms.ADDRESS} IN ($placeholders)"
        val selectionArgs = bankSenders.toTypedArray()

        val cursor = contentResolver.query(
            Telephony.Sms.Inbox.CONTENT_URI,
            projection,
            selection,
            selectionArgs,
            "${Telephony.Sms.DATE} DESC",
        ) ?: return smsList

        cursor.use {
            val addressIndex = it.getColumnIndex(Telephony.Sms.ADDRESS)
            val bodyIndex = it.getColumnIndex(Telephony.Sms.BODY)
            val dateIndex = it.getColumnIndex(Telephony.Sms.DATE)

            while (it.moveToNext() && smsList.size < READ_BATCH) {
                val sender = if (addressIndex >= 0) it.getString(addressIndex) else null
                val body = if (bodyIndex >= 0) it.getString(bodyIndex) else null
                val date = if (dateIndex >= 0) it.getLong(dateIndex) else 0L

                smsList.add(
                    hashMapOf(
                        "sender" to (sender ?: "unknown"),
                        "body" to (body ?: ""),
                        "dateTimeMillis" to date,
                    )
                )
            }
        }

        return smsList
    }
}
