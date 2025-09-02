import 'dart:convert';
import 'dart:math';

import 'package:flutter_getnet_payment/exceptions/getnet_pre_autorization_exception.dart';
import 'package:flutter_getnet_payment/models/getnet_pre_autorization_payload.dart';
import 'package:flutter_getnet_payment/constants/getnet_print_content_types.dart';
import 'package:flutter_getnet_payment/exceptions/getnet_payment_exception.dart';
import 'package:flutter_getnet_payment/exceptions/getnet_refund_exception.dart';
import 'package:flutter_getnet_payment/exceptions/getnet_print_exception.dart';
import 'package:flutter_getnet_payment/exceptions/getnet_info_exception.dart';
import 'package:flutter_getnet_payment/models/getnet_payment_response.dart';
import 'package:flutter_getnet_payment/constants/getnet_payment_type.dart';
import 'package:flutter_getnet_payment/models/getnet_payment_payload.dart';
import 'package:flutter_getnet_payment/constants/getnet_credit_type.dart';
import 'package:flutter_getnet_payment/models/getnet_refund_payload.dart';
import 'package:flutter_getnet_payment/models/getnet_content_print.dart';
import 'package:flutter_getnet_payment/models/getnet_print_payload.dart';
import 'package:flutter_getnet_payment/flutter_getnet_payment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

final flutterGetnetPaymentPlugin = FlutterGetnetPayment();
final List<GetnetPaymentResponse> listPayments = [];

