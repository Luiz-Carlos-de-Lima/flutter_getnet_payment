class StatusPaymentPayload {
  final String callerId;
  final bool allowPrintCurrentTransaction;

  StatusPaymentPayload({required this.callerId, this.allowPrintCurrentTransaction = false});

  static StatusPaymentPayload fromJson(Map map) {
    return StatusPaymentPayload(callerId: map['callerId'], allowPrintCurrentTransaction: map['allowPrintCurrentTransaction']);
  }

  Map<String, dynamic> toJson() {
    return {'callerId': callerId, 'allowPrintCurrentTransaction': allowPrintCurrentTransaction};
  }
}
