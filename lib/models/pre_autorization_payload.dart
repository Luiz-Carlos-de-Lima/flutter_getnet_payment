import 'package:flutter_getnet_payment/constants/currency_position.dart';

class PreAutorizationPayload {
  final double amount;
  final CurrencyPosition currencyPosition;
  final int currecyCode;
  final String callerId;
  final String? allowPrintCurrentTransaction;
  final String orderId;

  PreAutorizationPayload({
    required this.amount,
    this.currencyPosition = CurrencyPosition.CURRENCY_BEFORE_AMOUNT,
    this.currecyCode = 986,
    required this.callerId,
    this.allowPrintCurrentTransaction,
    required this.orderId,
  });

  static PreAutorizationPayload fromJson(Map map) {
    return PreAutorizationPayload(
      amount: int.parse(map['amount']) / 100,
      currencyPosition: map['currencyPosition'],
      currecyCode: map['currecyCode'] != null ? (map['currecyCode'] as num).toInt() : 986,
      callerId: map['callerId'],
      allowPrintCurrentTransaction: map['allowPrintCurrentTransaction'],
      orderId: map['orderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': (amount * 100).round().toString().padLeft(12, '0'),
      'currencyPosition': currencyPosition.name,
      'currecyCode': currecyCode,
      'callerId': callerId,
      'allowPrintCurrentTransaction': allowPrintCurrentTransaction,
      'orderId': orderId,
    };
  }
}
