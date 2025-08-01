package com.sms_consent_for_otp_autofill.sms_consent_for_otp_autofill

import android.app.Activity
import android.content.*
import androidx.annotation.NonNull
import com.google.android.gms.auth.api.credentials.Credential
import com.google.android.gms.auth.api.credentials.Credentials
import com.google.android.gms.auth.api.credentials.HintRequest
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.regex.Pattern
import android.content.ComponentName
import android.os.Build

/** SmsConsentForOtpAutofillPlugin */
class SmsConsentForOtpAutofillPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private lateinit var mActivity: Activity

  companion object {
    private const val CREDENTIAL_PICKER_REQUEST = 100
    private const val SMS_CONSENT_REQUEST = 200
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sms_consent_for_otp_autofill")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "requestPhoneNumber" -> {
        requestHint()
        result.success(null)
      }
      "requestSms" -> {
        SmsRetriever.getClient(mActivity.applicationContext).startSmsUserConsent(call.argument<String>("senderPhoneNumber"))

        val filter = IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
          mActivity.registerReceiver(smsVerificationReceiver, filter, Context.RECEIVER_EXPORTED)
        } else {
          mActivity.registerReceiver(smsVerificationReceiver, filter)
        }
        result.success(null)
      }
    }
  }
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    mActivity = binding.activity

    binding.addActivityResultListener { requestCode, resultCode, data ->
      when (requestCode) {
        CREDENTIAL_PICKER_REQUEST -> {// Obtain the phone number from the result
          if (resultCode == Activity.RESULT_OK && data != null) {
            channel.invokeMethod("selectedPhoneNumber", data.getParcelableExtra<Credential>(Credential.EXTRA_KEY)?.id)
          } else {
            channel.invokeMethod("selectedPhoneNumber", null)
          }
          true
        }
        SMS_CONSENT_REQUEST -> {// Obtain the phone number from the result
          if (resultCode == Activity.RESULT_OK && data != null) {
            channel
              .invokeMethod("receivedSms", parseOneTimeCode(data.getStringExtra(SmsRetriever.EXTRA_SMS_MESSAGE)))
            mActivity.unregisterReceiver(smsVerificationReceiver)
          } else {
            // Consent denied. User can type OTC manually.
            channel.invokeMethod("receivedSms", null)
            mActivity.unregisterReceiver(smsVerificationReceiver)
          }
          true
        }
        else -> false
      }
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  override fun onDetachedFromActivity() {}

  /// Construct a request for phone numbers and show the picker
  private fun requestHint() {
    mActivity.startIntentSenderForResult(
      Credentials.getClient(mActivity).getHintPickerIntent(HintRequest.Builder()
        .setPhoneNumberIdentifierSupported(true)
        .build()).intentSender,
      CREDENTIAL_PICKER_REQUEST,
      null, 0, 0, 0
    )
  }

  private val smsVerificationReceiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
      if (SmsRetriever.SMS_RETRIEVED_ACTION == intent.action) {
        val extras = intent.extras
        val smsRetrieverStatus = extras?.get(SmsRetriever.EXTRA_STATUS) as Status

        when (smsRetrieverStatus.statusCode) {
          CommonStatusCodes.SUCCESS -> {
            // Get consent intent
            try {
              // Start activity to show consent dialog to user, activity must be started in
              // 5 minutes, otherwise you'll receive another TIMEOUT intent
              val consentIntent: Intent = extras.getParcelable(SmsRetriever.EXTRA_CONSENT_INTENT)
                ?: //handle error
                return
              val flags: Int = consentIntent.getFlags()
              val name: ComponentName = consentIntent.resolveActivity(mActivity.packageManager)

              if (name !=null && name.packageName == "com.google.android.gms"
                && name.className == "com.google.android.gms.auth.api.phone.ui.UserConsentPromptActivity"
                && (flags and  Intent.FLAG_GRANT_READ_URI_PERMISSION == 0)
                && (flags and  Intent.FLAG_GRANT_WRITE_URI_PERMISSION == 0)
              ) {
                // Redirect the nested intent.
                mActivity.startActivityForResult(consentIntent, SMS_CONSENT_REQUEST)
              }
            } catch (e: ActivityNotFoundException) {
              // Handle the exception ...
            }
          }
          CommonStatusCodes.TIMEOUT -> {
            // Time out occurred, handle the error.
          }
        }
      }
    }
  }
  private fun parseOneTimeCode(message: String?): String? {
    val pattern = Pattern.compile("\\d{6,10}")
    if (message != null) {
      val matcher = pattern.matcher(message)
      if (!matcher.find()) return message
      return matcher.group(0)
    }
    return null
  }
}
