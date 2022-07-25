import 'package:needlecrew/bottomsheet/fixSizeGuideSheet.dart';
import 'package:needlecrew/widgets/fixClothes/subtitle.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class Header extends StatelessWidget {
  final String title;
  final String subtitle1;

  // final String subtitle2;
  final bool question;
  final String btnIcon;
  final String btnText;
  final Widget widget;
  final String imgPath;
  final double bottomPadding;

  const Header(
      {Key? key,
      required this.title,
      required this.subtitle1,
      // required this.subtitle2,
      required this.question,
      required this.btnIcon,
      required this.btnText,
      required this.widget,
      required this.imgPath,
      required this.bottomPadding})
      : super(key: key);

  void bottomsheetOpen(BuildContext context) {
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
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FontStyle(
                  text: title,
                  fontsize: "lg",
                  fontbold: "bold",
                  fontcolor: Colors.black,
                  textdirectionright: false),
              question == true
                  ? GestureDetector(
                      onTap: () {
                        btnText == "치수 측정 가이드"
                            ? bottomsheetOpen(context)
                            : Get.to(widget);
                      },
                      child: Row(
                        children: [
                          imgPath != ""
                              ? SvgPicture.asset(
                                  "assets/icons/" + imgPath + "/" + btnIcon,
                                  color: Colors.black,
                                )
                              : SvgPicture.asset(
                                  "assets/icons/" + btnIcon,
                                  color: Colors.black,
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(btnText),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          subtitle1 != "" ? SubtitleText(text: subtitle1) : Container(),
        ],
      ),
    );
  }
}
