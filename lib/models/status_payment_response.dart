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

  static StatusPaymentResponse fromJson({required Map json}) {
    return StatusPaymentResponse(
      result: json['result'],
      resultDetails: json['resultDetails'],
      amount: json['amount'],
      callerId: json['callerId'],
      nsu: json['nsu'],
      nsuLastSuccesfullMessage: json['nsuLastSuccesfullMessage'],
      cvNumber: json['cvNumber'],
      receiptAlreadyPrinted: json['receiptAlreadyPrinted'],
      type: json['type'],
      brand: json['brand'],
      inputType: json['inputType'],
      installments: json['installments'],
      gmtDateTime: json['gmtDateTime'],
      nsuLocal: json['nsuLocal'],
      authorizationCode: json['authorizationCode'],
      cardBin: json['cardBin'],
      cardLastDigits: json['cardLastDigits'],
      extraScreensResult: json['extraScreensResult'],
      splitPayloadResponse: json['splitPayloadResponse'],
      cardholderName: json['cardholderName'],
      automationSlip: json['automationSlip'],
      printMerchantPreference: json['printMerchantPreference'],
      orderId: json['orderId'],
      pixPayloadResponse: json['pixPayloadResponse'],
      refunded: json['refunded'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['refunded'] = refunded;
    return data;
  }
}
