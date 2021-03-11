import 'package:expense_tracker/models/transaction.dart' as MyTransaction;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:intl/intl.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'expenses.db'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE transactions (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            amount REAL,
            category TEXT,
            date TEXT
          );
          ''');
        await db.execute('''CREATE TABLE categories (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL
          );
        ''');
        await db.execute('''INSERT INTO categories(name)
          VALUES ('Food'),('Groceries'),('Travel'),('Beauty'),('Entertainment'),('Other');
        ''');
      },
      version: 4,
    );
  }

  newTransaction(MyTransaction.Transaction transaction) async {
    final db = await database;

    var res = await db.rawInsert('''
      INSERT INTO transactions(
        title, amount, category, date
      ) VALUES(?,?,?,?)
    ''', [
      transaction.title,
      transaction.amount,
      transaction.category,
      DateFormat('yyyy-MM-dd').format(transaction.date)
    ]);

    return res;
  }

  Future<dynamic> getTransactions() async {
    final db = await database;
    var res = await db.query("transactions");
    if (res.length == 0) {
      return null;
    } else {
      var resMap = res[0];
      return resMap.isNotEmpty ? resMap : Null;
    }
  }

  Future<dynamic> getMonthSummary() async {
    final db = await database;
    var now = DateTime.now();
    var startOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    var endOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, 0));
    var res = await db.rawQuery(
        "SELECT c.name, tt.amount FROM categories c LEFT JOIN (SELECT t.category, SUM(t.amount) AS amount FROM transactions t WHERE DATE(t.date) <= ? AND DATE(t.date) >= ?)tt ON tt.category=c.name",
        [endOfMonth, startOfMonth]);
    return res;
  }

  Future<dynamic> getSummaryByCategory(String category) async {
    final db = await database;
    var res = await db
        .rawQuery("SELECT * FROM transactions WHERE category=?", [category]);
    res.forEach((element) {
      print('TX => $element');
    });
    return res;
  }
}
