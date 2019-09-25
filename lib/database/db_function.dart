import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:whitelistku/database/kategoriDB.dart';
import 'package:whitelistku/database/whitelistDB.dart';

class DBFunction {
  final Database _database;
  final String _tblName;

  DBFunction(this._database, this._tblName);

  Future<int> insertData(Map<String, String> data) async {
    return await _database.insert(_tblName, data);
  }

  Future<int> deleteData(dynamic id) async {
    return await _database.delete(_tblName, where: "id = ?", whereArgs: [id]);
  }

  Future<dynamic> getData({String where, List<dynamic> whereArg}) async {
    return await _database.query(_tblName,
        where: where ?? null, whereArgs: whereArg ?? []);
  }

  Future<int> updateData(dynamic id, Map<String, String> data) async {
    return await _database
        .update(_tblName, data, where: "id = ?", whereArgs: [id]);
  }

  static Future<Database> getDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), "db_whitelist"),
        onCreate: (db, version) async {
      String whiteListTable = Whitelist.tblName;
      String kategoriTable = Kategori.tblName;
      await db.execute("""
          CREATE TABLE $kategoriTable(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL, 
              description TEXT NOT NULL, 
              iconType CHAR(1) NOT NULL DEFAULT '0', 
              iconVal TEXT NOT NULL)
          """);

      await db.execute("""
          CREATE TABLE $whiteListTable(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              id_kategori INTEGER NOT NULL, 
              title TEXT NOT NULL, 
              description TEXT NOT NULL, 
              price TEXT NOT NULL, 
              time TEXT NOT NULL, 
              status CHAR(1) NOT NULL DEFAULT '0', 
              FOREIGN KEY(id_kategori) REFERENCES tbl_kategori(id) ON DELETE CASCADE ON UPDATE CASCADE
              )
              """);
              
      await db.insert(kategoriTable, {
        "title": "Makanan",
        "description": "Makanan yang diinginkan",
        "iconType": "1",
        "iconVal": "md-pizza"
      });

      await db.insert(kategoriTable, {
        "title": "Kendaraan",
        "description": "Kendaraan yang diinginkan",
        "iconType": "3",
        "iconVal": "car"
      });

      await db.insert(kategoriTable, {
        "title": "Rumah",
        "description": "Tempat tinggal idaman",
        "iconType": "3",
        "iconVal": "home"
      });

      return db.insert(kategoriTable, {
        "title": "Traveling",
        "description": "Jalan-Jalan kesuatu tempat",
        "iconType": "3",
        "iconVal": "subway"
      });
    }, version: 1);
  }
}
