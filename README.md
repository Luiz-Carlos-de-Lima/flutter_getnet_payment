<h1 align="center">Flutter Getnet Payment</h1>

<div align="center" id="top">
  <img src="https://site.getnet.com.br/wp-content/uploads/2021/08/logo-getnet.png" alt="Getnet" height=30 style="margin: 20px 0px 0px 0px;" />
</div>

## Plugin não oficial

<a href="https://buymeacoffee.com/luiz.carlos199" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" width="150">
</a>
<br />

<a href="https://www.linkedin.com/in/luizcarlos199lcdl/" target="_blank">
    <img src="https://img.shields.io/badge/-LinkedIn-%230077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn" width="100"  style="margin: 5px 0px 5px 0;" />
</a>
<br />

<a href="https://github.com/Luiz-Carlos-de-Lima" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-black?style=for-the-badge&logo=github" alt="GitHub Repo" width="100" >
</a>

## Sobre

O **Flutter Getnet Payment** Plugin é uma solução não oficial desenvolvida para integrar as funcionalidades de pagamento da Getnet em aplicações Flutter executadas em terminais POS Android. Com este plugin, é possível processar transações de pagamento via `crédito`, `débito`, `voucher` e `Pix`, além de realizar `Estornos`, `impressão customizada` e `reimpressão da ultima transação` e `solicitar infomações do terminal` — tudo diretamente no dispositivo POS. A comunicação com os aplicativos da Getnet é feita por meio de deeplinks, garantindo uma integração segura, eficiente e fluída.

---

## Requisitos

Antes de utilizar o plugin, certifique-se de que os seguintes requisitos sejam atendidos:

- **Aplicação Android rodando em um terminal POS compatível**.
- **Versão mínima do Android**: 5.1+ (API 22).

---

## Modelos de POS Suportados

O plugin é compatível com os seguintes modelos de terminais POS:

- Ingenico APOS A8
- Ingenico DX8000
- Sunmi P2-B
- Newland N910

---

## Instalação

Adicione a dependência do plugin ao seu projeto Flutter:

```yaml
dependencies:
  flutter_getnet_payment: any
```

## Uso

Para utilizar o plugin, basta criar uma instância e chamar os métodos disponíveis:

```dart
import 'package:flutter_getnet_payment/flutter_getnet_payment.dart';

final _flutterGetnetPaymentPlugin = FlutterGetnetPayment();

// Para realizar um pagamento
final response = await _flutterGetnetPaymentPlugin.pay(paymentPayload: payment);

// para verificar o status de um pagamento, utilizado geralmente quando um pagamento está pendente
final response = await _flutterGetnetPaymentPlugin.statusPayment(statusPaymentPayload: statusPaymentPayload);

// Para realizar uma pré-autorização
final response = await _flutterGetnetPaymentPlugin.preAutorization(preAutorizationPayload: preAutorizationPayload);

// Para fazer o estorno de um pagamento
final response = await _flutterGetnetPaymentPlugin.refund(refundPayload: refundPayload);

// Para imprimir um recibo
await _flutterGetnetPaymentPlugin.print(printPayload: printPayload);

// Para reimprimir o último recibo
await _flutterGetnetPaymentPlugin.reprint();

// para obter informações do terminal POS
final response = await _flutterGetnetPaymentPlugin.info();
```

## Enums Disponíveis

### `GetnetPaymentType`

Define os tipos de transação disponíveis:

* `debit` - Transação via débito.

* `credit` - Transação via crédito.

* `voucher` - Transação com voucher.

* `pix` - Transação via PIX.

### `GetnetCreditType`

Utilizado apenas quando `GetnetPaymentType.credit`.

* `creditMerchant` - Crédito parcelado Lojista.

* `creditIssuer` - Crédito parcelado Emissor.

### `GetnetPrintType`

Define os tipos de impressão disponíveis:

* `text` - Impressão de texto.

* `line` - Impressão de linha.

* `image` - Impressão de imagem.

* `GetnetPrintAlign`

Define o alinhamento do conteúdo impresso na instância de ContentPrint, Utilizado apenas quando `GetnetPrintType.text`:

* `center` - Centralizado.

* `right` - Alinhado à direita.

* `left` - Alinhado à esquerda.

* `GetnetPrintSize`

