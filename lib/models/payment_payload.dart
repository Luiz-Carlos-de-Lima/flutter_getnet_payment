import 'package:flutter_getnet_payment/constants/credit_type.dart';
import 'package:flutter_getnet_payment/constants/currency_position.dart';
import 'package:flutter_getnet_payment/constants/payment_type.dart';

class PaymentPayload {
  final String callerId;
  final CurrencyPosition currencyPosition;
  final String currecyCode;
  final PaymentType paymentType;
  final CreditType? creditType;
  final int? installments;
  final double amount;
  final String orderId;

  PaymentPayload({
    required this.paymentType,
    this.currencyPosition = CurrencyPosition.CURRENCY_BEFORE_AMOUNT,
    this.currecyCode = "986",
    this.creditType,
    this.installments,
    required this.amount,
    required this.callerId,
    required this.orderId,
  }) : assert(
         paymentType != PaymentType.credit || (creditType != null && installments != null && installments > 0),
         "creditType and installments cannot be null when paymentType is 'credit', and installments must be greater than 0",
       ),
       assert(callerId.length <= 50, 'callerId size must be less than or equal to 50 characters'),
       assert(orderId.length <= 50, 'orderId size must be less than or equal to 50 characters');

  static PaymentPayload fromJson(Map map) {
    return PaymentPayload(
      paymentType: PaymentType.values.byName(map['paymentType']),
      currencyPosition: CurrencyPosition.values.byName(map['currencyPosition']),
      currecyCode: map['currecyCode'],
      creditType: map['creditType'] != null ? CreditType.values.byName(map['creditType']) : null,
      installments: map['installments'] != null ? (map['installments'] as num).toInt() : null,
      amount: (map['amount'] as num).toDouble(),
      callerId: map['callerId'],
      orderId: map['orderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentType': paymentType.name,
      'currencyPosition': currencyPosition.name,
      'currecyCode': currecyCode,
      'creditType': creditType?.name,
      'installments': installments,
      'amount': (amount * 100).round().toString().padLeft(12, '0'),
      'callerId': callerId,
      'orderId': orderId,
    };
  }
}
