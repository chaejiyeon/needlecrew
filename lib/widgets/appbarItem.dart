import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppbarItem extends StatefulWidget {
  final String icon;
  final Color iconColor;
  final String iconFilename; // icon이 저장된 파일 이름
  final Widget widget;

  const AppbarItem({Key? key, required this.icon, required this.iconColor, required this.iconFilename, required this.widget}) : super(key: key);

  @override
  State<AppbarItem> createState() => _AppbarItemState();
}

class _AppbarItemState extends State<AppbarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(widget.widget);
        },
        child: Container(
          width: 23,
          height: 23,
          margin: EdgeInsets.only(right: 20),
          // padding: EdgeInsets.only(right: 20),
          child: SvgPicture.asset(
            widget.iconFilename == "" ? "assets/icons/" + widget.icon : "assets/icons/" + widget.iconFilename + "/" + widget.icon,
            color: widget.iconColor,
          ),
        ),
      );
  }
}
