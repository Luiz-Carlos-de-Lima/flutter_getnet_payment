class GetnetStatusPaymentPayload {
  final String callerId;
  final bool allowPrintCurrentTransaction;

  GetnetStatusPaymentPayload({
    required this.callerId,
    this.allowPrintCurrentTransaction = false,
  });

  static GetnetStatusPaymentPayload fromJson(Map map) {
    return GetnetStatusPaymentPayload(
      callerId: map['callerId'],
      allowPrintCurrentTransaction: map['allowPrintCurrentTransaction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callerId': callerId,
      'allowPrintCurrentTransaction': allowPrintCurrentTransaction,
    };
  }
}
