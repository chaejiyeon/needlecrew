import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BaseAppbar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic prevFunction;
  final AppBar appbar;

  const BaseAppbar({Key? key, required this.prevFunction, required this.appbar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          prevFunction();
        },
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "assets/icons/prevIcon.svg",
            height: 20,
            width: 20,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light, statusBarColor: Colors.black),
      // brightness: Brightness.light,
      elevation: 0,
      // systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}
