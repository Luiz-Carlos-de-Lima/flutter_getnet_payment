import 'package:flutter_getnet_payment/models/payment_payload.dart';

import 'flutter_getnet_payment_platform_interface.dart';

class FlutterGetnetPayment {
  Future<void> pay({required PaymentPayload paymentPayload}) {
    return FlutterGetnetPaymentPlatform.instance.pay(paymentPayload: paymentPayload);
  }
}
