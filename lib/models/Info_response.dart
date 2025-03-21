class InfoResponse {
  final String result;
  final String ec;
  final String numserie;
  final String numlogic;
  final String version;
  final String cnpjEC;
  final String razaoSocialEC;
  final String cidadeEC;

  InfoResponse({
    required this.result,
    required this.ec,
    required this.numserie,
    required this.numlogic,
    required this.version,
    required this.cnpjEC,
    required this.razaoSocialEC,
    required this.cidadeEC,
  });

  static InfoResponse fromJson({required Map json}) {
    return InfoResponse(
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
