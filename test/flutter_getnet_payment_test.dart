import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_getnet_payment/flutter_getnet_payment.dart';
import 'package:flutter_getnet_payment/flutter_getnet_payment_platform_interface.dart';
import 'package:flutter_getnet_payment/flutter_getnet_payment_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterGetnetPaymentPlatform
    with MockPlatformInterfaceMixin
    implements FlutterGetnetPaymentPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterGetnetPaymentPlatform initialPlatform = FlutterGetnetPaymentPlatform.instance;

  test('$MethodChannelFlutterGetnetPayment is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterGetnetPayment>());
  });

  test('getPlatformVersion', () async {
    FlutterGetnetPayment flutterGetnetPaymentPlugin = FlutterGetnetPayment();
    MockFlutterGetnetPaymentPlatform fakePlatform = MockFlutterGetnetPaymentPlatform();
    FlutterGetnetPaymentPlatform.instance = fakePlatform;

    expect(await flutterGetnetPaymentPlugin.getPlatformVersion(), '42');
  });
}
