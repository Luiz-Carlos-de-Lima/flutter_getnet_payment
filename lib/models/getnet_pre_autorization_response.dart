import 'package:flutter_getnet_payment/models/getnet_payment_response.dart';

class GetnetPreAutorizationResponse extends GetnetPaymentResponse {
  GetnetPreAutorizationResponse({
    required super.result,
    super.resultDetails,
    required super.amount,
    required super.callerId,
    super.nsu,
    required super.type,
    super.brand,
    super.installments,
    super.cardholderName,
    super.automationSlip,
    super.orderId,
    super.receiptAlreadyPrinted = false,
    super.inputType = "",
  });

  static GetnetPreAutorizationResponse fromJson({required Map json}) {
    return GetnetPreAutorizationResponse(
      result: json['result'],
      resultDetails: json['resultDetails'],
      amount: int.parse(json['amount']) / 100,
      callerId: json['callerId'],
      nsu: json['nsu'],
      type: json['type'],
      brand: json['brand'],
      installments: json['installments'],
      cardholderName: json['cardholderName'],
      automationSlip: json['automationSlip'],
      orderId: json['orderId'],
      receiptAlreadyPrinted: json['receiptAlreadyPrinted'],
      inputType: json['inputType'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'resultDetails': resultDetails,
      'amount': (amount * 100).round().toString().padLeft(12, '0'),
      'callerId': callerId,
      'nsu': nsu,
      'type': type,
      'brand': brand,
      'installments': installments,
      'cardholderName': cardholderName,
      'automationSlip': automationSlip,
      'orderId': orderId,
      'receiptAlreadyPrinted': receiptAlreadyPrinted,
      'inputType': inputType,
    };
  }
}
