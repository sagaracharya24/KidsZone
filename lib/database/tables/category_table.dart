import 'dart:convert';

class CategoryTable {
  int? categoryId;
  String? categoryName;
  String? categoryImage;


  CategoryTable({
    this.categoryId,
    this.categoryName,
    this.categoryImage,
  });

  factory CategoryTable.fromRawJson(String str) =>
      CategoryTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryTable.fromJson(Map<String, dynamic> json) =>
      CategoryTable(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryImage: json["category_image"],

      );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category_name": categoryName,
    "category_image": categoryImage,

  };
}
