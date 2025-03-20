import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getnet_payment/constants/status_deeplink.dart';
import 'package:flutter_getnet_payment/exceptions/payment_exception.dart';
import 'package:flutter_getnet_payment/exceptions/status_payment_exception%20copy.dart';
import 'package:flutter_getnet_payment/models/payment_response.dart';
import 'package:flutter_getnet_payment/models/status_payment_payload.dart';
import 'package:flutter_getnet_payment/models/status_payment_response.dart';

import 'flutter_getnet_payment_platform_interface.dart';
import 'models/payment_payload.dart';

/// An implementation of [FlutterGetnetPaymentPlatform] that uses method channels.
class MethodChannelFlutterGetnetPayment extends FlutterGetnetPaymentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_getnet_payment');

  @override
  Future<PaymentResponse> pay({required PaymentPayload paymentPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('pay', paymentPayload.toJson());
      if (response is Map) {
        if ((response['code'] == StatusDeeplink.SUCCESS.name || response['code'] == StatusDeeplink.PENDING.name) && response['data'] is Map) {
          final jsonData = response['data'];
          return PaymentResponse.fromJson(jsonData);
        } else {
          throw PaymentException(message: response['message']);
        }
      } else {
        throw PaymentException(message: 'invalid response');
      }
    } on PaymentException catch (e) {
      throw PaymentException(message: e.message);
    } on PlatformException catch (e) {
      throw PaymentException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw PaymentException(message: "Pay Error: $e");
    }
  }

  @override
  Future<StatusPaymentResponse> statusPayment({required StatusPaymentPayload statusPaymentPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('statusPayment', statusPaymentPayload.toJson());
      if (response is Map) {
        if ((response['code'] == StatusDeeplink.SUCCESS.name || response['code'] == StatusDeeplink.PENDING.name) && response['data'] is Map) {
          final jsonData = response['data'];
          return StatusPaymentResponse.fromJson(jsonData);
        } else {
          throw StatusPaymentException(message: response['message']);
        }
      } else {
        throw StatusPaymentException(message: 'invalid response');
      }
    } on StatusPaymentException catch (e) {
      throw StatusPaymentException(message: e.message);
    } on PlatformException catch (e) {
      throw StatusPaymentException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw StatusPaymentException(message: "Status payment Error: $e");
    }
  }
}
