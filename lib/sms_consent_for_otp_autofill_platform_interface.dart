import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sms_consent_for_otp_autofill_method_channel.dart';

abstract class SmsConsentForOtpAutofillPlatform extends PlatformInterface {
  /// Constructs a SmsConsentForOtpAutofillPlatform.
  SmsConsentForOtpAutofillPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmsConsentForOtpAutofillPlatform _instance =
      MethodChannelSmsConsentForOtpAutofill();

  /// The default instance of [SmsConsentForOtpAutofillPlatform] to use.
  ///
  /// Defaults to [MethodChannelSmsConsentForOtpAutofill].
  static SmsConsentForOtpAutofillPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SmsConsentForOtpAutofillPlatform] when
  /// they register themselves.
  static set instance(SmsConsentForOtpAutofillPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
