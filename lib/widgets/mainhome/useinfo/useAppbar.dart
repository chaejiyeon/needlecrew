import 'package:needlecrew/screens/main/alramInfo.dart';
import 'package:needlecrew/screens/main/cartInfo.dart';
import 'package:needlecrew/widgets/appbarItem.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class UseAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final String appbarcolor;
  final AppBar appbar;
  
  const UseAppBar({Key? key, required this.title, required this.appbarcolor, required this.appbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      AppBar(
        backgroundColor: appbarcolor == "white" ? Colors.white : Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            title == "나의 이용내역" ?  Get.offAndToNamed("/mainHome") : Get.back() ;
          },
          icon: SvgPicture.asset("assets/icons/prevIcon.svg", color: appbarcolor == "white" ? Colors.black : Colors.white, width: 11, height: 19, ),
        ),
        centerTitle: true,
        title: FontStyle(text: title, fontsize: "md", fontcolor: appbarcolor == "white" ? Colors.black : Colors.white, fontbold: "bold", textdirectionright: false),
        actions: [
          AppbarItem(
            icon: "cartIcon.svg",
            iconColor:  appbarcolor == "white" ? Colors.black : Colors.white,
            iconFilename: "main",
            widget: CartInfo(),
          ),
          AppbarItem(
            icon: "alramIcon.svg",
            iconColor:  appbarcolor == "white" ? Colors.black : Colors.white,
            iconFilename: "main",
            widget: AlramInfo(),
          ),
        ],
      );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}