Define o tamanho do texto impresso na instância de ContentPrint:
Utilizado apenas quando `GetnetPrintType.text`:

* `big` - Grande.

* `medium` - Médio.

* `small` - Pequeno.

## Exceptions

```dart	
GetnetPaymentException() // Exceção lançada quando ocorre algum erro na execução do método pay.
GetnetStatusPaymentException() // Exceção lançada quando ocorre algum erro na execução do método statusPayment.
GetnetPreAutorizationException() // Exceção lançada quando ocorre algum erro na execução do método preAutorization.
GetnetRefundException() // Exceção lançada quando ocorre algum erro na execução do método refund.
GetnetPrintException() // Exceção lançada quando ocorre algum erro na execução do método print.
GetnetReprintException() // Exceção lançada quando ocorre algum erro na execução do método reprint.
GetnetInfoException() // Exceção lançada quando ocorre algum erro na execução do método info.
```
## Método `pay`

No método `pay`, é necessário criar uma instância do tipo `GetnetPaymentPayload` com os seguintes parâmetros:

```dart	
final payment = GetnetPaymentPayload(
    amount: 150.00,
      paymentType: GetnetPaymentType.credit,
      creditType: GetnetCreditType.creditMerchant,
      installments: 3,
      callerId: Random().nextInt(1000).toString(),
      orderId: Random().nextInt(1000).toString(),
    );
```

A estrutura de `GetnetPaymentPayload` é a seguinte:

```dart
class GetnetPaymentPayload {
  final String callerId;
  final GetnetCurrencyPosition currencyPosition;
  final int currencyCode;
  final GetnetPaymentType paymentType;
  final GetnetCreditType? creditType;
  final int? installments;
  final double amount;
  final String orderId;

  GetnetPaymentPayload({
    required this.paymentType,
    this.currencyPosition = GetnetCurrencyPosition.CURRENCY_BEFORE_AMOUNT,
    this.currencyCode = 986,
    this.creditType,
    this.installments,
    required this.amount,
    required this.callerId,
    required this.orderId,
  }) : assert(
         paymentType != GetnetPaymentType.credit || creditType == null || (installments != null && installments > 1),
         "Installments cannot be null and must be greater than 1 when paymentType is 'credit' and creditType is 'creditMerchant' or 'creditIssuer'.",
       ),
       assert(callerId.length <= 50, 'callerId size must be less than or equal to 50 characters'),
       assert(orderId.length <= 50, 'orderId size must be less than or equal to 50 characters');

  static GetnetPaymentPayload fromJson(Map map) {
    return GetnetPaymentPayload(
      paymentType: GetnetPaymentType.values.byName(map['paymentType']),
      currencyPosition: GetnetCurrencyPosition.values.byName(map['currencyPosition']),
      currencyCode: map['currencyCode'] != null ? (map['currencyCode'] as num).toInt() : 986,
      creditType: map['creditType'] != null ? GetnetCreditType.values.byName(map['creditType']) : null,
      installments: map['installments'] != null ? (map['installments'] as num).toInt() : null,
      amount: (map['amount'] as num).toDouble(),
      callerId: map['callerId'],
      orderId: map['orderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentType': paymentType.name,
      'currencyPosition': currencyPosition.name,
      'currencyCode': currencyCode,
      'creditType': creditType?.name,
      'installments': installments,
      'amount': (amount * 100).round().toString().padLeft(12, '0'),
      'callerId': callerId,
      'orderId': orderId,
    };
  }
}

```

Caso o atributo `paymentType` for igual a `GetnetPaymentType.credit`, você pode informar o atributo `creditType` e `installments`.

se o `creditType` não for informado, vai ser considerado como pagamento à vista.

se o `creditType` for igual a `GetnetCreditType.creditMerchant` ou `GetnetCreditType.creditIssuer`, você deve informar o atributo `installments` onde ele deve ser maior que 1.

## Resposta do Pagamento

Caso a transação seja bem-sucedida, o retorno será uma instância do tipo `GetnetPaymentResponse` com a seguinte estrutura, Caso contrário, vai ser lançado uma exceção do tipo `GetnetPaymentException`.

```dart
class GetnetPaymentResponse {
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

  GetnetPaymentResponse({
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

  static GetnetPaymentResponse fromJson(Map map) {
    return GetnetPaymentResponse(
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
```

