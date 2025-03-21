import 'package:flutter_getnet_payment/models/payment_response.dart';

class StatusPaymentResponse extends PaymentResponse {
  final bool? refunded;

  StatusPaymentResponse({
    required super.result,
    super.resultDetails,
    required super.amount,
    required super.callerId,
    super.nsu,
    super.nsuLastSuccesfullMessage,
    super.cvNumber,
    required super.receiptAlreadyPrinted,
    required super.type,
    super.brand,
    required super.inputType,
    super.installments,
    super.gmtDateTime,
    super.nsuLocal,
    super.authorizationCode,
    super.cardBin,
    super.cardLastDigits,
    super.extraScreensResult,
    super.splitPayloadResponse,
    super.cardholderName,
    super.automationSlip,
    super.printMerchantPreference,
    super.orderId,
    super.pixPayloadResponse,
    this.refunded = false,
  });

  static StatusPaymentResponse fromJson(Map map) {
    return StatusPaymentResponse(
      result: map['result'],
      resultDetails: map['resultDetails'],
      amount: map['amount'],
      callerId: map['callerId'],
      nsu: map['nsu'],
      nsuLastSuccesfullMessage: map['nsuLastSuccesfullMessage'],
      cvNumber: map['cvNumber'],
      receiptAlreadyPrinted: map['receiptAlreadyPrinted'],
      type: map['type'],
      brand: map['brand'],
      inputType: map['inputType'],
      installments: map['installments'],
      gmtDateTime: map['gmtDateTime'],
      nsuLocal: map['nsuLocal'],
      authorizationCode: map['authorizationCode'],
      cardBin: map['cardBin'],
      cardLastDigits: map['cardLastDigits'],
      extraScreensResult: map['extraScreensResult'],
      splitPayloadResponse: map['splitPayloadResponse'],
      cardholderName: map['cardholderName'],
      automationSlip: map['automationSlip'],
      printMerchantPreference: map['printMerchantPreference'],
      orderId: map['orderId'],
      pixPayloadResponse: map['pixPayloadResponse'],
      refunded: map['refunded'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['refunded'] = refunded;
    return data;
  }
}
