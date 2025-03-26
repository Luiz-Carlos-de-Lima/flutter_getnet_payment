import 'flutter_getnet_payment_platform_interface.dart';

import 'models/getnet_pre_autorization_response.dart';
import 'models/getnet_pre_autorization_payload.dart';
import 'models/getnet_status_payment_response.dart';
import 'models/getnet_status_payment_payload.dart';
import 'models/getnet_payment_response.dart';
import 'models/getnet_payment_payload.dart';
import 'models/getnet_refund_response.dart';
import 'models/getnet_refund_payload.dart';
import 'models/getnet_info_response.dart';
import 'models/getnet_print_payload.dart';

class FlutterGetnetPayment {
  Future<GetnetPaymentResponse> pay({required GetnetPaymentPayload paymentPayload}) {
    return FlutterGetnetPaymentPlatform.instance.pay(paymentPayload: paymentPayload);
  }

  Future<GetnetStatusPaymentResponse> statusPayment({required GetnetStatusPaymentPayload statusPaymentPayload}) async {
    return FlutterGetnetPaymentPlatform.instance.statusPayment(statusPaymentPayload: statusPaymentPayload);
  }

  Future<GetnetPreAutorizationResponse> preAutorization({required GetnetPreAutorizationPayload preAutorizationPayload}) {
    return FlutterGetnetPaymentPlatform.instance.preAutorization(preAutorizationPayload: preAutorizationPayload);
  }

  Future<GetnetRefundResponse> refund({required GetnetRefundPayload refundPayload}) {
    return FlutterGetnetPaymentPlatform.instance.refund(refundPayload: refundPayload);
  }

  Future<void> print({required GetnetPrintPayload printPayload}) {
    return FlutterGetnetPaymentPlatform.instance.print(printPayload: printPayload);
  }

  Future<void> reprint() {
    return FlutterGetnetPaymentPlatform.instance.reprint();
  }

  Future<GetnetInfoResponse> info() {
    return FlutterGetnetPaymentPlatform.instance.info();
  }
}
