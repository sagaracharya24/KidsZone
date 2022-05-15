import 'dart:convert';

class AlphabetsTable {
  int? alphabetId;
  String? name;
  String? ttsText;
  String? objectImage;
  String? alphaImage;

  AlphabetsTable({
    this.alphabetId,
    this.name,
    this.ttsText,
    this.objectImage,
    this.alphaImage,
  });

  factory AlphabetsTable.fromRawJson(String str) =>
      AlphabetsTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlphabetsTable.fromJson(Map<String, dynamic> json) =>
      AlphabetsTable(
        alphabetId: json["alphabets_id"],
        name: json["name"],
        ttsText: json["tts_text"],
        objectImage: json["object_image"],
        alphaImage: json["alpha_image"],
      );

  Map<String, dynamic> toJson() => {
    "alphabets_id": alphabetId,
    "name": name,
    "tts_text": ttsText,
    "object_image": objectImage,
    "alpha_image": alphaImage,
  };
}
