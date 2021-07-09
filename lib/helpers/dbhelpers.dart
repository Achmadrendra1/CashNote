import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uas_rendra/models/cashnote.dart';

class DbHelpers {
  Database database;

  Future initDB() async {
    if (database != null) {
      return database;
    }

    String databasesPath = await getDatabasesPath();

    database = await openDatabase(
      join(databasesPath, 'cashnote.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE cashnote(id INTEGER PRIMARY KEY, tanggal TEXT, deskripsi TEXT, tipe TEXT, jumlah INTEGER)",
        );
      },
      version: 1,
    );

    return database;
  }

  void insertTrans(Cashnote note) async {
    final Database db = database;

    db.insert(
      'cashnote',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Cashnote>> trans() async {
    final Database db = database;

    final List<Map<String, dynamic>> maps =
        await db.query('cashnote', orderBy: 'tanggal');

    return List.generate(maps.length, (i) {
      return Cashnote(
        id: maps[i]['id'],
        tanggalNote: maps[i]['tanggal'],
        deskripsiNote: maps[i]['deskripsi'],
        tipeNote: maps[i]['tipe'],
        jumlahTrx: maps[i]['jumlah'],
      );
    });
  }

  Future<int> countTotal() async {
    final Database db = database;
    final int sumEarning = Sqflite.firstIntValue(await db
        .rawQuery('SELECT SUM(jumlah) FROM cashnote WHERE tipe = "earning"'));
    final int sumExpense = Sqflite.firstIntValue(await db
        .rawQuery('SELECT SUM(jumlah) FROM cashnote WHERE tipe = "expense"'));
    return ((sumEarning == null ? 0 : sumEarning) -
        (sumExpense == null ? 0 : sumExpense));
  }

  Future<int> countMasuk() async {
    final Database db = database;
    final int sumMasuk = Sqflite.firstIntValue(await db
        .rawQuery('SELECT SUM(jumlah) FROM cashnote WHERE tipe = "earning"'));
    return sumMasuk == null ? 0 : sumMasuk;
  }

  Future<int> countKeluar() async {
    final Database db = database;
    final int sumKeluar = Sqflite.firstIntValue(await db
        .rawQuery('SELECT SUM(jumlah) FROM cashnote WHERE tipe = "expense"'));
    return sumKeluar == null ? 0 : sumKeluar;
  }

  Future<void> updateTrans(Cashnote note) async {
    final db = database;

    await db.update(
      'cashnote',
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  Future<void> deleteTrans(int id) async {
    final db = database;

    await db.delete(
      'cashnote',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
