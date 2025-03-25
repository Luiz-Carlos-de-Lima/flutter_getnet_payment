import 'package:flutter_getnet_payment/models/content_print.dart';

class PrintPayload {
  final List<Contentprint> printableContent;

  PrintPayload({required this.printableContent});

  Map<String, dynamic> toJson() {
    return {
      'printable_content': printableContent.map((e) => e.toJson()).toList(),
    };
  }

  static PrintPayload fromJson(Map json) {
    return PrintPayload(
      printableContent:
          json['printable_content']
              .map<Contentprint>((e) => Contentprint.fromJson(e))
              .toList(),
    );
  }
}
