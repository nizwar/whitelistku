import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whitelistku/component/KategoriItem.dart';
import 'package:whitelistku/database/kategoriDB.dart';
import 'package:whitelistku/kategoriIconScreen.dart';
import 'package:whitelistku/values/bahasa.dart';

import 'function.dart';

class KategoriScreen extends StatefulWidget {
  @override
  _KategoriScreenState createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  List<KategoriAttrb> _listKategori = [];
  Kategori dbKategori;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(Bahasa.daftarKategori),
      ),
      body: RefreshIndicator(
        onRefresh: () => getKategoriList(),
        child: _listKategori.length == 0
            ? ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                children: <Widget>[
                  Image.asset(
                    "assets/images/insert_kategori.webp",
                    height: 200.0,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    Bahasa.pesanKategoriKosong,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Dismissible(
                      onDismissed: (direction) => hapusItem(index),
                      secondaryBackground: MyFunction.bgHapus(),
                      confirmDismiss: (direction) async {
                        return await dialogHapus();
                      },
                      background: Container(),
                      direction: DismissDirection.endToStart,
                      child: KategoriItem(
                        kategoriAttrb: _listKategori[index],
                      ),
                      key: Key(_listKategori[index].id.toString()),
                    );
                  },
                  itemCount: _listKategori.length,
                )),
      ),
      floatingActionButton: Hero(
        tag: Bahasa.tagPrimaryButton,
        child: SizedBox(
          height: 60.0,
          width: 60.0,
          child: RawMaterialButton(
            shape: CircleBorder(),
            elevation: 10.0,
            fillColor: Theme.of(context).accentColor,
            child: Center(
                child: Icon(
              Icons.add,
              color: Theme.of(context).textTheme.button.color,
            )),
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return KategoriIconsScreen();
              }));
              getKategoriList();
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getKategoriList();
    Kategori.initDatabase().then((db) {
      dbKategori = db;
    });
  }

  Future<bool> dialogHapus() async {
    return await MyFunction.showDialog(context,
        title: Bahasa.konfirmasiHapusTitle,
        msg: Bahasa.konfirmasiHapusDetail,
        actions: [
          CupertinoButton(
            child: Text(
              Bahasa.hapus,
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          CupertinoButton(
            child: Text(Bahasa.batalkan),
            onPressed: () {
              Navigator.pop(context, false);
            },
          )
        ]);
  }

  Future<void> getKategoriList() async {
    if (dbKategori == null) dbKategori = await Kategori.initDatabase();
    _listKategori = await dbKategori.getData();
    setState(() {});
  }

  Future<void> hapusItem(index) async {
    if (dbKategori == null) dbKategori = await Kategori.initDatabase();
    await dbKategori.deleteData(_listKategori[index].id);
    _listKategori.removeAt(index);
    setState(() {});
  }
}
