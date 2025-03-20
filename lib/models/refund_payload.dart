class RefundPayload {
  final double amount;
  final String? transactionDate;
  final String? cvNumber;
  final String? originTerminal;
  final String? allowPrintCurrentTransaction;

  RefundPayload({required this.amount, this.transactionDate, this.cvNumber, this.originTerminal, this.allowPrintCurrentTransaction});

  static RefundPayload fromJson(Map<String, dynamic> map) {
    return RefundPayload(
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
