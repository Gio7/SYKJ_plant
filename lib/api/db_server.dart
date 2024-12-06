// ignore_for_file: depend_on_referenced_packages

import 'package:plant/pages/diagnose_home/categorized_feed_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbServer {
  static Database? _database;

  static Future<Database?> get database async {
    if (_database == null) {
      await openLocalDatabase();
    }
    return _database;
  }

  static void closeLocalDatabase() {
    _database?.close();
  }

  static Future<void> openLocalDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      _database = await openDatabase(
        join(dbPath, 'plant_data.db'),
        version: 1,
        onOpen: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          const searchCategorySql = '''
          CREATE TABLE search_category (
            categoryId TEXT PRIMARY KEY,
            title TEXT,
            thumbnailUrl TEXT
          );
          ''';
          const diseaseCategorySql = '''
          CREATE TABLE disease_category (
            categoryId INTEGER PRIMARY KEY,
            categoryName TEXT NOT NULL,
            imageUrl TEXT
          );
          ''';
          const diseaseCategoryItemSql = '''
          CREATE TABLE disease_category_item (
            itemId INTEGER PRIMARY KEY AUTOINCREMENT,
            categoryId INTEGER,
            heading TEXT NOT NULL,
            description TEXT,
            thumbnailUrl TEXT,
            resourceUrl TEXT,
            feedType INTEGER,
            important INTEGER,
            FOREIGN KEY (categoryId) REFERENCES disease_category (categoryId)
          );
          ''';
          const chatSql = '''
          CREATE TABLE chat (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            isSelf INTEGER NOT NULL, 
            createTime INTEGER, 
            content TEXT
          );
          ''';
          await db.execute(searchCategorySql);
          await db.execute(diseaseCategorySql);
          await db.execute(diseaseCategoryItemSql);
          await db.execute(chatSql);
        },
      );
    } catch (e) {
      // print('Error opening database: $e');
    }
  }

  // MARK: - API

  /// 获取疾病分类列表
  static Future<List<Map<String, dynamic>>> getCategoriesByDB() async {
    final db = await database;
    final res = await db?.query('disease_category');
    return res ?? [];
  }

  /// 获取疾病分类下的疾病列表
  static Future<List<Map<String, dynamic>>> getCategoryItemByDB(int categoryId) async {
    final db = await database;
    final res = await db?.query('disease_category_item', where: 'categoryId = ?', whereArgs: [categoryId]);
    return res ?? [];
  }

  /// 更新疾病分类
  static Future<void> insertCategoriesAndItems(List<CategorizedFeedModel> categoryList) async {
    final db = await database;
    // 插入前清空数据，避免数据更新后存在错误数据
    await db?.delete('disease_category_item');
    await db?.delete('disease_category');
    await db?.transaction((txn) async {
      for (final categoryData in categoryList) {
        await txn.insert('disease_category', categoryData.toMapDB(), conflictAlgorithm: ConflictAlgorithm.replace);

        for (final itemData in categoryData.item) {
          await txn.insert('disease_category_item', itemData.toMapDB(categoryData.categoryId), conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    });
  }

  /// 获取搜索分类列表
  static Future<List<Map<String, dynamic>>> getPlantTypesByDB() async {
    final db = await database;
    final res = await db?.query('search_category');
    return res ?? [];
  }

  /// 更新搜索分类
  static Future<void> insertOrUpdatePlantType(List<dynamic> plantTypeList) async {
    final db = await database;
    // 插入前清空数据，避免数据更新后存在错误数据
    await db?.delete('search_category');
    final batch = db?.batch();

    for (final plantType in plantTypeList) {
      batch?.insert(
        'search_category',
        plantType,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch?.commit(noResult: true);
  }

  /// 查询聊天表是否存在数据
  /* static Future<bool> isChatDataExist() async {
    final db = await database;
    final result = await db?.rawQuery('SELECT COUNT(*) FROM chat');
    return result != null && result.isNotEmpty;
  } */

  /// 获取搜索分类列表
  static Future<List<Map<String, dynamic>>> getChatList() async {
    final db = await database;
    final res = await db?.query('chat', orderBy: 'id DESC');
    return res ?? [];
  }

  /// 插入聊天数据
  static Future<Map<String, dynamic>> insertChatData(String content, {required bool isSelf}) async {
    final db = await database;
    final Map<String, dynamic> map = {
      'isSelf': isSelf ? 1 : 0,
      'createTime': DateTime.now().millisecondsSinceEpoch,
      'content': content,
    };
    final id = await db?.insert(
      'chat',
      map,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    map['id'] = id;
    return map;
  }
}
