import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_getnet_payment/constants/getnet_payment_type.dart';
import 'package:flutter_getnet_payment/models/getnet_payment_payload.dart';
import 'package:flutter_getnet_payment/models/getnet_payment_response.dart';

void main() {
  group('GetnetPaymentPayload', () {
    test('toJson converts reais to padded centavos string', () {
      final payload = GetnetPaymentPayload(
        amount: 15.5,
        paymentType: GetnetPaymentType.debit,
        callerId: 'caller-1',
        orderId: 'order-1',
      );

      final json = payload.toJson();

      expect(json['amount'], '000000001550');
      expect(json['paymentType'], 'debit');
      expect(json['callerId'], 'caller-1');
      expect(json['orderId'], 'order-1');
    });

    test('toJson keeps credit, pix and voucher types', () {
      expect(
        GetnetPaymentPayload(
          amount: 10,
          paymentType: GetnetPaymentType.credit,
          callerId: 'c',
          orderId: 'o',
        ).toJson()['paymentType'],
        'credit',
      );
      expect(
        GetnetPaymentPayload(
          amount: 10,
          paymentType: GetnetPaymentType.pix,
          callerId: 'c',
          orderId: 'o',
        ).toJson()['paymentType'],
        'pix',
      );
      expect(
        GetnetPaymentPayload(
          amount: 10,
          paymentType: GetnetPaymentType.voucher,
          callerId: 'c',
          orderId: 'o',
        ).toJson()['paymentType'],
        'voucher',
      );
    });

    test('fromJson restores payload fields', () {
      final payload = GetnetPaymentPayload.fromJson({
        'paymentType': 'debit',
        'currencyPosition': 'CURRENCY_BEFORE_AMOUNT',
        'currencyCode': 986,
        'amount': 12.34,
        'callerId': 'caller-2',
        'orderId': 'order-2',
      });

      expect(payload.amount, 12.34);
      expect(payload.paymentType, GetnetPaymentType.debit);
      expect(payload.callerId, 'caller-2');
      expect(payload.orderId, 'order-2');
    });
  });

  group('GetnetPaymentResponse', () {
    test('fromJson converts centavos string to reais', () {
      final response = GetnetPaymentResponse.fromJson({
        'result': '0',
        'amount': '000000001550',
        'callerId': 'caller-1',
        'receiptAlreadyPrinted': false,
        'type': 'debit',
        'inputType': 'chip',
        'nsu': '123',
        'authorizationCode': 'AUTH',
        'brand': 'VISA',
        'orderId': 'order-1',
      });

      expect(response.amount, 15.5);
      expect(response.nsu, '123');
      expect(response.authorizationCode, 'AUTH');
      expect(response.brand, 'VISA');
      expect(response.orderId, 'order-1');
    });

    test('toJson round-trips amount and identifiers', () {
      final response = GetnetPaymentResponse(
        result: '0',
        amount: 20,
        callerId: 'caller',
        receiptAlreadyPrinted: false,
        type: 'credit',
        inputType: 'chip',
        nsu: '999',
        orderId: 'ord',
      );

      final json = response.toJson();
      final restored = GetnetPaymentResponse.fromJson(json);

      expect(restored.amount, 20);
      expect(restored.nsu, '999');
      expect(restored.orderId, 'ord');
    });
  });
}
