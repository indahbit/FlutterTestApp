import 'package:sqflite/sqflite.dart';
import 'dart:async';
//mendukug pemrograman asinkron
import 'dart:io';
//bekerja pada file dan directory
import 'package:path_provider/path_provider.dart';
import 'package:aplikasi_gudang/models/jenisdatabase.dart';
//pubspec.yml

//kelass Dbhelper
class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;  

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {

  //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/jenisdb.db';

   //create, read databases
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

    //buat tabel baru dengan nama contact
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jenisdb (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        JenisGudang TEXT,
        NamaGudang TEXT,
        ServerGudang TEXT,
        DatabaseGudang TEXT,
        ApiGudang TEXT
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('jenisdb', orderBy: 'NamaGudang');
    // print(mapList);
    return mapList;
  }

Future<int> dropDb() async {
  Database db = await this.database;
   await db.execute('DROP TABLE jenisdb');
    return 1;
}

//create databases
  Future<int> insert(JenisDatabase object) async {
    Database db = await this.database;
    int count = await db.insert('jenisdb', object.toMap());
    return count;
  }
//update databases
  Future<int> update(int id, JenisDatabase object) async {
    // print(object.toMap());
    Database db = await this.database;
    int count = await db.update('jenisdb', object.toMap(), 
                                where: 'id=?',
                                whereArgs: [id]);
                                print(count);
    return count;
  }

//delete databases
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('jenisdb', 
                                where: 'id=?', 
                                whereArgs: [id]);
    return count;
  }

  Future<List<JenisDatabase>> getJenisdbList() async {
    var jenisdbMapList = await select();
    int count = jenisdbMapList.length;
    List<JenisDatabase> jenisdbList = List<JenisDatabase>();
    for (int i=0; i<count; i++) {
      jenisdbList.add(JenisDatabase.fromMap(jenisdbMapList[i]));
    }
    return jenisdbList;
  }

}