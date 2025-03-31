class GetnetRefundPayload {
  final double amount;

  /// Data da transação a ser estornada. caso null vai assumir o dia corrente. Enviar no formato: “dd/MM/yyyy”
  final String? transactionDate;
  final String? cvNumber;
  final String? originTerminal;
  final String? allowPrintCurrentTransaction;

  GetnetRefundPayload({
    required this.amount,
    this.transactionDate,
    this.cvNumber,
    this.originTerminal,
    this.allowPrintCurrentTransaction,
  });

  static GetnetRefundPayload fromJson(Map<String, dynamic> map) {
    return GetnetRefundPayload(
      amount: int.parse(map['amount']) / 100,
      transactionDate: map['transactionDate'],
      cvNumber: map['cvNumber'],
      originTerminal: map['originTerminal'],
      allowPrintCurrentTransaction: map['allowPrintCurrentTransaction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': (amount * 100).round().toString().padLeft(12, '0'),
      'transactionDate': transactionDate,
      'cvNumber': cvNumber,
      'originTerminal': originTerminal,
      'allowPrintCurrentTransaction': allowPrintCurrentTransaction,
    };
  }
}