void main() {
  runApp(const MaterialApp(home: PaymentApp()));
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            spacing: 15.0,
            children: [
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _PaymentPage()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  child: Text('Pagamento'),
                ),
              ),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _PreAutorizationPage()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  child: Text('Pre Autorização'),
                ),
              ),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _CancelPage()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  child: Text('Cancelar'),
                ),
              ),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _PrintPage()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: Text('Imprimir'),
                ),
              ),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await flutterGetnetPaymentPlugin.reprint();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Reimpressão realizada com sucesso!")));
                    } on GetnetInfoException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                    } on GetnetPrintException catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Não foi realizar a impressão das informações do terminal: ${e.message}")));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                  child: Text('Reimprimir'),
                ),
              ),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final info = await flutterGetnetPaymentPlugin.info();

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("info: ${info.toJson()}")));
                    } on GetnetInfoException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                  child: Text('Info'),
                ),
              ),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final info = await flutterGetnetPaymentPlugin.deviceInfo();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Device info: ${info.toJson()}")));
                    } on GetnetInfoException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
                  child: Text('Device Info'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentPage extends StatefulWidget {
  const _PaymentPage();

  @override
  State<_PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<_PaymentPage> {
  final _amountEC = TextEditingController();
  final _qtdEC = TextEditingController();

  final List<DropdownMenuItem<GetnetPaymentType?>> _listPaymentTypes =
      GetnetPaymentType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  final List<DropdownMenuItem<GetnetCreditType?>> _listCreditType =
      GetnetCreditType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  GetnetPaymentType _transactionType = GetnetPaymentType.debit;
  GetnetCreditType? _creditType;

  @override
  void initState() {
    super.initState();
    _listCreditType.add(DropdownMenuItem<GetnetCreditType>(value: null, child: Text('NENHUM')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('pagamento'), centerTitle: true, leading: Container()),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(alignment: Alignment.centerLeft, child: Text('Tipo do Pagamento')),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
                    height: 55,
                    child: DropdownButton(
                      value: _transactionType,
                      items: _listPaymentTypes,
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        _creditType = null;
                        _qtdEC.text = '';
                        _transactionType = value!;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Align(alignment: Alignment.centerLeft, child: Text('Valor')),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _amountEC,
                    decoration: InputDecoration(hintText: 'Valor', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                  // if (_transactionType == GetnetPaymentType.CREDIT)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft, child: Text('tipo parcelamento')),
                              SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
                                height: 55,
                                child: DropdownButton(
                                  value: _creditType,
                                  items: _listCreditType,
                                  isExpanded: true,
                                  underline: Container(),
                                  onChanged: (value) {
                                    _creditType = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft, child: Text('Qtd parcelamento')),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _qtdEC,
                                decoration: InputDecoration(hintText: 'Qtd parcelamento', border: OutlineInputBorder()),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: Text('Voltar'),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        double amount = double.parse(_amountEC.text);
                        int? qtdPar = int.tryParse(_qtdEC.text);
                        final payment = GetnetPaymentPayload(
                          amount: amount,
                          paymentType: _transactionType,
                          creditType: _creditType,
                          callerId: Random().nextInt(1000).toString(),
                          orderId: Random().nextInt(1000).toString(),
                          installments: qtdPar,
                        );
                        final response = await flutterGetnetPaymentPlugin.pay(paymentPayload: payment);
                        listPayments.add(response);
                        // final print = GetnetPrintPayload(
                        //   printableContent: [GetnetContentprint(type: GetnetPrintType.line, content: response.toJson().toString())],
                        // );
                        // await flutterGetnetPaymentPlugin.print(printPayload: print);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Simulacao pagamento e Impressão realizada com sucesso!")));
                      } on GetnetPaymentException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                      } on GetnetPrintException catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Simulação de pagamento realizado mas erro na impressão: ${e.message}")));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: Text('Pagar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreAutorizationPage extends StatefulWidget {
  const _PreAutorizationPage();

  @override
  State<_PreAutorizationPage> createState() => _PreAutorizationPageState();
}

class _PreAutorizationPageState extends State<_PreAutorizationPage> {
  final _amountEC = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('pagamento'), centerTitle: true, leading: Container()),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(alignment: Alignment.centerLeft, child: Text('Tipo do Pagamento')),
                  SizedBox(height: 10.0),
                  Align(alignment: Alignment.centerLeft, child: Text('Valor')),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _amountEC,
                    decoration: InputDecoration(hintText: 'Valor', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: Text('Voltar'),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        double amount = double.parse(_amountEC.text);
                        final preAutorization = GetnetPreAutorizationPayload(
                          amount: amount,
                          callerId: Random().nextInt(1000).toString(),
                          orderId: Random().nextInt(1000).toString(),
                        );
                        final response = await flutterGetnetPaymentPlugin.preAutorization(preAutorizationPayload: preAutorization);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Simulacao pre autorização ${response.toJson().toString()}")));
                      } on GetnetPreAutorizationException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                      } on GetnetPrintException catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Simulação de pagamento realizado mas erro na impressão: ${e.message}")));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: Text('Pagar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CancelPage extends StatefulWidget {
  const _CancelPage();

  @override
  State<_CancelPage> createState() => _CancelPageState();
}

class _CancelPageState extends State<_CancelPage> {
  int? _indexPayment;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('cancelar'), centerTitle: true, leading: Container()),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                spacing: 10,
                children: [
                  Text("Lista de pagamentos que podem ser cancelados"),
                  ...List.generate(
                    listPayments.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          _indexPayment = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(color: _indexPayment == index ? Colors.blue : Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                        child: Text(listPayments[index].amount.toString(), style: TextStyle(color: _indexPayment == index ? Colors.white : Colors.black)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: Text('Voltar'),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed:
                        _indexPayment != null
                            ? () async {
                              try {
                                String? input = listPayments[_indexPayment!].gmtDateTime?.toString();
                                String? formattedDate;

                                if (input != null) {
                                  String month = input.substring(0, 2); // MM
                                  String day = input.substring(2, 4); // DD
                                  String hour = input.substring(4, 6); // hh
                                  String minute = input.substring(6, 8); // mm
                                  String second = input.substring(8, 10); // ss

                                  DateTime now = DateTime.now();
                                  DateTime date = DateTime.utc(
                                    now.year, // Usando o ano atual
                                    int.parse(month), // Mês
                                    int.parse(day), // Dia
                                    int.parse(hour), // Hora
                                    int.parse(minute), // Minuto
                                    int.parse(second), // Segundo
                                  );

                                  twoDigits(int n) {
                                    if (n >= 10) return "$n";
                                    return "0$n";
                                  }

                                  formattedDate = "${twoDigits(date.day)}/${twoDigits(date.month)}/${twoDigits(date.year)}";
                                }
                                final info = await flutterGetnetPaymentPlugin.info();

                                final refundPayload = GetnetRefundPayload(
                                  amount: listPayments[_indexPayment!].amount,
                                  transactionDate: formattedDate,
                                  cvNumber: listPayments[_indexPayment!].cvNumber,
                                  originTerminal: info.numlogic.isNotEmpty ? info.numlogic : null,
                                );

                                final response = await flutterGetnetPaymentPlugin.refund(refundPayload: refundPayload);

                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text("Simulacao Estorno realizada com sucesso! ${response.toJson()}")));
                              } on GetnetRefundException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                              } on GetnetPrintException catch (e) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text("Simulação de pagamento realizado mas erro na impressão: ${e.message}")));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                              }
                            }
                            : null,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    child: Text('Cancelar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrintPage extends StatefulWidget {
  const _PrintPage();

  @override
  State<_PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<_PrintPage> {
  final _printTextEC = TextEditingController();
  final _imagePathEC = TextEditingController();
  final List<DropdownMenuItem<GetnetPrintType>> _listPrintType = GetnetPrintType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  final List<DropdownMenuItem<GetnetPrintAlign>> _listPrintAlign = GetnetPrintAlign.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  final List<DropdownMenuItem<GetnetPrintSize>> _listPrintSize = GetnetPrintSize.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();

  GetnetPrintType _printType = GetnetPrintType.line;
  GetnetPrintAlign? _printAlign;
  GetnetPrintSize? _printSize;
  bool _ignoreLineBreak = false;
  String? _defaultImage64;
  List<Map> _previewBase64 = [];

  final List<GetnetContentprint> _receiptContent = [];

  @override
  void initState() {
    super.initState();
    _loadDefaultImage();
  }

  @override
  void dispose() {
    _printTextEC.dispose();
    _imagePathEC.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultImage() async {
    final image64 = await imageToBase64('https://css-tricks.com/wp-content/uploads/2022/08/flutter-clouds.jpg');
    setState(() {
      _defaultImage64 = image64;
      if (_imagePathEC.text.isEmpty && image64 != null) {
        _imagePathEC.text = image64;
      }
    });
  }

  void _addToReceipt() {
    String? image64;
    if (_printType == GetnetPrintType.image) {
      image64 = _imagePathEC.text.isNotEmpty ? _imagePathEC.text : _defaultImage64;
      if (image64 == null || image64.isEmpty) return;
    }
    if (_printType != GetnetPrintType.image && _printTextEC.text.isEmpty) return;

    final item = GetnetContentprint(
      type: _printType,
      align: _printAlign,
      content: _printTextEC.text,
      size: _printSize,
      imagePath: image64,
      ignoreLineBreak: _ignoreLineBreak,
    );
    setState(() {
      _receiptContent.add(item);
      _printTextEC.clear();
    });
  }

  void _removeLine(int index) {
    setState(() {
      _receiptContent.removeAt(index);
    });
  }

  void _clearReceipt() {
    setState(() {
      _receiptContent.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Impressão'), centerTitle: true, leading: Container()),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Align(alignment: Alignment.centerLeft, child: Text('Tipo de Impressão')),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
                    height: 55,
                    child: DropdownButton(
                      value: _printType,
                      items: _listPrintType,
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        setState(() {
                          _printType = value!;
                          if (_printType == GetnetPrintType.text) {
                            _printAlign = GetnetPrintAlign.center;
                            _printSize = GetnetPrintSize.medium;
                          } else {
                            _printAlign = null;
                            _printSize = null;
                          }
                        });
                      },
                    ),
                  ),
                  if (_printType == GetnetPrintType.text) ...[
                    SizedBox(height: 10),
                    Align(alignment: Alignment.centerLeft, child: Text('Alinhamento da Impressão')),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
                      height: 55,
                      child: DropdownButton(
                        value: _printAlign,
                        items: _listPrintAlign,
                        isExpanded: true,
                        underline: Container(),
                        onChanged: (value) {
                          setState(() {
                            _printAlign = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(alignment: Alignment.centerLeft, child: Text('Tamanho da Impressão')),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
                      height: 55,
                      child: DropdownButton(
                        value: _printSize,
                        items: _listPrintSize,
                        isExpanded: true,
                        underline: Container(),
                        onChanged: (value) {
                          setState(() {
                            _printSize = value!;
                          });
                        },
                      ),
                    ),
                    SwitchListTile(
                      title: Text('Ignorar Quebra de Linha'),
                      value: _ignoreLineBreak,
                      onChanged: (val) {
                        setState(() {
                          _ignoreLineBreak = val;
                        });
                      },
                    ),
                  ],
                  if (_printType != GetnetPrintType.image)
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Align(alignment: Alignment.centerLeft, child: Text('Texto para Impressão')),
                        SizedBox(height: 10),
                        TextFormField(controller: _printTextEC, decoration: InputDecoration(hintText: 'Texto', border: OutlineInputBorder())),
                      ],
                    )
                  else
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Align(alignment: Alignment.centerLeft, child: Text('Base64 da Imagem')),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _imagePathEC,
                          decoration: InputDecoration(hintText: 'Cole o Base64 da imagem', border: OutlineInputBorder()),
                          minLines: 2,
                          maxLines: 4,
                        ),
                        if (_defaultImage64 != null)
                          Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Image.memory(base64Decode(_defaultImage64!))),
                      ],
                    ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: ElevatedButton(onPressed: _addToReceipt, child: Text('Adicionar ao Recibo'))),
                      SizedBox(width: 10),
                      Expanded(child: ElevatedButton(onPressed: _receiptContent.isEmpty ? null : _clearReceipt, child: Text('Remover tudo'))),
                    ],
                  ),
                  Divider(height: 32),
                  if (_receiptContent.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Conteúdo do Recibo:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ..._receiptContent.asMap().entries.map(
                          (entry) => Card(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(entry.value.type.name),
                              subtitle: Text(entry.value.type == GetnetPrintType.image ? 'Imagem' : (entry.value.content ?? '')),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Remover linha',
                                onPressed: () => _removeLine(entry.key),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  if (_previewBase64.isNotEmpty) ...[
                    Text("Pré-visualização:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ...List.generate(_previewBase64.length, (index) {
                      if (_previewBase64[index]['imageBase64'] is String && _previewBase64[index]['imageBase64'].isNotEmpty) {
                        return Column(
                          children: [
                            if (_previewBase64[index]['messageError'] != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(_previewBase64[index]['messageError'], style: TextStyle(color: Colors.red)),
                              ),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Image.memory(base64Decode(_previewBase64[index]['imageBase64']))),
                          ],
                        );
                      }

                      return SizedBox.shrink();
                    }),
                    SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: Text('Voltar'),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed:
                        _receiptContent.isEmpty
                            ? null
                            : () async {
                              try {
                                final print = GetnetPrintPayload(
                                  printableContent: List<GetnetContentprint>.from([
                                    GetnetContentprint(
                                      type: GetnetPrintType.text,
                                      align: GetnetPrintAlign.left,
                                      size: GetnetPrintSize.small,
                                      ignoreLineBreak: true,
                                      content: '''                 JCLAN SISTEMAS                 
------------------------------------------------
          BAR           
================================================
Comanda: 44             
------------------------------------------------
Entregar na Mesa: 12                            
------------------------------------------------
IMP: 01/2 (BR)                                  
At: 0 - Suporte                                 
Term: 1                       Dt: 25/08/25 11:01
================================================
Qtde - Produto                                  
------------------------------------------------
1 - FANTA UVA                                   
------------------------------------------------
                  Data Impressao: 25/08/25 11:01
                                                                 JCLAN SISTEMAS                 
------------------------------------------------
          BAR           
================================================
Comanda: 44             
------------------------------------------------
Entregar na Mesa: 12                            
------------------------------------------------
IMP: 11/2 (BR)                                  
At: 0 - Suporte                                 
Term: 1                       Dt: 25/08/25 11:01
================================================
Qtde - Produto                                  
------------------------------------------------
1 - DEL VALLE MARACUJA                          
------------------------------------------------
                  Data Impressao: 25/08/25 11:01
''',
                                    ),
                                  ]),
                                );
                                await flutterGetnetPaymentPlugin.print(printPayload: print);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Impressão realizada com sucesso!")));
                                setState(() {});
                              } on GetnetPrintException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                              }
                            },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: Text('Imprimir'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> imageToBase64(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao converter imagem para Base64: $e");
      }
    }
    return null;
  }
}
