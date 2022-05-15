import 'dart:convert';

class SpellingTable {
  int? spellingId;
  String? spelling;
  String? image;


  SpellingTable({
    this.spellingId,
    this.spelling,
    this.image,
  });

  factory SpellingTable.fromRawJson(String str) =>
      SpellingTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SpellingTable.fromJson(Map<String, dynamic> json) =>
      SpellingTable(
        spellingId: json["spelling_id"],
        spelling: json["spelling"],
        image: json["image"],

      );

  Map<String, dynamic> toJson() => {
    "spelling_id": spellingId,
    "spelling": spelling,
    "image": image,
  };
}
