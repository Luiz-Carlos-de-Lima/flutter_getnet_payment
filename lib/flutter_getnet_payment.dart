
import 'flutter_getnet_payment_platform_interface.dart';

class FlutterGetnetPayment {
  Future<String?> getPlatformVersion() {
    return FlutterGetnetPaymentPlatform.instance.getPlatformVersion();
  }
}
