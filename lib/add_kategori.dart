import 'package:flutter/material.dart';
import 'package:whitelistku/component/Widget.dart';
import 'package:whitelistku/database/kategoriDB.dart';
import 'package:whitelistku/values/bahasa.dart';
import 'package:whitelistku/values/listIcon.dart';

import 'function.dart';

class AddKategoriScreen extends StatefulWidget {
  final IconAttrb iconAttrb;

  const AddKategoriScreen({Key key, this.iconAttrb}) : super(key: key);
  @override
  _AddKategoriScreenState createState() => _AddKategoriScreenState();
}

class _AddKategoriScreenState extends State<AddKategoriScreen> {
  TextEditingController _etKategori = TextEditingController();
  TextEditingController _etDeskripsi = TextEditingController();

  final FocusNode _focusKategori = FocusNode();
  final FocusNode _focusDesc = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(Bahasa.tambahKategori),
      ),
      floatingActionButton: customFlatActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.all(30.0),
                height: 80.0,
                width: 80.0,
                child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      widget.iconAttrb.icon,
                      size: 80,
                      color: Colors.white,
                    )),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    label: Bahasa.kategori,
                    focusNode: _focusKategori,
                    controller: _etKategori,
                    validator: (str) {
                      if (str == null || str.trim() == "") {
                        return Bahasa.masihKosong;
                      }

                      return null;
                    },
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (val) {
                      MyFunction.focusSwitcher(
                          context, _focusKategori, _focusDesc);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    label: Bahasa.deskripsi,
                    focusNode: _focusDesc,
                    textInputAction: TextInputAction.newline,
                    controller: _etDeskripsi,
                    maxLines: null,
                    textInputType: TextInputType.multiline,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customFlatActionButton(BuildContext context) {
    return Hero(
      tag: Bahasa.tagPrimaryButton,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        child: RawMaterialButton(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            Bahasa.simpan,
            style: TextStyle(
                color: Theme.of(context).textTheme.button.color,
                fontSize: 18.0),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5.0,
          fillColor: Theme.of(context).accentColor,
          onPressed: () async {
            Kategori dbKategori = await Kategori.initDatabase();
            await dbKategori.insertDataByValue(
              title: _etKategori.text.trim(),
              description: _etDeskripsi.text.trim(),
              iconType: widget.iconAttrb.iconType,
              iconValue: widget.iconAttrb.iconValue,
            );
            Navigator.pop(context, true);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusDesc.dispose();
    _focusKategori.dispose();
  }
}
