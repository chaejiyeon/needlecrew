import 'package:needlecrew/screens/main/alramInfo.dart';
import 'package:needlecrew/screens/main/cartInfo.dart';
import 'package:needlecrew/screens/main/mainhome/priceInfo.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class MainHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appbar;
  final Color color;

  const MainHomeAppBar({Key? key, required this.appbar, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      elevation: color == Colors.white ? 3 : 0,
      leadingWidth: 120,
      leading: GestureDetector(
        onTap: (){Get.to(PriceInfo());},
        child: Container(
          padding: EdgeInsets.only(left: 24),
          child: Row(
            children: [
               SvgPicture.asset("assets/icons/main/priceinfoIcon.svg",
                      fit: BoxFit.cover, color : color == Colors.white ? Colors.black : Colors.white),
              SizedBox(width: 10,),
              FontStyle(
                  text: "가격표",
                  fontsize: "md",
                  fontbold: "",
                  fontcolor: color == Colors.white ? Colors.black : Colors.white,
                  textdirectionright: false),
            ],
          ),
        ),
      ),
      // titleSpacing: 0,
      // title:
      actions: [
        appbarItem("cartIcon.svg", CartInfo()),
        appbarItem("alramIcon.svg", AlramInfo()),
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