## Método `statusPayment`

No método `statusPayment`, é necessário criar uma instância do tipo `GetnetStatusPaymentPayload` com os seguintes parâmetros:

caso a propriedade `result` dos métodos `pay`, `preAuthorize` ou `refund` forem igual a '5', significa que a transação está pendente, sendo necessario fazer a chamada do `statusPayment`, vai ser necessário informar o `callerId` que foi informado no método `pay`, `preAuthorize` ou `refund`.

o `statusPayment` recebe como  parâmetro uma instancia de `GetnetStatusPaymentPayload`. sua inicialização é feita da seguinte forma:

a propriedade `callerId` é obrigatória, e deve ser informada, e é a mesma que foi informada no método `pay`, `preAuthorize` ou `refund`.

```dart
GetnetStatusPaymentPayload(
    callerId: '123456789',
    allowPrintCurrentTransaction: false,
);
```

a estrutura de `GetnetStatusPaymentPayload` é a seguinte:

```dart
class GetnetStatusPaymentPayload {
  final String callerId;
  final bool allowPrintCurrentTransaction;

  GetnetStatusPaymentPayload({required this.callerId, this.allowPrintCurrentTransaction = false});

  static GetnetStatusPaymentPayload fromJson(Map map) {
    return GetnetStatusPaymentPayload(callerId: map['callerId'], allowPrintCurrentTransaction: map['allowPrintCurrentTransaction']);
  }

  Map<String, dynamic> toJson() {
    return {'callerId': callerId, 'allowPrintCurrentTransaction': allowPrintCurrentTransaction};
  }
}
```

se a solicitação for bem sucedida, o retorno será uma instância de `GetnetStatusPaymentResponse`, caso contrário, será lançado uma exceção do tipo `GetnetStatusPaymentException`.

a estrutura de `GetnetStatusPaymentResponse` é a seguinte:

```dart
import 'package:flutter_getnet_payment/models/payment_response.dart';

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
      amount: json['amount'],
      callerId: json['callerId'],
      nsu: json['nsu'],
      nsuLastSuccesfullMessage: json['nsuLastSuccesfullMessage'],
      cvNumber: json['cvNumber'],
      receiptAlreadyPrinted: json['receiptAlreadyPrinted'],
      type: json['type'],
      brand: json['brand'],
      inputType: json['inputType'],
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
```

## Método `preAuthorize`

no método `preAuthorize`, é necessário criar uma instância do tipo `PreAuthorizePayload` com os seguintes parâmetros:

```dart
GetnetPreAutorizationPayload(
    amount: 150.00,
    callerId: '123456789',
    orderId: '123456789',
    allowPrintCurrentTransaction: false,
);
```

a estrutura de `GetnetPreAutorizationPayload` é a seguinte:

```dart
class GetnetPreAutorizationPayload {
  final double amount;
  final GetnetCurrencyPosition currencyPosition;
  final int currecyCode;
  final String callerId;
  final String? allowPrintCurrentTransaction;
  final String orderId;

  GetnetPreAutorizationPayload({
    required this.amount,
    this.currencyPosition = GetnetCurrencyPosition.CURRENCY_BEFORE_AMOUNT,
    this.currecyCode = 986,
    required this.callerId,
    this.allowPrintCurrentTransaction,
    required this.orderId,
  });

  static GetnetPreAutorizationPayload fromJson(Map map) {
    return GetnetPreAutorizationPayload(
      amount: int.parse(map['amount']) / 100,
      currencyPosition: map['currencyPosition'],
      currecyCode: map['currecyCode'] != null ? (map['currecyCode'] as num).toInt() : 986,
      callerId: map['callerId'],
      allowPrintCurrentTransaction: map['allowPrintCurrentTransaction'],
      orderId: map['orderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': (amount * 100).round().toString().padLeft(12, '0'),
      'currencyPosition': currencyPosition.name,
      'currecyCode': currecyCode,
      'callerId': callerId,
      'allowPrintCurrentTransaction': allowPrintCurrentTransaction,
      'orderId': orderId,
    };
  }
}
```

caso a solicitação seja bem sucedida, o retorno será uma instância de `PreAuthorizeResponse`, caso contrário, será lançado uma exceção do tipo `PreAuthorizeException`.

