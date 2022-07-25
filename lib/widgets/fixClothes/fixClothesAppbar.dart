import 'package:needlecrew/screens/main/alramInfo.dart';
import 'package:needlecrew/screens/main/cartInfo.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/screens/mainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FixClothesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appbar;

  const FixClothesAppBar({Key? key, required this.appbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          CupertinoIcons.chevron_back,
          color: Colors.black,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      actions: [
        Container(
            width: 23,
            height: 23,
            margin: EdgeInsets.only(right: 26),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.to(MainPage(pageNum: 0));
              },
              child: SvgPicture.asset(
                "assets/icons/main/homeIcon.svg",
                color: Colors.black,
              ),
            )),
        Container(
            width: 23,
            height: 23,
            margin: EdgeInsets.only(right: 26),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.to(CartInfo());
              },
              child: SvgPicture.asset(
                "assets/icons/main/cartIcon.svg",
                color: Colors.black,
              ),
            )),
        Container(
            width: 23,
            height: 23,
            margin: EdgeInsets.only(right: 26),
            // padding: EdgeInsets.only(left: 10, right: 20),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.to(AlramInfo());
              },
              child: SvgPicture.asset(
                "assets/icons/main/alramIcon.svg",
                color: Colors.black,
              ),
            )),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}
