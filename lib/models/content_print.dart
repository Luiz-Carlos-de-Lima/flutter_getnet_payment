import 'package:flutter_getnet_payment/constants/print_content_types.dart';

class Contentprint {
  final PrintType type;
  final String? content;
  final PrintAlign? align;
  final PrintSize? size;
  final String? imagePath;

  Contentprint({required this.type, this.content, this.align, this.size, this.imagePath})
    : assert(
        type != PrintType.text || (content is String && align is PrintAlign && size is PrintSize),
        "content, align, and size must be defined when type is text",
      ),
      assert(type != PrintType.image || imagePath is String, "imagePath cannot be null when type is image"),
      assert(type != PrintType.line || content is String, "content cannot be null when type is line");

  Map<String, dynamic> toJson() {
    bool disableAlignAndSize = type != PrintType.text;

    return {
      'type': type.name.toString(),
      'content': type != PrintType.image ? content : null,
      'align': disableAlignAndSize ? null : align?.name.toString(),
      'size': disableAlignAndSize ? null : size?.name.toString(),
      'imagePath': type == PrintType.image ? imagePath : null,
    };
  }

  static Contentprint fromJson(Map<String, dynamic> json) {
    return Contentprint(
      type: PrintType.values.firstWhere((e) => e.name == json['type']),
      content: json['content'],
      align: json['align'] != null ? PrintAlign.values.firstWhere((e) => e.name == json['align']) : null,
      size: json['size'] != null ? PrintSize.values.firstWhere((e) => e.name == json['size']) : null,
      imagePath: json['imagePath'],
    );
  }
}
