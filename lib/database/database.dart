import 'package:expense_tracker/models/transaction.dart' as MyTransaction;
import 'package:expense_tracker/models/transaction_summary.dart';
import 'package:expense_tracker/widgets/category_summary.dart';
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
      version: 1,
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

  Future<List<MyTransaction.Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> res = await db.query("transactions");
    return List.generate(
      res.length,
      (i) {
        return MyTransaction.Transaction(
          id: res[i]['id'].toString(),
          title: res[i]['title'],
          amount: res[i]['amount'],
          category: res[i]['category'],
          date: DateTime.parse(res[i]['date']),
        );
      },
    );
  }

  Future<List<TransactionSummary>> getMonthSummary() async {
    final db = await database;
    var now = DateTime.now();
    var startOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    var endOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, 0));
    final List<Map<String, dynamic>> res = await db.rawQuery(
        "SELECT c.name, t.amount FROM categories c LEFT JOIN (SELECT category, SUM(amount) AS amount FROM transactions WHERE DATE(date) <= ? AND DATE(date) >= ? GROUP BY category)t ON t.category=c.name",
        [endOfMonth, startOfMonth]);
    return List.generate(
      res.length,
      (i) {
        return TransactionSummary(
          category: res[i]['category'],
          amount: res[i]['amount'],
        );
      },
    );
  }

  Future<dynamic> getSummaryByCategory(String category) async {
    final db = await database;
    var res = await db
        .rawQuery("SELECT * FROM transactions WHERE category=?", [category]);
    return res;
  }
}
