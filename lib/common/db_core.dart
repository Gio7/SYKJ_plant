import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbCore {
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
          await db.execute(searchCategorySql);
          await db.execute(diseaseCategorySql);
          await db.execute(diseaseCategoryItemSql);
        },
      );
    } catch (e) {
      print('Error opening database: $e');
    }
  }
}
