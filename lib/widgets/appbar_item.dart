import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppbarItem extends StatefulWidget {
  final String icon;
  final Color iconColor;
  final String iconFilename; // icon이 저장된 파일 이름
  final Widget? widget;
  final dynamic function;

  const AppbarItem(
      {Key? key,
      required this.icon,
      required this.iconColor,
      required this.iconFilename,
      this.widget,
      this.function})
      : super(key: key);

  @override
  State<AppbarItem> createState() => _AppbarItemState();
}

class _AppbarItemState extends State<AppbarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.widget != null) {
          Get.to(widget.widget);
        }
        if (widget.function != null) {
          widget.function();
        }
      },
      child: Container(
        width: 23,
        height: 23,
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 12, right: 12),
        child: SvgPicture.asset(
          widget.iconFilename == ""
              ? "assets/icons/" + widget.icon
              : "assets/icons/" + widget.iconFilename + "/" + widget.icon,
          color: widget.iconColor,
        ),
      ),
    );
  }
}
