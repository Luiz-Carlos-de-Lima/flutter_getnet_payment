import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getnet_payment/constants/status_deeplink.dart';
import 'package:flutter_getnet_payment/exceptions/payment_exception.dart';
import 'package:flutter_getnet_payment/exceptions/print_exception.dart';
import 'package:flutter_getnet_payment/exceptions/refund_exception.dart';
import 'package:flutter_getnet_payment/exceptions/reprint_exception.dart';
import 'package:flutter_getnet_payment/exceptions/status_payment_exception.dart';
import 'package:flutter_getnet_payment/models/info_response.dart';
import 'package:flutter_getnet_payment/models/payment_response.dart';
import 'package:flutter_getnet_payment/models/pre_autorization_payload.dart';
import 'package:flutter_getnet_payment/models/pre_autorization_response.dart';
import 'package:flutter_getnet_payment/models/print_payload.dart';
import 'package:flutter_getnet_payment/models/refund_payload.dart';
import 'package:flutter_getnet_payment/models/refund_response.dart';
import 'package:flutter_getnet_payment/models/status_payment_payload.dart';
import 'package:flutter_getnet_payment/models/status_payment_response.dart';

import 'exceptions/pre_autorization_exception.dart';
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
      final response = await methodChannel.invokeMethod<Map>(
        'pay',
        paymentPayload.toJson(),
      );
      if (response is Map) {
        if ((response['code'] == StatusDeeplink.SUCCESS.name ||
                response['code'] == StatusDeeplink.PENDING.name) &&
            response['data'] is Map) {
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
  Future<StatusPaymentResponse> statusPayment({
    required StatusPaymentPayload statusPaymentPayload,
  }) async {
    try {
      final response = await methodChannel.invokeMethod<Map>(
        'statusPayment',
        statusPaymentPayload.toJson(),
      );
      if (response is Map) {
        if ((response['code'] == StatusDeeplink.SUCCESS.name ||
                response['code'] == StatusDeeplink.PENDING.name) &&
            response['data'] is Map) {
          final jsonData = response['data'];
          return StatusPaymentResponse.fromJson(json: jsonData);
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

  @override
  Future<PreAutorizationResponse> preAutorization({
    required PreAutorizationPayload preAutorizationPayload,
  }) async {
    try {
      final response = await methodChannel.invokeMethod<Map>(
        'preAuthorization',
        preAutorizationPayload.toJson(),
      );
      if (response is Map) {
        if ((response['code'] == StatusDeeplink.SUCCESS.name ||
                response['code'] == StatusDeeplink.PENDING.name) &&
            response['data'] is Map) {
          final jsonData = response['data'];
          return PreAutorizationResponse.fromJson(json: jsonData);
        } else {
          throw PreAutorizationException(message: response['message']);
        }
      } else {
        throw PreAutorizationException(message: 'invalid response');
      }
    } on PreAutorizationException catch (e) {
      throw PreAutorizationException(message: e.message);
    } on PlatformException catch (e) {
      throw PreAutorizationException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw PreAutorizationException(message: "Status payment Error: $e");
    }
  }

  @override
  Future<RefundResponse> refund({required RefundPayload refundPayload}) async {
    try {
      final refund = refundPayload.toJson();
      final response = await methodChannel.invokeMethod<Map>('refund', refund);
      if (response is Map) {
        if ((response['code'] == StatusDeeplink.SUCCESS.name ||
                response['code'] == StatusDeeplink.PENDING.name) &&
            response['data'] is Map) {
          final jsonData = response['data'];
          return RefundResponse.fromJson(json: jsonData);
        } else {
          throw RefundException(message: response['message']);
        }
      } else {
        throw RefundException(message: 'invalid response');
      }
    } on RefundException catch (e) {
      throw RefundException(message: e.message);
    } on PlatformException catch (e) {
      throw RefundException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw RefundException(message: "Status payment Error: $e");
    }
  }

  @override
  Future<void> print({required PrintPayload printPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>(
        'print',
        printPayload.toJson(),
      );

      if (response is Map) {
        if (response['code'] != StatusDeeplink.SUCCESS.name) {
          throw PrintException(message: response['message']);
        }
      } else {
        throw PrintException(message: 'invalid response');
      }
    } on PrintException catch (e) {
      throw PrintException(message: e.message);
    } on PlatformException catch (e) {
      throw PrintException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw PrintException(message: "Print Error: $e");
    }
  }

  @override
  Future<void> reprint() async {
    try {
      final response = await methodChannel.invokeMethod<Map>('reprint');
      if (response is Map) {
        if (response['code'] == StatusDeeplink.ERROR.name) {
          throw ReprintException(message: response['message']);
        }
      } else {
        throw ReprintException(message: 'invalid response');
      }
    } on ReprintException catch (e) {
      throw ReprintException(message: e.message);
    } on PlatformException catch (e) {
      throw ReprintException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw ReprintException(message: "reprint payment Error: $e");
    }
  }

  @override
  Future<InfoResponse> info() async {
    try {
      final response = await methodChannel.invokeMethod<Map>('info');
      if (response is Map) {
        if ((response['code'] == StatusDeeplink.SUCCESS.name ||
                response['code'] == StatusDeeplink.PENDING.name) &&
            response['data'] is Map) {
          final jsonData = response['data'];
          return InfoResponse.fromJson(json: jsonData);
        } else {
          throw RefundException(message: response['message']);
        }
      } else {
        throw ReprintException(message: 'invalid response');
      }
    } on ReprintException catch (e) {
      throw ReprintException(message: e.message);
    } on PlatformException catch (e) {
      throw ReprintException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw ReprintException(message: "reprint payment Error: $e");
    }
  }
}
