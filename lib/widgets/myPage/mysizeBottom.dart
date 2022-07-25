import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class MysizeBottom extends StatefulWidget {
  const MysizeBottom({Key? key}) : super(key: key);

  @override
  State<MysizeBottom> createState() => _MysizeBottomState();
}

class _MysizeBottomState extends State<MysizeBottom> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: HexColor("#d5d5d5").withOpacity(0.1),
              spreadRadius: 10,
              blurRadius: 5,
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: SvgPicture.asset(
                          "assets/icons/fixClothes/rollIcon.svg"),
                    ),
                    FontStyle(
                        text: "치수 측정가이드 ",
                        fontsize: "md",
                        fontbold: "",
                        fontcolor: Colors.black,textdirectionright: false),
                  ],
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.chevron_up,
                      color: HexColor("#909090"),
                    )),
              ],
            ),

            CircleBlackBtn(btnText: "수정 완료", pageName: "back"),
          ],
        ),
      ),
    );
  }
}
