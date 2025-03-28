import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getnet_payment/exceptions/getnet_info_exception.dart';
import 'package:flutter_getnet_payment/models/getnet_device_info.dart';

import 'flutter_getnet_payment_platform_interface.dart';

import 'exceptions/getnet_pre_autorization_exception.dart';
import 'exceptions/getnet_status_payment_exception.dart';
import 'models/getnet_pre_autorization_response.dart';
import 'models/getnet_pre_autorization_payload.dart';
import 'models/getnet_status_payment_response.dart';
import 'models/getnet_status_payment_payload.dart';
import 'exceptions/getnet_payment_exception.dart';
import 'exceptions/getnet_reprint_exception.dart';
import 'exceptions/getnet_refund_exception.dart';
import 'exceptions/getnet_print_exception.dart';
import 'constants/getnet_status_deeplink.dart';
import 'models/getnet_payment_response.dart';
import 'models/getnet_payment_payload.dart';
import 'models/getnet_refund_response.dart';
import 'models/getnet_refund_payload.dart';
import 'models/getnet_info_response.dart';
import 'models/getnet_print_payload.dart';

/// An implementation of [FlutterGetnetPaymentPlatform] that uses method channels.
class MethodChannelFlutterGetnetPayment extends FlutterGetnetPaymentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_getnet_payment');

  @override
  Future<GetnetPaymentResponse> pay({required GetnetPaymentPayload paymentPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('pay', paymentPayload.toJson());
      if (response is Map) {
        if ((response['code'] == GetnetStatusDeeplink.SUCCESS.name || response['code'] == GetnetStatusDeeplink.PENDING.name) && response['data'] is Map) {
          if (response['code'] == GetnetStatusDeeplink.SUCCESS.name) {
            final jsonData = response['data'];
            return GetnetPaymentResponse.fromJson(jsonData);
          } else {
            return GetnetPaymentResponse(
              result: response['result'] ?? '5',
              resultDetails: 'Operação ainda pendente cancelada pelo lojista, realize consulta do status',
              printMerchantPreference: response['printMerchantPreference'] ?? false,
              amount: paymentPayload.amount,
              callerId: paymentPayload.callerId,
              receiptAlreadyPrinted: false,
              type: '',
              inputType: '',
            );
          }
        } else {
          throw GetnetPaymentException(message: response['message']);
        }
      } else {
        throw GetnetPaymentException(message: 'invalid response');
      }
    } on GetnetPaymentException catch (e) {
      throw GetnetPaymentException(message: e.message);
    } on PlatformException catch (e) {
      throw GetnetPaymentException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw GetnetPaymentException(message: "Pay Error: $e");
    }
  }

  @override
  Future<GetnetStatusPaymentResponse> statusPayment({required GetnetStatusPaymentPayload statusPaymentPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('statusPayment', statusPaymentPayload.toJson());
      if (response is Map) {
        if ((response['code'] == GetnetStatusDeeplink.SUCCESS.name || response['code'] == GetnetStatusDeeplink.PENDING.name) && response['data'] is Map) {
          if (response['code'] == GetnetStatusDeeplink.SUCCESS.name) {
            final jsonData = response['data'];
            return GetnetStatusPaymentResponse.fromJson(json: jsonData);
          } else {
            return GetnetStatusPaymentResponse(
              result: response['result'] ?? '5',
              resultDetails: 'Operação ainda pendente cancelada pelo lojista, realize consulta do status',
              printMerchantPreference: response['printMerchantPreference'] ?? false,
              amount: 0.00,
              callerId: statusPaymentPayload.callerId,
              receiptAlreadyPrinted: false,
              type: '',
              inputType: '',
            );
          }
        } else {
          throw GetnetStatusPaymentException(message: response['message']);
        }
      } else {
        throw GetnetStatusPaymentException(message: 'invalid response');
      }
    } on GetnetStatusPaymentException catch (e) {
      throw GetnetStatusPaymentException(message: e.message);
    } on PlatformException catch (e) {
      throw GetnetStatusPaymentException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw GetnetStatusPaymentException(message: "Status payment Error: $e");
    }
  }

  @override
  Future<GetnetPreAutorizationResponse> preAutorization({required GetnetPreAutorizationPayload preAutorizationPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('preAuthorization', preAutorizationPayload.toJson());
      if (response is Map) {
        if ((response['code'] == GetnetStatusDeeplink.SUCCESS.name || response['code'] == GetnetStatusDeeplink.PENDING.name) && response['data'] is Map) {
          if (response['code'] == GetnetStatusDeeplink.SUCCESS.name) {
            final jsonData = response['data'];
            return GetnetPreAutorizationResponse.fromJson(json: jsonData);
          } else {
            return GetnetPreAutorizationResponse(
              result: response['result'] ?? '5',
              resultDetails: 'Operação ainda pendente cancelada pelo lojista, realize consulta do status',
              amount: preAutorizationPayload.amount,
              callerId: preAutorizationPayload.callerId,
              receiptAlreadyPrinted: false,
              type: '',
              inputType: '',
            );
          }
        } else {
          throw GetnetPreAutorizationException(message: response['message']);
        }
      } else {
        throw GetnetPreAutorizationException(message: 'invalid response');
      }
    } on GetnetPreAutorizationException catch (e) {
      throw GetnetPreAutorizationException(message: e.message);
    } on PlatformException catch (e) {
      throw GetnetPreAutorizationException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw GetnetPreAutorizationException(message: "Status payment Error: $e");
    }
  }

  @override
  Future<GetnetRefundResponse> refund({required GetnetRefundPayload refundPayload}) async {
    try {
      final refund = refundPayload.toJson();
      final response = await methodChannel.invokeMethod<Map>('refund', refund);
      if (response is Map) {
        if ((response['code'] == GetnetStatusDeeplink.SUCCESS.name || response['code'] == GetnetStatusDeeplink.PENDING.name) && response['data'] is Map) {
          if (response['code'] == GetnetStatusDeeplink.SUCCESS.name) {
            final jsonData = response['data'];
            return GetnetRefundResponse.fromJson(json: jsonData);
          } else {
            return GetnetRefundResponse(
              result: response['result'] ?? '5',
              resultDetails: 'Operação ainda pendente cancelada pelo lojista, realize consulta do status',
              amount: refundPayload.amount,
              callerId: response['callerId'] ?? '',
              receiptAlreadyPrinted: false,
              type: '',
              inputType: '',
              refundOriginTerminal: response['refundOriginTerminal'] ?? '',
            );
          }
        } else {
          throw GetnetRefundException(message: response['message']);
        }
      } else {
        throw GetnetRefundException(message: 'invalid response');
      }
    } on GetnetRefundException catch (e) {
      throw GetnetRefundException(message: e.message);
    } on PlatformException catch (e) {
      throw GetnetRefundException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw GetnetRefundException(message: "Status payment Error: $e");
    }
  }

  @override
  Future<void> print({required GetnetPrintPayload printPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('print', printPayload.toJson());

      if (response is Map) {
        if (response['code'] != GetnetStatusDeeplink.SUCCESS.name) {
          throw GetnetPrintException(message: response['message']);
        }
      } else {
        throw GetnetPrintException(message: 'invalid response');
      }
    } on GetnetPrintException catch (e) {
      throw GetnetPrintException(message: e.message);
    } on PlatformException catch (e) {
      throw GetnetPrintException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw GetnetPrintException(message: "Print Error: $e");
    }
  }

  @override
  Future<void> reprint() async {
    try {
      final response = await methodChannel.invokeMethod<Map>('reprint');
      if (response is Map) {
        if (response['code'] == GetnetStatusDeeplink.ERROR.name) {
          throw GetnetReprintException(message: response['message']);
        }
      } else {
        throw GetnetReprintException(message: 'invalid response');
      }
    } on GetnetReprintException catch (e) {
      throw GetnetReprintException(message: e.message);
    } on PlatformException catch (e) {
      throw GetnetReprintException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw GetnetReprintException(message: "reprint payment Error: $e");
    }
  }

  @override
  Future<GetnetInfoResponse> info() async {
    try {
      final response = await methodChannel.invokeMethod<Map>('info');
      if (response is Map) {
        if ((response['code'] == GetnetStatusDeeplink.SUCCESS.name || response['code'] == GetnetStatusDeeplink.PENDING.name) && response['data'] is Map) {
          if (response['code'] == GetnetStatusDeeplink.SUCCESS.name) {
            final jsonData = response['data'];
            return GetnetInfoResponse.fromJson(json: jsonData);
          } else {
            return GetnetInfoResponse(
              result: response['result'] ?? '5',
              ec: '',
              numserie: '',
              numlogic: '',
              version: '',
              cnpjEC: '',
              razaoSocialEC: '',
              cidadeEC: '',
            );
          }
        } else {
          throw GetnetInfoException(message: response['message']);
        }
      } else {
        throw GetnetInfoException(message: 'invalid response');
      }
    } on GetnetInfoException catch (e) {
      throw GetnetInfoException(message: e.message);
    } on PlatformException catch (e) {
      throw GetnetInfoException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw GetnetInfoException(message: "info payment Error: $e");
    }
  }

  @override
  Future<GetnetDeviceInfo> deviceInfo() async {
    try {
      final response = await methodChannel.invokeMethod<Map>('getSerialNumberAndDeviceModel');
      if (response is Map) {
        if ((response['code'] == GetnetStatusDeeplink.SUCCESS.name) && response['data'] is Map) {
          final jsonData = response['data'];
          return GetnetDeviceInfo.fromJson(json: jsonData);
        } else {
          throw GetnetInfoException(message: response['message']);
        }
      } else {
        throw GetnetInfoException(message: 'invalid response');
      }
    } on GetnetInfoException catch (e) {
      throw GetnetInfoException(message: e.message);
    } on PlatformException catch (e) {
      throw GetnetInfoException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw GetnetInfoException(message: "deviceInfo payment Error: $e");
    }
  }
}
