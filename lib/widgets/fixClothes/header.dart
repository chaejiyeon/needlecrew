import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/functions.dart';
import 'package:needlecrew/widgets/fixClothes/subtitle_text.dart';
import 'package:needlecrew/widgets/font_style.dart';
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
              question == true && btnText != ''
                  ? GestureDetector(
                      onTap: () {
                        btnText == "치수 측정 가이드"
                            ? Functions().showSizeGuideBottomSheet(context)
                            : Get.to(widget);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 14, top: 7, right: 14, bottom: 7),
                        decoration: BoxDecoration(
                            color: HexColor("#f7f7f7"),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: HexColor("#f2f2f2"), width: 1)),
                        child: Text(btnText),
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
