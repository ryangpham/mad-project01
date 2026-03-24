import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/meal.dart';
import '../models/restaurant.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  //Single shared instance of database helper
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const String _databaseName = 'pantherbites.db';
  static const int _databaseVersion = 1;

  static const String mealsTable = 'meals';
  static const String favoritesTable = 'favorites';

  //notifier to trrigger UI updates for when meals change
  final ValueNotifier<int> mealsRevision = ValueNotifier<int>(0);

  Database? _database;

  //Initializes the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  //Makes sure that the database is initialized
  Future<void> initializeDatabase() async {
    await database;
  }

  //Create/open database file
  Future<Database> _initDatabase() async {
    final dbFactory = _getDatabaseFactory();
    final databasesPath = await dbFactory.getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return dbFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: _databaseVersion,
        onCreate: _onCreate, //called when DB is first made
        onUpgrade: _onUpgrade, //Called when version changes
      ),
    );
  }

  //Select correct database factory based on platform
  DatabaseFactory _getDatabaseFactory() {
    if (kIsWeb) {
      return databaseFactoryFfiWeb;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        sqfliteFfiInit();
        return databaseFactoryFfi;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return databaseFactory;
    }
  }

  //creates tables when DB is first created
  Future<void> _onCreate(Database db, int version) async {
    // Meals table for budget tracking
    await db.execute('''
      CREATE TABLE $mealsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mealName TEXT NOT NULL,
        restaurantName TEXT NOT NULL,
        price REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    //Favorites table of saved restaurants
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

  //Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  //insert new meal into database
  Future<int> insertMeal(Meal meal) async {
    final db = await database;
    final id = await db.insert(mealsTable, meal.toMap());
    mealsRevision.value++; //Notifies UI of change
    return id;
  }

  //Retrieve all meals (latest first)
  Future<List<Meal>> getMeals() async {
    final db = await database;
    final maps = await db.query(mealsTable, orderBy: 'id DESC');

    return maps.map(Meal.fromMap).toList();
  }

  //update an existing meal
  Future<int> updateMeal(Meal meal) async {
    final db = await database;
    final count = await db.update(
      mealsTable,
      meal.toMap(),
      where: 'id = ?',
      whereArgs: [meal.id],
    );
    if (count > 0) {
      mealsRevision.value++;
    }
    return count;
  }

  //Deletes meal by ID
  Future<int> deleteMeal(int id) async {
    final db = await database;
    final count = await db.delete(mealsTable, where: 'id = ?', whereArgs: [id]);
    if (count > 0) {
      mealsRevision.value++;
    }
    return count;
  }

  //Add a restaurant to favorites
  Future<int> addFavorite(Restaurant restaurant) async {
    final db = await database;
    return db.insert(favoritesTable, restaurant.toMap());
  }

  //Retrieves all favorite restaurants
  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final maps = await db.query(favoritesTable, orderBy: 'id DESC');

    return maps.map(Restaurant.fromMap).toList();
  }

  //Update favorite restaurant info
  Future<int> updateFavorite(Restaurant restaurant) async {
    final db = await database;
    return db.update(
      favoritesTable,
      restaurant.toMap(),
      where: 'id = ?',
      whereArgs: [restaurant.id],
    );
  }

  //Remove restaurant from favorites
  Future<int> removeFavorite(int id) async {
    final db = await database;
    return db.delete(favoritesTable, where: 'id = ?', whereArgs: [id]);
  }
}
