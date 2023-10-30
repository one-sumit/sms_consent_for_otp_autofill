import 'package:flutter/services.dart';

class SmsConsentForOtpAutofill {
  static const MethodChannel _channel =
      MethodChannel('sms_consent_for_otp_autofill');
  Function? _phoneNumberListener;
  Function? _smsListener;
  String? _selectedPhoneNumber;
  String? _receivedSms;

  /// Last selected phone number
  String? get selectedPhoneNumber => _selectedPhoneNumber;

  /// Last received sms
  String? get receivedSms => _receivedSms;

  SmsConsentForOtpAutofill(
      {Function? phoneNumberListener, Function? smsListener}) {
    _phoneNumberListener = phoneNumberListener;
    _smsListener = smsListener;
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'selectedPhoneNumber':
          _selectedPhoneNumber = call.arguments;
          // _phoneNumberListener!();
          if (_phoneNumberListener != null) {
            _phoneNumberListener!(_selectedPhoneNumber);
          }
          break;
        case 'receivedSms':
          _receivedSms = call.arguments;
          if (_smsListener != null) _smsListener!(_receivedSms);
          //_smsListener!();
          break;
        default:
      }
    });
  }

  /// Clears last phone number, sms and their respective listeners.
  void dispose() {
    _selectedPhoneNumber = null;
    _receivedSms = null;
    _phoneNumberListener = null;
    _smsListener = null;
  }

  /// Updates Phone number listener
  void updatePhoneNumberListener(Function listener) =>
      _phoneNumberListener = listener;

  /// Updates Sms listener
  void updateSmsListener(Function listener) => _smsListener = listener;

  /// Optional (not required for receiving sms): Get user's phone number.
  ///
  /// In case of multiple sim, a dialog is displayed.
  void requestPhoneNumber() async =>
      await _channel.invokeMethod('requestPhoneNumber');

  /// If you know the phone number from which the SMS message will originate,
  /// specify it (otherwise, sms from any number satisfying the
  /// [SMS User Consent API](https://developers.google.com/identity/sms-retriever/user-consent/request#2_start_listening_for_incoming_messages)
  /// will be received.
  ///
  /// Once a sms is received, you will have to call this method again to receive
  /// another sms.
  void requestSms({String? senderPhoneNumber}) async => await _channel
      .invokeMethod('requestSms', {"senderPhoneNumber": senderPhoneNumber});
}

// class SmsConsentForOtpAutofill {
//   Future<String?> getPlatformVersion() {
//     return SmsConsentForOtpAutofillPlatform.instance.getPlatformVersion();
//   }
// }
