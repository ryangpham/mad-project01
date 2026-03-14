import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/meal.dart';
import '../models/restaurant.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const String _databaseName = 'pantherbites.db';
  static const int _databaseVersion = 1;

  static const String mealsTable = 'meals';
  static const String favoritesTable = 'favorites';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> initializeDatabase() async {
    await database;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $mealsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mealName TEXT NOT NULL,
        restaurantName TEXT NOT NULL,
        price REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $favoritesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price TEXT NOT NULL,
        distance REAL NOT NULL,
        hours TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertMeal(Meal meal) async {
    final db = await database;
    return db.insert(mealsTable, meal.toMap());
  }

  Future<List<Meal>> getMeals() async {
    final db = await database;
    final maps = await db.query(mealsTable, orderBy: 'id DESC');

    return maps.map(Meal.fromMap).toList();
  }

  Future<int> addFavorite(Restaurant restaurant) async {
    final db = await database;
    return db.insert(favoritesTable, restaurant.toMap());
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final maps = await db.query(favoritesTable, orderBy: 'id DESC');

    return maps.map(Restaurant.fromMap).toList();
  }
}
