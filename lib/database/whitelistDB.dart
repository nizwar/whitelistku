import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:whitelistku/database/db_function.dart';

class Whitelist {
  final Database _database;
  static final String tblName = "tbl_whitelist";

  DBFunction _dbFunction;

  Whitelist(this._database) {
    _dbFunction = DBFunction(_database, Whitelist.tblName);
  }

  static Future<Whitelist> initDatabase() async {
    return Whitelist(await DBFunction.getDatabase());
  }

  Future<WhitelistAttrb> getById(int id) async {
    return WhitelistAttrb(
        await _dbFunction.getData(where: "id = ?", whereArg: [id]));
  }

  Future<List<WhitelistAttrb>> getData() async {
    List<dynamic> temp = await _dbFunction.getData();
    List<WhitelistAttrb> output = [];
    for (Map<String, dynamic> item in temp) {
      output.add(WhitelistAttrb(item));
    }
    return output;
  }

  Future<void> insertData(WhitelistAttrb data) async {
    await _dbFunction.insertData(data.toMap());
  }

  Future<void> updateData(id, Map<String, String> data) async {
    await _dbFunction.updateData(id, data);
  }
 

  Future<WhitelistAttrb> insertDataByValue(
      {String title,
      String description,
      String price,
      int idKategori,
      String time}) async {
    Map<String, String> data = {
      "id_kategori": idKategori.toString(),
      "title": title,
      "description": description,
      "time": time,
      "price": price,
      "status": "0"
    };
    int id = await _dbFunction.insertData(data);
    data["id"] = id.toString();
    return WhitelistAttrb(data);
  }

  Future<void> deleteData(dynamic id) async {
    await _dbFunction.deleteData(id);
  }
}

class WhitelistAttrb {
  final Map<String, dynamic> _data;

  WhitelistAttrb(this._data);

  dynamic get id => _data["id"];
  dynamic get idKategori => _data["id_kategori"];
  String get title => _data["title"];
  String get description => _data["description"];
  String get price => _data["price"];
  DateTime get time =>
      DateFormat(DateFormat.YEAR_MONTH_DAY).parse(_data["time"]);
  dynamic get status => int.parse(_data["status"]);

  Map<String, dynamic> toMap() {
    return {
      "id_kategori": idKategori,
      "title": title,
      "description": description,
      "price": price,
      "time": time,
      "status": status
    };
  }

  String toString() {
    return toMap().toString();
  }
}
