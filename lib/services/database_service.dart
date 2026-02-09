import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        note TEXT,
        date TEXT NOT NULL,
        isExpense INTEGER NOT NULL
      )
    ''');
  }

  Future<int> create(Expense expense) async {
    final db = await instance.database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> readAllExpenses() async {
    final db = await instance.database;
    final orderBy = 'date DESC';
    final result = await db.query('expenses', orderBy: orderBy);

    return result.map((json) => Expense.fromMap(json)).toList();
  }

  Future<List<Expense>> readExpensesByDay(DateTime date) async {
    final db = await instance.database;
    final dateString = date.toIso8601String().split('T')[0];

    final result = await db.query(
      'expenses',
      where: "date LIKE ?",
      whereArgs: ['$dateString%'],
      orderBy: 'date DESC',
    );

    return result.map((json) => Expense.fromMap(json)).toList();
  }

  Future<List<Expense>> readExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await instance.database;
    final startStr = DateTime(
      start.year,
      start.month,
      start.day,
    ).toIso8601String();
    final endStr = DateTime(
      end.year,
      end.month,
      end.day,
      23,
      59,
      59,
    ).toIso8601String();

    final result = await db.query(
      'expenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startStr, endStr],
      orderBy: 'date DESC',
    );

    return result.map((json) => Expense.fromMap(json)).toList();
  }

  Future<int> update(Expense expense) async {
    final db = await instance.database;

    return db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
