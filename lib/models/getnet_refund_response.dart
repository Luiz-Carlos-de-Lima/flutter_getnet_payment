import 'package:flutter_getnet_payment/models/getnet_payment_response.dart';

class GetnetRefundResponse extends GetnetPaymentResponse {
  final String? nsuLastSuccessfullMessage;
  final String? refundTransactionDate;
  final String? refundCvNumber;

  final String refundOriginTerminal;

  GetnetRefundResponse({
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

  static GetnetRefundResponse fromJson({required Map json}) {
    return GetnetRefundResponse(
      result: json['result'],
      resultDetails: json['resultDetails'],
      amount: int.parse(json['amount']) / 100,
      gmtDateTime: json['gmtDateTime'],
      nsu: json['nsu'],
      nsuLastSuccesfullMessage: json['nsuLastSuccesfullMessage'],
      authorizationCode: json['authorizationCode'],
      cardBin: json['cardBin'],
      cardLastDigits: json['cardLastDigits'],
      refundTransactionDate: json['refundTransactionDate'],
      refundCvNumber: json['refundCvNumber'],
      refundOriginTerminal: json['refundOriginTerminal'],
      cardholderName: json['cardholderName'],
      splitPayloadResponse: json['splitPayloadResponse'],
      automationSlip: json['automationSlip'],
      callerId: 'no data for refund',
      receiptAlreadyPrinted: false,
      type: 'no data for refund',
      inputType: 'no data for refund',
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
