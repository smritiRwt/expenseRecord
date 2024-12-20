// lib/database/database_helper.dart

import 'package:expense_tracker/model/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expense_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE expenses(id INTEGER PRIMARY KEY, description TEXT, amount REAL, category TEXT, date TEXT)',
        );
      },
    );
  }

  // Get all expenses
  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  // Insert a new expense
  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await database;
    await db.update(
      'expenses', // Table name
      expense.toMap(), // Expense data as a map
      where: 'id = ?', // Update condition based on ID
      whereArgs: [expense.id],
    );
  }

  // Delete an expense
  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
