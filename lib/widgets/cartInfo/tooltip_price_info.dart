import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/tootip_custom.dart';
import 'package:needlecrew/widgets/font_style.dart';

class TooltipPriceInfo extends StatelessWidget {
  final String title;
  final String price;
  final String tooltipText;
  final List targetText;
  final bool infoIcon;

  const TooltipPriceInfo({Key? key, required this.title, required this.price, required this.tooltipText, required this.targetText, required this.infoIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 7, bottom: 7, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TooltipCustom(
              tooltipText: tooltipText,
              boldText: targetText,
              titleText: title,
              tailPosition: "up"),
          Row(
            children: [
              FontStyle(
                  text: price,
                  fontsize: "",
                  fontbold: "bold",
                  fontcolor: Colors.black,
                  textdirectionright: false),
              FontStyle(
                  text: "원",
                  fontsize: "",
                  fontbold: "",
                  fontcolor: Colors.black,
                  textdirectionright: false),
            ],
          ),
        ],
      ),
    );
  }
}
