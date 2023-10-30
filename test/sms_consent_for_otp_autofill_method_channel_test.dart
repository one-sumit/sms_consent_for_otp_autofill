import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sms_consent_for_otp_autofill/sms_consent_for_otp_autofill_method_channel.dart';

void main() {
  MethodChannelSmsConsentForOtpAutofill platform =
      MethodChannelSmsConsentForOtpAutofill();
  const MethodChannel channel = MethodChannel('sms_consent_for_otp_autofill');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
