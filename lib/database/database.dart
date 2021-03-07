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
          )''');
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
      DateFormat('YYYY-MM-DD').format(transaction.date)
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
}