a estrutura de `PreAuthorizeResponse` é a seguinte:

```dart
class GetnetPreAutorizationResponse extends GetnetPaymentResponse {
  GetnetPreAutorizationResponse({
    required super.result,
    super.resultDetails,
    required super.amount,
    required super.callerId,
    super.nsu,
    required super.type,
    super.brand,
    super.installments,
    super.cardholderName,
    super.automationSlip,
    super.orderId,
    super.receiptAlreadyPrinted = false,
    super.inputType = "",
  });

  static GetnetPreAutorizationResponse fromJson({required Map json}) {
    return GetnetPreAutorizationResponse(
      result: json['result'],
      resultDetails: json['resultDetails'],
      amount: int.parse(json['amount']) / 100,
      callerId: json['callerId'],
      nsu: json['nsu'],
      type: json['type'],
      brand: json['brand'],
      installments: json['installments'],
      cardholderName: json['cardholderName'],
      automationSlip: json['automationSlip'],
      orderId: json['orderId'],
      receiptAlreadyPrinted: json['receiptAlreadyPrinted'],
      inputType: json['inputType'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'resultDetails': resultDetails,
      'amount': (amount * 100).round().toString().padLeft(12, '0'),
      'callerId': callerId,
      'nsu': nsu,
      'type': type,
      'brand': brand,
      'installments': installments,
      'cardholderName': cardholderName,
      'automationSlip': automationSlip,
      'orderId': orderId,
      'receiptAlreadyPrinted': receiptAlreadyPrinted,
      'inputType': inputType,
    };
  }
}
```

## Método `refund`

No método `refund`, é necessário criar uma instância do tipo `GetnetRefundPayload` com os seguintes parâmetros:

```dart	
GetnetRefundPayload(
    amount: 150.00,
    transactionDate: '29/07/2025' //data no formato dd/MM/yyyy,
    cvNumber: '123456789', //Número do CV da transação a ser estornada. É o mesmo campo que o pagamento retorna.
    originTerminal: '123456', // Pode ser obtido pelo método info
    allowPrintCurrentTransaction: false, // caso informado como true, o terminal não imprimirá o recibo e seu aplicativo ficará responsável por imprimir o recibo.
)
```

A estrutura de `GetnetRefundPayload` é a seguinte:

```dart
class GetnetRefundPayload {
  final double amount;

  /// Data da transação a ser estornada. caso null vai assumir o dia corrente. Enviar no formato: “dd/MM/yyyy”
  final String? transactionDate;
  final String? cvNumber;
  final String? originTerminal;
  final String? allowPrintCurrentTransaction;

  GetnetRefundPayload({required this.amount, this.transactionDate, this.cvNumber, this.originTerminal, this.allowPrintCurrentTransaction});

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

```

Se passado `com todos os parâmetros preenchidos`, a próxima tela a ser mostrada será a de inserir o cartão para realizar o estorno.

Se a requisição for enviada `com parâmetros faltando`, a próxima tela a ser mostrada será a de preenchimento manual dos parâmetros restantes. Ao preencher os parâmetros e tocar no botão Continuar, a tela de inserir o cartão será mostrada.

## Resposta do Estorno

Se a transação de estorno for bem-sucedida, o retorno será uma instância do tipo `GetnetRefundResponse` com a seguinte estrutura, caso contrario, será lançado uma exceção do tipo `GetnetRefundException`.

```dart	
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

```

## Método `print`

No método `print`, é necessário criar uma instância do tipo `GetnetPrintPayload` com os seguintes parâmetros:

