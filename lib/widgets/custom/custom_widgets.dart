import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BackBtn extends StatelessWidget {
  final Color iconColor;
  final dynamic backFt;

  const BackBtn({Key? key, this.iconColor = Colors.black, this.backFt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (backFt != null) {
          backFt();
        } else {
          Get.back();
        }
      },
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          color: iconColor,
          "assets/icons/prevIcon.svg",
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}
