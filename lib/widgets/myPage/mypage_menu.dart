import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/main.dart';
import 'package:needlecrew/screens/login/loading_page.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class MypageMenu extends StatelessWidget {
  final String listTitle;
  final Widget widget;

  const MypageMenu({Key? key, required this.listTitle, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (listTitle == "로그아웃") {
          Get.dialog(widget);
        } else {
          Get.to(widget);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 15.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      listTitle,
                    )),
                SvgPicture.asset(
                  "assets/icons/nextIcon.svg",
                  color: HexColor("#909090"),
                  width: 7,
                  height: 11,
                ),
              ],
            ),
            SizedBox(
              height: 14,
            ),
            listTitle != "로그아웃" && listTitle != "회원 탈퇴"
                ? ListLine(
                    height: 1,
                    width: double.infinity,
                    lineColor: HexColor("#ededed"),
                    opacity: 1.0)
                : Container(),
          ],
        ),
      ),
    );
  }
}
