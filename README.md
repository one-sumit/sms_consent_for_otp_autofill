# sms_consent_for_otp_autofill
Flutter plugin for otp auto fill, used SMS Consent API to retrieve the otp of a single SMS message if the user gives permission. For Android, that's where this package is useful. No need for iOS, using Android's [SMS User Consent API](https://developers.google.com/identity/sms-retriever/user-consent/overview)

## Screenshots

<p float="left">
  <img src="https://github.com/mdyousufbhuiyan/sms_consent_for_otp_autofill/assets/26599846/b0893bd6-afce-4a50-be7b-7a744135ccf5" width="250" />
  <img src="https://github.com/mdyousufbhuiyan/sms_consent_for_otp_autofill/assets/26599846/7d9c5abd-34b8-4f1b-a1b8-0cf95e62f8be" width="250" />
  <img src="https://github.com/mdyousufbhuiyan/sms_consent_for_otp_autofill/assets/26599846/4bc3518e-b3fd-41a2-baf3-bdbe73bb0e0d" width="250" /> 
</p>

## Steps to use

## import 'package:sms_consent_for_otp_autofill/sms_consent_for_otp_autofill.dart';

1] Create an instance, **optionally** supply phone number listener and sms listener
```
SmsUserConsent smsUserConsent = SmsUserConsent(
        // optionally, do something when user selects a number.
        // You can even add/update this listener later on by simply 
        // calling smsUserConsent.updatePhoneNumberListener(updatedListener)
        phoneNumberListener: (number) {},
        
        // optionally, do something when user receives sms.
        // You can even add/update this listener later on by simply 
        // calling smsUserConsent.updateSmsListener(updatedListener)
        smsListener: (otpcode) {}
);
```

2a] **OPTIONAL** : Request user's phone number

```
smsUserConsent.requestPhoneNumber();
```
Once the user selects a phone number, it can be accessed as
```
smsUserConsent.selectedPhoneNumber;
```

2b] **OPTIONAL** : Request to receive SMS
```
smsUserConsent.requestSms(); 
```
or you can specify the phone number you wish to capture the SMS from
```
smsUserConsent.requestSms(senderPhoneNumber: sender_number);
```
Once the user receives a SMS and the user taps **Allow**, it can be accessed as
```
smsUserConsent.receivedSms;
```

3] Finally, dispose the instance
```
smsUserConsent.dispose();
```

### Note

As per the [SMS User Consent API](https://developers.google.com/identity/sms-retriever/user-consent/overview),  otp will be received by the plugin only if it meets these criteria:

* The message contains 6-10 numbers.
* The message was sent by a phone number that's not in the user's contacts.
* If you specified the sender's phone number, the message was sent by that number.

## Contributing

* Found a bug or idea to improve the plugin? Send a PR.
* my portfolio [Portfolio](https://mdyousufbhuiyan.github.io/yousuf-portfolio/)
* Want to hire me for a gig? Let's talk on [LinkedIn](https://www.linkedin.com/in/yousufappspecialist)
