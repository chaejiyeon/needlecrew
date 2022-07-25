import 'package:flutter/material.dart';

class ListLine extends StatelessWidget {
  final double height;
  final double width;
  final Color lineColor;
  final double opacity;

  const ListLine(
      {Key? key,
      required this.height,
      required this.width,
      required this.lineColor,
      required this.opacity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 5),
      height: height,
      width: width,
      decoration: BoxDecoration(color: lineColor.withOpacity(opacity)),
    );
  }
}
