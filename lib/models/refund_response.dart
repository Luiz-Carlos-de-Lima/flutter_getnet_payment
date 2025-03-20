import 'package:flutter_getnet_payment/models/payment_response.dart';

class RefundResponse extends PaymentResponse {
  final String? nsuLastSuccessfullMessage;
  final String? refundTransactionDate;
  final String? refundCvNumber;
  final String refundOriginTerminal;

  RefundResponse({
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
    this.nsuLastSuccessfullMessage,
    this.refundTransactionDate,
    this.refundCvNumber,
    required this.refundOriginTerminal,
  });

  static RefundResponse fromJson(Map<String, dynamic> map) {
    return RefundResponse(
      result: map['result'],
      resultDetails: map['resultDetails'],
      amount: int.parse(map['amount']) / 100,
      callerId: map['callerId'],
      nsu: map['nsu'],
      nsuLastSuccesfullMessage: map['nsuLastSuccesfullMessage'],
      cvNumber: map['cvNumber'],
      receiptAlreadyPrinted: map['receiptAlreadyPrinted'] ?? false,
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
      refundOriginTerminal: map['refundOriginTerminal'],
      nsuLastSuccessfullMessage: map['nsuLastSuccessfullMessage'],
      refundTransactionDate: map['refundTransactionDate'],
      refundCvNumber: map['refundTransactionDate'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'refundOriginTerminal': refundOriginTerminal,
      'nsuLastSuccessfullMessage': nsuLastSuccessfullMessage,
      'refundTransactionDate': refundTransactionDate,
      'refundCvNumber': refundCvNumber,
    });
    return data;
  }
}