```dart
GetnetPrintPayload(
  printableContent: [
    GetnetContentprint(
      type: GetnetPrintType.line,
      content: 'Texto a ser impresso'
    ),
     GetnetContentprint(
      type: GetnetPrintType.text,
      align: GetnetPrintAlign.center, //Obrigatório quando GetnetPrintType.text
      size: GetnetPrintSize.big, ////Obrigatório quando GetnetPrintType.text
      content: 'Texto a ser impresso'
    ),
     GetnetContentprint(
      type: GetnetPrintType.image, 
      imagePath: 'iVBORw0KGgoAAAANSUhEUgAAAHcAAAAuCAAAAAA309lpAAACMklEQVRYw91YQXLDIAyUMj027Us606f6RL7lJP0Ise/bg7ERSLLdZkxnyiVGIK0AoRVh0J+0l2ZITCAmSus8tYNNv9wUl8Xn2A6XZec8tsK9lN0zEaFBCxMc0M3IoHawBAAxffLx9/frY1kkEV0/iYjC8bjjmSRuCrHjcXMoS9zD4/nqePNf10v2whrkDRjLR4t8BWPXbdyRmccDgBMZUXDiiv2DeSK4sKwWrfgIda8V/6L6blZvLMARTescAohCD7xlcsItjYXEXHn2LIESzO3mDARPYTJXwiQ/VgWFobsYGKRdRy5x6/1QuAPpKdq89MiTS1x9EBXuYJyVZd46p6ndXVwAqfwJpd4C20uLk/LsUIilQ5Q11A4tuIU8Ti4bi8oz6lNX8iD8rNUdXDm3iMs81le4pUOLOJrGatzBx1VqVRSU8qAdNRc855GwHxcFblQbYTvqx3M0ZxZnZeBq+UoayI0h3y7QPMhOyQA9JMkO9aMIqs6Rmrw73T6ey9anvDX5kbinvT2PW7yYzj8ogrcYqBOJjNxc21d5EjmH0e/iaqUV9dXj3YgYtkvCjbjaqs5O+85MxVvwTcZdhR5YuFbckCSfNkHUolTcE9Cq9iQfXtV62bo9nUBIm8AXedPidimVFIjZCdYlTw4W8RtsatKC7Bt7D4t5tMle9qPD+y4uyL81FS/UnnVu3eMzhuj3G7CqzkHF77ISsaoraSsqVnRhq3rSZ+F5Ur//b5zOOVoAwDc6szxdC+PYAAAAAABJRU5ErkJggg=='
    )
  ], 
);
```

A propriedade `printableContent` é uma lista de objetos `GetnetContentprint` que representam o conteúdo a ser impresso. O objeto `GetnetContentprint` possui as seguintes propriedades:

```dart
class GetnetContentprint {
  final GetnetPrintType type;
  final String? content;
  final GetnetPrintAlign? align;
  final GetnetPrintSize? size;
  final String? imagePath;

  GetnetContentprint({required this.type, this.content, this.align, this.size = GetnetPrintSize.medium, this.imagePath})
    : assert(
        type != GetnetPrintType.text || (content is String && align is GetnetPrintAlign && size is GetnetPrintSize),
        "content, align, and size must be defined when type is text",
      ),
      assert(type != GetnetPrintType.image || imagePath is String, "imagePath cannot be null when type is image"),
      assert(type != GetnetPrintType.line || content is String, "content cannot be null when type is line");

  /// Método para formatar o conteúdo evitando cortes no meio das palavras e tratando palavras maiores que o limite da linha.
  String _formatContent() {
    if (type == GetnetPrintType.image || content == null || size == null) return content ?? '';

    int maxLength = _getMaxLength(size!);
    List<String> lines = [];
    List<String> words = content!.split(' ');
    String currentLine = '';

    for (var word in words) {
      if (word.length > maxLength) {
        // Se a palavra for maior que o limite da linha, quebra a palavra
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
          currentLine = '';
        }

        // Divide a palavra em partes do tamanho máximo permitido
        for (int i = 0; i < word.length; i += maxLength) {
          lines.add(word.substring(i, (i + maxLength) > word.length ? word.length : (i + maxLength)));
        }
      } else if (currentLine.isEmpty) {
        currentLine = word;
      } else if ((currentLine.length + word.length + 1) <= maxLength) {
        currentLine += ' $word';
      } else {
        lines.add(currentLine);
        currentLine = word;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines.join("\n");
  }

  /// Retorna o tamanho máximo de caracteres permitido para cada tamanho de impressão
  int _getMaxLength(GetnetPrintSize size) {
    switch (size) {
      case GetnetPrintSize.small:
        return 48;
      case GetnetPrintSize.medium:
      case GetnetPrintSize.big:
        return 32;
    }
  }

  Map<String, dynamic> toJson() {
    bool disableAlignAndSize = type != GetnetPrintType.text;

    return {
      'type': type.name.toString(),
      'content': type != GetnetPrintType.image ? _formatContent() : null,
      'align': disableAlignAndSize ? null : align?.name.toString(),
      'size': disableAlignAndSize ? null : size?.name.toString(),
      'imagePath': type == GetnetPrintType.image ? imagePath : null,
    };
  }

  static GetnetContentprint fromJson(Map<String, dynamic> json) {
    return GetnetContentprint(
      type: GetnetPrintType.values.firstWhere((e) => e.name == json['type']),
      content: json['content'],
      align: json['align'] != null ? GetnetPrintAlign.values.firstWhere((e) => e.name == json['align']) : null,
      size: GetnetPrintSize.values.firstWhere((e) => e.name == json['size']),
      imagePath: json['imagePath'],
    );
  }
}

```

