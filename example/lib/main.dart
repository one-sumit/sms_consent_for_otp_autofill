import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:sms_consent_for_otp_autofill/sms_consent_for_otp_autofill.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SmsConsentForOtpAutofill smsConsentForOtpAutoFill;
  OtpFieldController otpbox = OtpFieldController();
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    smsConsentForOtpAutoFill =
        SmsConsentForOtpAutofill(phoneNumberListener: (number) {
      phoneNumber = number;
      print("number...................${number}");
    }, smsListener: (otpcode) {
      print("otp...................${otpcode}");
      setState(() {
        this.startListen = false;
      });
      setState(() {
        //prase code from the OTP sms
        otpbox.set(otpcode.split(""));
      });
    });
  }

  @override
  void dispose() {
    smsConsentForOtpAutoFill.dispose();
    super.dispose();
  }

  bool startListen = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS consent For Otp AutoFill'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Center(
                child: Text(
                  "Enter OTP Code",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              OTPTextField(
                controller: otpbox,
                length: 6,
                width: double.infinity,
                fieldWidth: 50,
                style: const TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  print("Entered OTP Code: $pin");
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text(
                        startListen == false ? 'Stopped' : 'Stop Listening'),
                    onPressed: () async {
                      smsConsentForOtpAutoFill.dispose();
                      setState(() {
                        this.startListen = false;
                      });
                      print("Stop Listening.........");
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text(startListen ? 'Started' : 'Start Listening'),
                    onPressed: () async {
                      smsConsentForOtpAutoFill.requestSms();
                      setState(() {
                        this.startListen = true;
                      });
                      print("Start Listening.........");
                    },
                  ),
                ],
              ),
              // const SizedBox(
              //   width: 20,
              // ),
              // MaterialButton(
              //   color: Colors.green,
              //   textColor: Colors.white,
              //   child: const Text("Select phone number"),
              //   onPressed: () async {
              //     smsConsentForOtpAutoFill.requestPhoneNumber();
              //     print("Start  Listening.........");
              //   },
              // ),
              // const SizedBox(
              //   width: 10,
              // ),
              //  Text("Selected Number  $phoneNumber"),
            ],
          ),
        ),
      ),
    );
  }
}
