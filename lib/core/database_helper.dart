// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import '../models/expense.dart';
//
// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   static Database? _database;
//
//   DatabaseHelper._internal();
//
//   factory DatabaseHelper() {
//     return _instance;
//   }
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB();
//     return _database!;
//   }
//
//   Future<Database> _initDB() async {
//     String path = join(await getDatabasesPath(), 'expenses.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute(
//           "CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL, category TEXT, date TEXT)",
//         );
//       },
//     );
//   }
//
//   Future<int> insertExpense(Expense expense) async {
//     final db = await database;
//     return await db.insert('expenses', expense.toMap());
//   }
//
//   Future<List<Expense>> getExpenses() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('expenses');
//     return List.generate(maps.length, (i) => Expense.fromJson(maps[i]));
//   }
//
//   Future<int> deleteExpense(int id) async {
//     final db = await database;
//     return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
//   }
// }


import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/expense.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'expenses.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL, category TEXT, date TEXT, username TEXT)",
        );
      },
    );
  }

  // Insert an expense into the database with username
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  // Retrieve all expenses for a specific username
  Future<List<Expense>> getExpensesByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'date DESC',  // Optional: to order by date or id
    );

    return List.generate(maps.length, (i) {
      return Expense.fromJson(maps[i]);
    });
  }

  // Delete an expense by id
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}
