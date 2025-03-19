import 'package:flutter_getnet_payment/constants/credit_type.dart';
import 'package:flutter_getnet_payment/constants/payment_type.dart';

class PaymentPayload {
  final PaymentType paymentType;
  final CreditType? creditType;
  final int? installments;
  final double amount;
  final String callerId;
  final String orderId;

  PaymentPayload({required this.paymentType, this.creditType, this.installments, required this.amount, required this.callerId, required this.orderId})
    : assert(paymentType != PaymentType.credit || creditType != null, "creditType and installments cannot be null when paymentType is 'credit'"),
      assert(creditType != null || installments == null, "installments cannot be null when creditType is 'creditMerchant' or 'creditIssuer'"),
      assert(callerId.length <= 50, 'callerId size must be les than or equal to 50 characters'),
      assert(orderId.length <= 50, 'orderId size must be les than or equal to 50 characters');

  static PaymentPayload fromMap(Map<String, dynamic> map) {
    return PaymentPayload(
      paymentType: PaymentType.values.byName(map['paymentType']),
      creditType: map['creditType'] != null ? CreditType.values.byName(map['creditType']) : null,
      installments: map['installments'],
      amount: map['amount'],
      callerId: map['callerId'],
      orderId: map['orderId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'paymentType': paymentType.name,
      'creditType': creditType?.name,
      'installments': installments,
      'amount': (amount * 100).round().toString().padLeft(12, '0'),
      'callerId': callerId,
      'orderId': orderId,
    };
  }
}
