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

  updateTransaction(MyTransaction.Transaction transaction) async {
    final db = await database;

    await db.rawUpdate('''
    UPDATE transactions SET title=?, amount=?, category=?, date=? WHERE id=?
    ''', [
      transaction.title,
      transaction.amount,
      transaction.category,
      DateFormat('yyyy-MM-dd').format(transaction.date),
      transaction.id,
    ]);
  }

  deleteTransaction(int transactionId) async {
    final db = await database;
    await db
        .delete("transactions", where: 'id = ?', whereArgs: [transactionId]);
  }

  Future<List<MyTransaction.Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> res = await db.query("transactions");
    return generateTransactionList(res);
  }

  Future<List<TransactionSummary>> getMonthSummary(DateTime monthDate) async {
    final db = await database;
    String startOfMonth = DateFormat('yyyy-MM-dd')
        .format(DateTime(monthDate.year, monthDate.month, 1));
    String endOfMonth = DateFormat('yyyy-MM-dd')
        .format(DateTime(monthDate.year, monthDate.month + 1, 0));
    final List<Map<String, dynamic>> res = await db.rawQuery(
        "SELECT c.name, t.amount FROM categories c LEFT JOIN (SELECT category, SUM(amount) AS amount FROM transactions WHERE DATE(date) <= ? AND DATE(date) >= ? GROUP BY category)t ON t.category=c.name",
        [endOfMonth, startOfMonth]);
    return List.generate(
      res.length,
      (i) {
        return TransactionSummary(
          category: res[i]['name'],
          amount: res[i]['amount'],
        );
      },
    );
  }

  Future<List<MyTransaction.Transaction>> getSummaryByCategory(
      String category) async {
    final db = await database;
    var now = DateTime.now();
    var startOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    var endOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, 0));
    final List<Map<String, dynamic>> res = await db.rawQuery(
        "SELECT * FROM transactions WHERE category=? AND DATE(date) <= ? AND DATE(date) >= ?",
        [category, endOfMonth, startOfMonth]);
    return generateTransactionList(res);
  }

  List<MyTransaction.Transaction> generateTransactionList(
      List<Map<String, dynamic>> records) {
    return List.generate(
      records.length,
      (i) {
        return MyTransaction.Transaction(
          id: records[i]['id'].toString(),
          title: records[i]['title'],
          amount: records[i]['amount'],
          category: records[i]['category'],
          date: DateTime.parse(records[i]['date']),
        );
      },
    );
  }

  Future<List<MyTransaction.Transaction>> getTransactionReport(
      DateTime fromDate, DateTime toDate, String category) async {
    final db = await database;
    String startDate = DateFormat('yyyy-MM-dd')
        .format(DateTime(fromDate.year, fromDate.month, 1));
    String endDate = DateFormat('yyyy-MM-dd')
        .format(DateTime(toDate.year, toDate.month + 1, 0));
    List<Map<String, dynamic>> res;
    if (category == 'All') {
      res = await db.rawQuery(
          "SELECT * FROM transactions WHERE DATE(date) <= ? AND DATE(date) >= ? ORDER BY date DESC",
          [endDate, startDate]);
    } else {
      res = await db.rawQuery(
          "SELECT * FROM transactions WHERE category=? AND DATE(date) <= ? AND DATE(date) >= ? ORDER BY date DESC",
          [category, endDate, startDate]);
    }
    return generateTransactionList(res);
  }
}
