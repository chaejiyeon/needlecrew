import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appbar;

  const BaseAppBar({Key? key, required this.appbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
          // Get.back();
        },
        icon: GestureDetector(child: SvgPicture.asset("assets/icons/prevIcon.svg", height: 19, width: 12,),),
      ),
      backgroundColor: Colors.transparent,
      brightness: Brightness.light,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}
