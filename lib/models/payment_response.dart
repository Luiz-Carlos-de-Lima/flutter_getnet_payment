class PaymentResponse {
  final String result;
  final String? resultDetails;
  final double amount;
  final String callerId;
  final String? nsu;
  final String? nsuLastSuccesfullMessage;
  final String? cvNumber;
  final bool receiptAlreadyPrinted;
  final String type;
  final String? brand;
  final String inputType;
  final String? installments;
  final String? gmtDateTime;
  final String? nsuLocal;
  final String? authorizationCode;
  final String? cardBin;
  final String? cardLastDigits;
  final String? extraScreensResult;
  final String? splitPayloadResponse;
  final String? cardholderName;
  final String? automationSlip;
  final bool? printMerchantPreference;
  final String? orderId;
  final String? pixPayloadResponse;

  PaymentResponse({
    required this.result,
    this.resultDetails,
    required this.amount,
    required this.callerId,
    this.nsu,
    this.nsuLastSuccesfullMessage,
    this.cvNumber,
    required this.receiptAlreadyPrinted,
    required this.type,
    this.brand,
    required this.inputType,
    this.installments,
    this.gmtDateTime,
    this.nsuLocal,
    this.authorizationCode,
    this.cardBin,
    this.cardLastDigits,
    this.extraScreensResult,
    this.splitPayloadResponse,
    this.cardholderName,
    this.automationSlip,
    this.printMerchantPreference,
    this.orderId,
    this.pixPayloadResponse,
  });

  static PaymentResponse fromJson(Map map) {
    return PaymentResponse(
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'resultDetails': resultDetails,
      'amount': (amount * 100).round().toString().padLeft(12, '0'),
      'callerId': callerId,
      'nsu': nsu,
      'nsuLastSuccesfullMessage': nsuLastSuccesfullMessage,
      'cvNumber': cvNumber,
      'receiptAlreadyPrinted': receiptAlreadyPrinted,
      'type': type,
      'brand': brand,
      'inputType': inputType,
      'installments': installments,
      'gmtDateTime': gmtDateTime,
      'nsuLocal': nsuLocal,
      'authorizationCode': authorizationCode,
      'cardBin': cardBin,
      'cardLastDigits': cardLastDigits,
      'extraScreensResult': extraScreensResult,
      'splitPayloadResponse': splitPayloadResponse,
      'cardholderName': cardholderName,
      'automationSlip': automationSlip,
      'printMerchantPreference': printMerchantPreference,
      'orderId': orderId,
      'pixPayloadResponse': pixPayloadResponse,
    };
  }
}
