import 'package:needlecrew/screens/join/choose_gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class FloatingNextBtn extends StatelessWidget {
  final EdgeInsets margin;
  final dynamic function;
  final bool ischecked;

  const FloatingNextBtn(
      {Key? key,
      this.margin = EdgeInsets.zero,
      required this.function,
      required this.ischecked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.zero,
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () {
          if (ischecked == true) {
            function();
          }
        },
        child: ischecked == true
            ? Image.asset(
                "assets/icons/selectFloatingIcon.png",
                width: 54,
                height: 54,
              )
            : SvgPicture.asset(
                'assets/icons/floatingNext.svg',
                color: HexColor("#d5d5d5"),
              ),
      ),
    );
  }
}