import 'package:flutter_test/flutter_test.dart';
import 'package:sms_consent_for_otp_autofill/sms_consent_for_otp_autofill.dart';
import 'package:sms_consent_for_otp_autofill/sms_consent_for_otp_autofill_platform_interface.dart';
import 'package:sms_consent_for_otp_autofill/sms_consent_for_otp_autofill_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSmsConsentForOtpAutofillPlatform
    with MockPlatformInterfaceMixin
    implements SmsConsentForOtpAutofillPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SmsConsentForOtpAutofillPlatform initialPlatform =
      SmsConsentForOtpAutofillPlatform.instance;

  test('$MethodChannelSmsConsentForOtpAutofill is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelSmsConsentForOtpAutofill>());
  });

  test('getPlatformVersion', () async {
    SmsConsentForOtpAutofill smsConsentForOtpAutofillPlugin =
        SmsConsentForOtpAutofill();
    MockSmsConsentForOtpAutofillPlatform fakePlatform =
        MockSmsConsentForOtpAutofillPlatform();
    SmsConsentForOtpAutofillPlatform.instance = fakePlatform;

    //  expect(await smsConsentForOtpAutofillPlugin.getPlatformVersion(), '42');
  });
}
