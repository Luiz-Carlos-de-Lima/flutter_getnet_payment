import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_getnet_payment_method_channel.dart';

abstract class FlutterGetnetPaymentPlatform extends PlatformInterface {
  /// Constructs a FlutterGetnetPaymentPlatform.
  FlutterGetnetPaymentPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterGetnetPaymentPlatform _instance = MethodChannelFlutterGetnetPayment();

  /// The default instance of [FlutterGetnetPaymentPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterGetnetPayment].
  static FlutterGetnetPaymentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterGetnetPaymentPlatform] when
  /// they register themselves.
  static set instance(FlutterGetnetPaymentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
