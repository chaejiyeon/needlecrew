import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/mainhome/price_info.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class MainHomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appbar;
  final Color color;

  const MainHomeAppbar({Key? key, required this.appbar, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      elevation: color == Colors.white ? 3 : 0,
      leadingWidth: 69,
      leading: Transform.translate(
        offset: Offset(24, 0),
        child: GestureDetector(
          onTap: () {
            Get.to(PriceInfo());
          },
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:   color == Colors.white
                    ? HexColor("#ededed").withOpacity(0.8) : HexColor("f7f7f7").withOpacity(0.25),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                    "가격표",
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          color == Colors.white ? Colors.black : Colors.white,
                    ),
                  ),

            ),
          ),
        ),
      ),
      actions: [
        AppbarItem(icon: "cartIcon.svg", iconColor:  color == Colors.white ? Colors.black : Colors.white, iconFilename: "main", widget:  CartInfo()),
        AppbarItem(icon: "alramIcon.svg", iconColor:  color == Colors.white ? Colors.black : Colors.white, iconFilename: "main", widget:  AlramInfo()),
      ],
    );
  }

  // appbarIcon
  Widget appbarItem(String icon, Widget getTo) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.to(getTo);
      },
      child: Container(
        padding: EdgeInsets.only(right: 24),
        child: SvgPicture.asset(
          "assets/icons/main/" + icon,
          color: color == Colors.white ? Colors.black : Colors.white,
          width: 23,
          height: 23,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}
