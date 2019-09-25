import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whitelistku/database/kategoriDB.dart';
import 'package:whitelistku/database/whitelistDB.dart';

class WhitelistItem extends StatefulWidget {
  final Function onTap;
  final WhitelistAttrb whitelistAttrb;

  const WhitelistItem({Key key, this.onTap, this.whitelistAttrb})
      : super(key: key);

  @override
  _WhitelistItemState createState() => _WhitelistItemState();
}

class _WhitelistItemState extends State<WhitelistItem> {
  IconData iconData;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: iconData != null
            ? Icon(
                iconData,
                color: widget.whitelistAttrb.status == 0
                    ? Colors.white
                    : Theme.of(context).accentColor,
              )
            : Icon(
                Icons.warning,
                color: Colors.grey[400],
              ),
      ),
      onTap: widget.onTap,
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            "Biaya",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12.0),
          ),
          Text(
            "Rp" +
                NumberFormat("#,###")
                    .format(double.parse(widget.whitelistAttrb.price))
                    .replaceAll(",", "."),
            style: TextStyle(fontSize: 18.0),
          )
        ],
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(widget.whitelistAttrb.title),
          SizedBox(
            width: 3,
          ),
          Text(
            DateFormat(DateFormat.YEAR_MONTH_DAY)
                .format(widget.whitelistAttrb.time),
            style: TextStyle(
                color: widget.whitelistAttrb.status == 1
                    ? Colors.green
                    : !DateTime.now().isAfter(widget.whitelistAttrb.time)
                        ? Colors.grey[600]
                        : Colors.red,
                fontSize: 10.0),
          ),
        ],
      ),
      subtitle: widget.whitelistAttrb.description != null
          ? Text(
              widget.whitelistAttrb.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )
          : null,
    );
  }

  @override
  void initState() {
    super.initState();
    initIconData();
  }

  void initIconData() async {
    Kategori kategori = await Kategori.initDatabase();
    KategoriAttrb kategoriAttrb =
        await kategori.getById(widget.whitelistAttrb.idKategori);
    iconData = kategoriAttrb != null
        ? kategoriAttrb.icon ?? Icons.warning
        : Icons.warning;
    if (mounted) setState(() {});
  }
}
