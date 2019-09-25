import 'package:flutter/material.dart';
import 'package:whitelistku/database/kategoriDB.dart';

class KategoriItem extends StatefulWidget {
  final KategoriAttrb kategoriAttrb;

  KategoriItem({Key key, this.kategoriAttrb}) : super(key: key);

  _KategoriItemState createState() => _KategoriItemState();
}

class _KategoriItemState extends State<KategoriItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.kategoriAttrb.title),
      subtitle: Text(widget.kategoriAttrb.description),
      leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Center(
              child: Icon(
            widget.kategoriAttrb.icon,
            color: Colors.white,
          ))),
      onTap: () {},
    );
  }
}