A classe `GetnetContentprint` faz o gerenciamento do conteúdo a ser impresso, onde se o type é `GetnetPrintType.text` ou `GetnetPrintType.line`, o conteúdo é formatado para evitar cortes no meio das palavras e tratar palavras maiores que o limite da linha.

## Resposta de impressão

Caso a impressão seja bem-sucedida, a resposta será `void` caso contrário, será lançada uma exceção `GetnetPrintException` com a mensagem de erro.

## Método `reprint`

Este método é responsável por realizar a reimpressão da última transação impressa.
Não é necessário passar nenhum parâmetro para este método.

## Resposta de reeimpressão

Caso a Reimpressão seja bem-sucedida, a resposta será `void` caso contrário, será lançada uma exceção `GetnetReprintException` com a mensagem de erro.

## Método `info`

Este método é responsável por obter informações sobre o terminal POS.
Não é necessário passar nenhum parâmetro para este método.

## Resposta de informações

Caso a solicitação seja bem-sucedida, a resposta será um objeto `GetnetInfoResponse` com as informações do terminal POS.

Se a transação de estorno for bem-sucedida, o retorno será uma instância do tipo `GetnetInfoResponse` com as informações do terminal POS, caso contrario, será lançado uma exceção do tipo `GetnetRefundException`.

```dart
class GetnetInfoResponse {
  final String result;
  final String ec;
  final String numserie;
  final String numlogic;
  final String version;
  final String cnpjEC;
  final String razaoSocialEC;
  final String cidadeEC;

  GetnetInfoResponse({
    required this.result,
    required this.ec,
    required this.numserie,
    required this.numlogic,
    required this.version,
    required this.cnpjEC,
    required this.razaoSocialEC,
    required this.cidadeEC,
  });

  static GetnetInfoResponse fromJson({required Map json}) {
    return GetnetInfoResponse(
      result: json['result'],
      ec: json['ec'],
      numserie: json['numserie'],
      numlogic: json['numlogic'],
      version: json['version'],
      cnpjEC: json['cnpjEC'],
      razaoSocialEC: json['razaoSocialEC'],
      cidadeEC: json['cidadeEC'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'ec': ec,
      'numserie': numserie,
      'numlogic': numlogic,
      'version': version,
      'cnpjEC': cnpjEC,
      'razaoSocialEC': razaoSocialEC,
      'cidadeEC': cidadeEC,
    };
  }
}

```

## Considerações Finais

Este plugin foi desenvolvido para rodar exclusivamente em terminais POS Android suportados pela Getnet. Certifique-se de que sua aplicação atende a todos os requisitos antes de utilizá-lo.

Para mais informações, consulte a documentação oficial da Getnet ou entre em contato com o suporte técnico da empresa.

## :memo: Autores

Este projeto foi desenvolvido por:
<a href="https://github.com/Luiz-Carlos-de-Lima" target="_blank">Luiz Carlos de Lima</a>
</br>
<div> 
<a href="https://github.com/Luiz-Carlos-de-Lima">
  <img src="https://avatars.githubusercontent.com/u/82920625?s=400&u=a114c12a6e61d2f9b907feb450587a37aae068bb&v=4" height=90 />
</a>
<br>
<a href="https://github.com/Luiz-Carlos-de-Lima" target="_blank">Luiz Carlos de Lima</a>
</div>

&#xa0;

## Licença

Este projeto está sob a licença MIT.

<a href="#top">Voltar para o topo</a>