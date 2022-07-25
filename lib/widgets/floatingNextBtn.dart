import 'package:needlecrew/screens/join/chooseGender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class FloatingNextBtn extends StatelessWidget {
  final Widget page;
  final bool ischecked;
  const FloatingNextBtn({Key? key, required this.page, required this.ischecked}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.zero,
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: (){
          if(ischecked == true){
            Get.to(page);
          }
        },
        child: SvgPicture.asset(
          'assets/icons/floatingNext.svg',
          color: ischecked == true ? HexColor("fd9a03") : HexColor("#d5d5d5"),
        ),
      ),
    );
  }
}
