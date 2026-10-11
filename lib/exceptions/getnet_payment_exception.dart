class GetnetPaymentException implements Exception {
  final String message;

  /// Código do erro do canal nativo (ERROR, CANCELLED, UNAVAILABLE...).
  final String? code;

  /// Código `result` devolvido pela Getnet (1 negada, 2 cancelada, 3 falha, 4 desconhecido).
  final String? result;
  final String? resultDetails;

  /// `start` quando o deeplink nem chegou a ser aberto; `result` quando a Getnet respondeu.
  final String? stage;

  GetnetPaymentException({required this.message, this.code, this.result, this.resultDetails, this.stage});
}
