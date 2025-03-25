import 'package:flutter_getnet_payment/models/info_response.dart';
import 'package:flutter_getnet_payment/models/payment_response.dart';
import 'package:flutter_getnet_payment/models/pre_autorization_response.dart';
import 'package:flutter_getnet_payment/models/print_payload.dart';
import 'package:flutter_getnet_payment/models/refund_payload.dart';
import 'package:flutter_getnet_payment/models/refund_response.dart';
import 'package:flutter_getnet_payment/models/status_payment_payload.dart';
import 'package:flutter_getnet_payment/models/status_payment_response.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_getnet_payment_method_channel.dart';
import 'models/payment_payload.dart';
import 'models/pre_autorization_payload.dart';

abstract class FlutterGetnetPaymentPlatform extends PlatformInterface {
  /// Constructs a FlutterGetnetPaymentPlatform.
  FlutterGetnetPaymentPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterGetnetPaymentPlatform _instance =
      MethodChannelFlutterGetnetPayment();

  /// The default instance of [FlutterGetnetPaymentPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterGetnetPayment].
  static FlutterGetnetPaymentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterGetnetPaymentPlatform] when
  /// they register themselves.
  static set instance(FlutterGetnetPaymentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<PaymentResponse> pay({required PaymentPayload paymentPayload}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<StatusPaymentResponse> statusPayment({
    required StatusPaymentPayload statusPaymentPayload,
  }) async {
    throw UnimplementedError('statusPayment() has not been implemented.');
  }

  Future<PreAutorizationResponse> preAutorization({
    required PreAutorizationPayload preAutorizationPayload,
  }) {
    throw UnimplementedError('preAutorization() has not been implemented.');
  }

  Future<RefundResponse> refund({required RefundPayload refundPayload}) {
    throw UnimplementedError('refund() has not been implemented.');
  }

  Future<void> print({required PrintPayload printPayload}) {
    throw UnimplementedError('print() has not been implemented.');
  }

  Future<void> reprint() async {
    throw UnimplementedError('reprint() has not been implemented.');
  }

  Future<InfoResponse> info() async {
    throw UnimplementedError('info() has not been implemented.');
  }
}
