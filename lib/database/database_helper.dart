import 'package:flutter/services.dart';
import 'package:kids_preschool/database/tables/category_table.dart';
import 'package:kids_preschool/database/tables/item_table.dart';
import 'package:kids_preschool/database/tables/alphabets_table.dart';
import 'package:kids_preschool/database/tables/spelling_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper.internal();

  factory DataBaseHelper() => instance;

  Database? _db;

  DataBaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  init() async {
    var dbPath = await getDatabasesPath();

    String dbPathKidsAllInOne = path.join(dbPath, "KidPreschoolLearnigFlutter.db");

    bool dbExistsEnliven = await io.File(dbPathKidsAllInOne).exists();

    if (!dbExistsEnliven) {
      ByteData data = await rootBundle
          .load(path.join("assets/database", "KidPreschoolLearnigFlutter.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await io.File(dbPathKidsAllInOne).writeAsBytes(bytes, flush: true);
    }

    return _db = await openDatabase(dbPathKidsAllInOne);
  }

  String categoryTable = "CategoryTable";
  String itemTable = "ItemsTable";
  String alphabetsTable = "AlphabetsTable";
  String spellingTable = "SpellingTable";

  Future<List<CategoryTable>> getCategoryData() async {
    List<CategoryTable> categoryList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
    await dbClient.rawQuery("SELECT * FROM $categoryTable");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var categoryData = CategoryTable.fromJson(answer);
        categoryList.add(categoryData);
      }
    }

    return categoryList;
  }

  Future<List<ItemTable>> getItemData(int categoryId) async {
    List<ItemTable> itemList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
    await dbClient.rawQuery("SELECT * FROM $itemTable where category_id = $categoryId");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var itemData = ItemTable.fromJson(answer);
        itemList.add(itemData);
      }
    }

    return itemList;
  }

  Future<List<AlphabetsTable>> getAlphabetsData() async {
    List<AlphabetsTable> alphabetsList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
    await dbClient.rawQuery("SELECT * FROM $alphabetsTable");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var alphabetsData = AlphabetsTable.fromJson(answer);
        alphabetsList.add(alphabetsData);
      }
    }
    return alphabetsList;
  }

  Future<List<SpellingTable>> getSpellingData() async {
    List<SpellingTable> spellList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
    await dbClient.rawQuery("SELECT * FROM $spellingTable");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var spellData = SpellingTable.fromJson(answer);
        spellList.add(spellData);
      }
    }
    return spellList;
  }

}
