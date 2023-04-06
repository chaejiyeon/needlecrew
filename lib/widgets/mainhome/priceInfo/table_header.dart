import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/font_style.dart';

class TableHeader extends StatelessWidget {
  final String text;
  final Color borderColor;
  final double width;

  const TableHeader({Key? key,
    required this.text,
    required this.borderColor,
    required this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: borderColor,
              width: 2,
            ),
          ),
        ),
        child: FontStyle(
            text: text,
            fontsize: "",
            fontbold: "bold",
            fontcolor: Colors.black,textdirectionright: false),
      ),
    );
  }
}
