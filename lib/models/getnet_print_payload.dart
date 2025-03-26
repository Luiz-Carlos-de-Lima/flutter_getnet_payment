import 'package:flutter_getnet_payment/models/getnet_content_print.dart';

class GetnetPrintPayload {
  final List<GetnetContentprint> printableContent;

  GetnetPrintPayload({required this.printableContent});

  Map<String, dynamic> toJson() {
    return {'printable_content': printableContent.map((e) => e.toJson()).toList()};
  }

  static GetnetPrintPayload fromJson(Map json) {
    return GetnetPrintPayload(printableContent: json['printable_content'].map<GetnetContentprint>((e) => GetnetContentprint.fromJson(e)).toList());
  }
}
