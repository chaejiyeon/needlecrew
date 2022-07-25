import 'package:needlecrew/widgets/appbarItem.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MypageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appbar;
  final String title;
  final String icon;
  final Widget widget;

  const MypageAppBar({Key? key, required this.title, required this.icon, required this.widget, required this.appbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading:  IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
            size: 20,
          )),
      centerTitle: true,
      title: FontStyle(
          text: title,
          fontsize: "md",
          fontbold: "bold",
          fontcolor: Colors.black,textdirectionright: false),
      actions: [
        icon != "" ? AppbarItem(
          icon: icon,
          iconColor: Colors.black,
          iconFilename: "",
          widget: widget,
        ) : Container(padding: EdgeInsets.only(right: 40),),
      ],
    );
  }


  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}
