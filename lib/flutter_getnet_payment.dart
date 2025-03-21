import 'package:flutter_getnet_payment/models/payment_payload.dart';
import 'package:flutter_getnet_payment/models/status_payment_payload.dart';
import 'package:flutter_getnet_payment/models/status_payment_response.dart';

import 'flutter_getnet_payment_platform_interface.dart';

class FlutterGetnetPayment {
  Future<void> pay({required PaymentPayload paymentPayload}) {
    return FlutterGetnetPaymentPlatform.instance.pay(paymentPayload: paymentPayload);
  }

  Future<StatusPaymentResponse> statusPayment({required StatusPaymentPayload statusPaymentPayload}) async {
    return FlutterGetnetPaymentPlatform.instance.statusPayment(statusPaymentPayload: statusPaymentPayload);
  }
}
