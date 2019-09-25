import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whitelistku/database/kategoriDB.dart';
import 'package:whitelistku/database/whitelistDB.dart';
import 'package:whitelistku/function.dart';
import 'package:whitelistku/kategoriIconScreen.dart';
import 'package:whitelistku/values/bahasa.dart';

import 'package:whitelistku/component/Widget.dart';

class AddWhiteListScreen extends StatefulWidget {
  @override
  _AddWhiteListScreenState createState() => _AddWhiteListScreenState();
}

class _AddWhiteListScreenState extends State<AddWhiteListScreen> {
  TextEditingController _etNamaItem = TextEditingController();
  TextEditingController _etDeskripsi = TextEditingController();
  TextEditingController _etPrice = TextEditingController();

  final FocusNode _focusName = FocusNode();
  final FocusNode _focusDesc = FocusNode();
  final FocusNode _focusPrice = FocusNode();

  bool _autovalidateNama = false;
  bool _autovalidatePrice = false;

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem> _listKategori = [];
  int _valueKategori;

  DateTime _chooseDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(Bahasa.tambahWhitelist),
      ),
      floatingActionButton: customFlatActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(10.0),
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Image.asset(
                  "assets/images/insert_whitelist.webp",
                  width: MediaQuery.of(context).size.width - 200,
                  height: 200.0,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomTextField(
                        controller: _etNamaItem,
                        focusNode: _focusName,
                        textInputAction: TextInputAction.next,
                        autovalidate: _autovalidateNama,
                        label: Bahasa.namaItem,
                        validator: (val) {
                          if (val.trim().length < 1) {
                            _autovalidateNama = true;
                            return Bahasa.masihKosong;
                          }
                          _autovalidateNama = false;
                          return null;
                        },
                        onSubmitted: (val) {
                          MyFunction.focusSwitcher(
                              context, _focusName, _focusDesc);
                        },
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        height: 56,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: Colors.grey[200],
                          child: Text(DateFormat(DateFormat.YEAR_MONTH_DAY)
                              .format(_chooseDate)
                              .toString()),
                          onPressed: () async {
                            _chooseDate = await showDatePicker(
                                    context: context,
                                    initialDate: _chooseDate ?? DateTime.now(),
                                    lastDate: DateTime(2050),
                                    firstDate: DateTime(DateTime.now().year)) ??
                                _chooseDate;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                CustomTextField(
                  controller: _etDeskripsi,
                  focusNode: _focusDesc,
                  textInputAction: TextInputAction.newline,
                  label: Bahasa.deskripsi,
                  maxLines: null,
                  textInputType: TextInputType.multiline,
                ),
                SizedBox(
                  height: 10.0,
                ),
                CustomTextField(
                  controller: _etPrice,
                  focusNode: _focusPrice,
                  autovalidate: _autovalidatePrice,
                  label: Bahasa.harga,
                  textInputAction: TextInputAction.done,
                  validator: (val) {
                    if (val.length < 1) {
                      _autovalidatePrice = true;
                      return Bahasa.masihKosong;
                    }
                    if (int.tryParse(val) == null) {
                      _autovalidatePrice = true;
                      return Bahasa.hargaTidakValid;
                    }

                    _autovalidatePrice = false;
                    return null;
                  },
                  textInputType: TextInputType.number,
                  maxLines: 1,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        Bahasa.kategori,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      _listKategori.length > 0
                          ? DropdownButton(
                              isExpanded: true,
                              hint: Text(Bahasa.kategori),
                              iconEnabledColor: Colors.white,
                              items: _listKategori,
                              value:
                                  _valueKategori ?? _listKategori.first.value,
                              underline: Container(),
                              icon: Container(),
                              onChanged: (val) {
                                _valueKategori = val;
                                setState(() {});
                              },
                            )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 120.0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customFlatActionButton(BuildContext context) {
    return Hero(
      tag: Bahasa.tagPrimaryButton,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        child: RawMaterialButton(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            Bahasa.simpan,
            style: TextStyle(
                color: Theme.of(context).textTheme.button.color,
                fontSize: 18.0),
          ),
          fillColor: Theme.of(context).accentColor,
          onPressed: () async {
            Whitelist dbWhitelist = await Whitelist.initDatabase();
            int validPrice = int.tryParse(_etPrice.text);
            _formKey.currentState.validate();
            if (validPrice == null) {
              return;
            }
            WhitelistAttrb resp = await dbWhitelist.insertDataByValue(
                title: _etNamaItem.text.trim(),
                time: DateFormat(DateFormat.YEAR_MONTH_DAY)
                    .format(_chooseDate)
                    .toString(),
                description: _etDeskripsi.text.trim(),
                price: validPrice.toString(),
                idKategori: _valueKategori);
            Navigator.pop(context, resp);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusDesc.dispose();
    _focusName.dispose();
    _focusPrice.dispose();
  }

  void getKategori() async {
    Kategori dbKategori = await Kategori.initDatabase();
    List<KategoriAttrb> tempKategori = await dbKategori.getData();
    for (KategoriAttrb item in tempKategori) {
      _listKategori.add(DropdownMenuItem(
        child: Container(
          height: 200.0,
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(item.icon, color: Colors.white),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(item.title)
            ],
          ),
        ),
        value: item.id,
      ));
    }
    if (_listKategori.length == 0) {
      await MyFunction.showDialog(context,
          title: Bahasa.ops,
          msg: Bahasa.kategoriKosongMsgDetail,
          actions: [
            CupertinoButton(
              child: Text("Mengerti"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return KategoriIconsScreen();
                }));
              },
            )
          ]);
      return;
    }
    _valueKategori = _listKategori.first.value;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getKategori();
  }
}
