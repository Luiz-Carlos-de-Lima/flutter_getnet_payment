import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_getnet_payment_method_channel.dart';

import 'models/getnet_pre_autorization_response.dart';
import 'models/getnet_pre_autorization_payload.dart';
import 'models/getnet_status_payment_response.dart';
import 'models/getnet_status_payment_payload.dart';
import 'models/getnet_payment_response.dart';
import 'models/getnet_refund_response.dart';
import 'models/getnet_payment_payload.dart';
import 'models/getnet_refund_payload.dart';
import 'models/getnet_info_response.dart';
import 'models/getnet_print_payload.dart';

abstract class FlutterGetnetPaymentPlatform extends PlatformInterface {
  /// Constructs a FlutterGetnetPaymentPlatform.
  FlutterGetnetPaymentPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterGetnetPaymentPlatform _instance = MethodChannelFlutterGetnetPayment();

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

  Future<GetnetPaymentResponse> pay({required GetnetPaymentPayload paymentPayload}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<GetnetStatusPaymentResponse> statusPayment({required GetnetStatusPaymentPayload statusPaymentPayload}) async {
    throw UnimplementedError('statusPayment() has not been implemented.');
  }

  Future<GetnetPreAutorizationResponse> preAutorization({required GetnetPreAutorizationPayload preAutorizationPayload}) {
    throw UnimplementedError('preAutorization() has not been implemented.');
  }

  Future<GetnetRefundResponse> refund({required GetnetRefundPayload refundPayload}) {
    throw UnimplementedError('refund() has not been implemented.');
  }

  Future<void> print({required GetnetPrintPayload printPayload}) {
    throw UnimplementedError('print() has not been implemented.');
  }

  Future<void> reprint() async {
    throw UnimplementedError('reprint() has not been implemented.');
  }

  Future<GetnetInfoResponse> info() async {
    throw UnimplementedError('info() has not been implemented.');
  }
}
