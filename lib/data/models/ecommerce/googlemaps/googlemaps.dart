class AutocompleteModel {
  AutocompleteModel({
    required this.predictions,
    required this.status,
  });

  List<PredictionModel> predictions;
  String status;

  factory AutocompleteModel.fromJson(Map<String, dynamic> json) => AutocompleteModel(
    predictions: List<PredictionModel>.from(json["predictions"].map((x) => PredictionModel.fromJson(x))),
    status: json["status"],
  );
}

class PredictionModel {
  PredictionModel({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });

  String description;
  List<MatchedSubstring> matchedSubstrings;
  String placeId;
  String reference;
  StructuredFormatting structuredFormatting;
  List<Term> terms;
  List<String> types;

  factory PredictionModel.fromJson(Map<String, dynamic> json) => PredictionModel(
    description: json["description"],
    matchedSubstrings: List<MatchedSubstring>.from(json["matched_substrings"].map((x) => MatchedSubstring.fromJson(x))),
    placeId: json["place_id"],
    reference: json["reference"],
    structuredFormatting: StructuredFormatting.fromJson(json["structured_formatting"]),
    terms: List<Term>.from(json["terms"].map((x) => Term.fromJson(x))),
    types: List<String>.from(json["types"].map((x) => x)),
  );
}

class MatchedSubstring {
  MatchedSubstring({
    required this.length,
    required this.offset,
  });

  int length;
  int offset;

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) => MatchedSubstring(
    length: json["length"],
    offset: json["offset"],
  );
}

class StructuredFormatting {
  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  String mainText;
  List<MatchedSubstring> mainTextMatchedSubstrings;
  String secondaryText;

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) => StructuredFormatting(
    mainText: json["main_text"],
    mainTextMatchedSubstrings: List<MatchedSubstring>.from(json["main_text_matched_substrings"].map((x) => MatchedSubstring.fromJson(x))),
    secondaryText: json["secondary_text"],
  );
}

class Term {
  Term({
    required this.offset,
    required this.value,
  });

  int offset;
  String value;

  factory Term.fromJson(Map<String, dynamic> json) => Term(
    offset: json["offset"],
    value: json["value"],
  );
}