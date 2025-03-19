import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_getnet_payment_platform_interface.dart';
import 'models/payment_payload.dart';

/// An implementation of [FlutterGetnetPaymentPlatform] that uses method channels.
class MethodChannelFlutterGetnetPayment extends FlutterGetnetPaymentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_getnet_payment');

  @override
  Future<void> pay({required PaymentPayload paymentPayload}) async {
    await methodChannel.invokeMethod<String>('pay', paymentPayload.toMap());
  }
}
