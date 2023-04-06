import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:hexcolor/hexcolor.dart';

class TableListItem extends StatefulWidget {
  final String type;
  final String fixInfo;
  final String price;

  const TableListItem({Key? key,
    required this.type,
    required this.fixInfo,
    required this.price,
  }) : super(key: key);

  @override
  State<TableListItem> createState() => _TableListItemState();
}

class _TableListItemState extends State<TableListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FontStyle(
                  text: widget.type,
                  fontsize: "",
                  fontbold: "",
                  fontcolor: Colors.black,textdirectionright: false),
              FontStyle(
                  text: widget.fixInfo,
                  fontsize: "",
                  fontbold: "",
                  fontcolor: Colors.black,textdirectionright: false),
              FontStyle(
                  text: "₩" + widget.price,
                  fontsize: "",
                  fontbold: "",
                  fontcolor: Colors.black,textdirectionright: false),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListLine(
              height: 2,
              width: double.infinity,
              lineColor: HexColor("#d5d5d5"),
              opacity: 0.5),
        ],
      ),
    );
  }
}
