import 'dart:convert';

class ItemTable {
  int? categoryId;
  int? itemId;
  String? itemName;
  String? itemImage;


  ItemTable({
    this.categoryId,
    this.itemId,
    this.itemName,
    this.itemImage,
  });

  factory ItemTable.fromRawJson(String str) =>
      ItemTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemTable.fromJson(Map<String, dynamic> json) =>
      ItemTable(
        categoryId: json["category_id"],
        itemId: json["item_id"],
        itemName: json["item_name"],
        itemImage: json["item_image"],

      );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "item_id": itemId,
    "item_name": itemName,
    "item_image": itemImage,

  };
}
