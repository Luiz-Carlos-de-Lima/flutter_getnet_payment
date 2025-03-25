import 'package:flutter_getnet_payment/constants/print_content_types.dart';

class Contentprint {
  final PrintType type;
  final String? content;
  final PrintAlign? align;
  final PrintSize? size;
  final String? imagePath;

  Contentprint({required this.type, this.content, this.align, this.size = PrintSize.medium, this.imagePath})
    : assert(
        type != PrintType.text || (content is String && align is PrintAlign && size is PrintSize),
        "content, align, and size must be defined when type is text",
      ),
      assert(type != PrintType.image || imagePath is String, "imagePath cannot be null when type is image"),
      assert(type != PrintType.line || content is String, "content cannot be null when type is line");

  /// Método para formatar o conteúdo evitando cortes no meio das palavras e tratando palavras maiores que o limite da linha.
  String _formatContent() {
    if (type == PrintType.image || content == null || size == null) return content ?? '';

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
  int _getMaxLength(PrintSize size) {
    switch (size) {
      case PrintSize.small:
        return 48;
      case PrintSize.medium:
      case PrintSize.big:
        return 32;
    }
  }

  Map<String, dynamic> toJson() {
    bool disableAlignAndSize = type != PrintType.text;

    return {
      'type': type.name.toString(),
      'content': type != PrintType.image ? _formatContent() : null,
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
      size: PrintSize.values.firstWhere((e) => e.name == json['size']),
      imagePath: json['imagePath'],
    );
  }
}
