import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:needlecrew/bottomsheet/fix_size_guide_sheet.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class MysizeBottom extends StatefulWidget {
  const MysizeBottom({Key? key}) : super(key: key);

  @override
  State<MysizeBottom> createState() => _MysizeBottomState();
}

class _MysizeBottomState extends State<MysizeBottom> {
  void bottomsheetOpen(BuildContext context) {
    print("ispressed");
    showStickyFlexibleBottomSheet(
      minHeight: 0,
      initHeight: 0.9,
      maxHeight: 0.9,
      context: context,
      bottomSheetColor: HexColor("#fafafa").withOpacity(0.2),
      decoration: BoxDecoration(
        color: HexColor("#f7f7f7"),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(39)),
      ),
      headerHeight: 120,
      headerBuilder: (context, offset) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              alignment: Alignment.topCenter,
              color: Colors.transparent,
              height: 59,
              child: Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontStyle(
                      text: "치수 측정 가이드",
                      fontsize: "md",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  FontStyle(
                      text: "정확한 치수를 위해 바닥에 펴놓고 측정해주세요.",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                ],
              ),
            )
          ],
        );
      },
      bodyBuilder: (context, offset) {
        return SliverChildListDelegate([
          // Container()
          FixSizeQuideSheet(),
        ]);
      },
    );
  }

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
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                bottomsheetOpen(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/fixClothes/rollIcon.svg"),
                      FontStyle(
                          text: "치수 측정가이드 ",
                          fontsize: "md",
                          fontbold: "",
                          fontcolor: Colors.black,
                          textdirectionright: false),
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
            ),
            CircleBlackBtn(function: () => Get.back(), btnText: "수정 완료"),
          ],
        ),
      ),
    );
  }
}
