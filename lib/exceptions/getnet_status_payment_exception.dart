class GetnetStatusPaymentException implements Exception {
  final String message;

  /// Código do erro do canal nativo (ERROR, CANCELLED, UNAVAILABLE...).
  final String? code;

  /// Código `result` devolvido pela Getnet. `3` com "NÃO FORAM ENCONTRADOS DADOS..." indica transação não aprovada ou desconhecida.
  final String? result;
  final String? resultDetails;

  /// `start` quando o deeplink nem chegou a ser aberto; `result` quando a Getnet respondeu.
  final String? stage;

  GetnetStatusPaymentException({required this.message, this.code, this.result, this.resultDetails, this.stage});
}
