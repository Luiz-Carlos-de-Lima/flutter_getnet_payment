import 'package:flutter_getnet_payment/models/Info_response.dart';
import 'package:flutter_getnet_payment/models/payment_payload.dart';
import 'package:flutter_getnet_payment/models/payment_response.dart';
import 'package:flutter_getnet_payment/models/pre_autorization_payload.dart';
import 'package:flutter_getnet_payment/models/refund_response.dart';
import 'package:flutter_getnet_payment/models/status_payment_payload.dart';
import 'package:flutter_getnet_payment/models/status_payment_response.dart';

import 'flutter_getnet_payment_platform_interface.dart';
import 'models/refund_payload.dart';

class FlutterGetnetPayment {
  Future<PaymentResponse> pay({required PaymentPayload paymentPayload}) {
    return FlutterGetnetPaymentPlatform.instance.pay(paymentPayload: paymentPayload);
  }

  Future<StatusPaymentResponse> statusPayment({required StatusPaymentPayload statusPaymentPayload}) async {
    return FlutterGetnetPaymentPlatform.instance.statusPayment(statusPaymentPayload: statusPaymentPayload);
  }

  Future<void> preAutorization({required PreAutorizationPayload preAutorizationPayload}) {
    return FlutterGetnetPaymentPlatform.instance.preAutorization(preAutorizationPayload: preAutorizationPayload);
  }

  Future<RefundResponse> refund({required RefundPayload refundPayload}) {
    return FlutterGetnetPaymentPlatform.instance.refund(refundPayload: refundPayload);
  }

  Future<void> reprint() {
    return FlutterGetnetPaymentPlatform.instance.reprint();
  }

  Future<InfoResponse> info() {
    return FlutterGetnetPaymentPlatform.instance.info();
  }
}
