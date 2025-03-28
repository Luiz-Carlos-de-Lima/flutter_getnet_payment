import 'package:flutter_getnet_payment/models/getnet_payment_response.dart';

class GetnetStatusPaymentResponse extends GetnetPaymentResponse {
  final bool? refunded;

  GetnetStatusPaymentResponse({
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

  static GetnetStatusPaymentResponse fromJson({required Map json}) {
    return GetnetStatusPaymentResponse(
      result: json['result'],
      resultDetails: json['resultDetails'],
      amount: json['amount'] ?? 0.00,
      callerId: json['callerId'] ?? 'this value of response is null',
      nsu: json['nsu'] ?? 'this value of response is null',
      nsuLastSuccesfullMessage: json['nsuLastSuccesfullMessage'],
      cvNumber: json['cvNumber'],
      receiptAlreadyPrinted: json['receiptAlreadyPrinted'] ?? false,
      type: json['type'] ?? 'this value of response is null',
      brand: json['brand'],
      inputType: json['inputType'] ?? 'this value of response is null',
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
