import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_getnet_payment/constants/payment_type.dart';
import 'package:flutter_getnet_payment/flutter_getnet_payment.dart';
import 'package:flutter_getnet_payment/models/payment_payload.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterGetnetPaymentPlugin = FlutterGetnetPayment();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await _flutterGetnetPaymentPlugin.pay(paymentPayload: PaymentPayload(paymentType: PaymentType.debit, amount: 10.0, callerId: '1234', orderId: '1234'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(title: const Text('Plugin example app')), body: Center(child: Text('Running on: $_platformVersion\n'))));
  }
}
