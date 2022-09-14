import 'dart:ffi';

import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/getxController/fixClothes/fixselectController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../getxController/fixClothes/cartController.dart';

class CircleLineBtn extends StatefulWidget {
  final String btnText;
  final double fontboxwidth;
  final String fontsize; // md(15) = 큰 버튼
  final Color fontcolor;
  final Color bordercolor;
  final String btnIcon;
  final Color btnColor;
  final Widget widgetName;
  final bool iswidget;
  final String fontboxheight;

  const CircleLineBtn(
      {Key? key,
      required this.btnText,
      required this.fontboxwidth,
      required this.fontboxheight,
      required this.bordercolor,
      required this.fontcolor,
      required this.fontsize,
      required this.btnIcon,
      required this.btnColor,
      required this.widgetName,
      required this.iswidget})
      : super(key: key);

  @override
  State<CircleLineBtn> createState() => _CircleLineBtnState();
}

class _CircleLineBtnState extends State<CircleLineBtn> {
  final FixSelectController controller = Get.put(FixSelectController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: widget.fontboxwidth,
      height: widget.fontboxheight == "sm" ? 30 : 54,
      decoration: BoxDecoration(
        color: widget.btnColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 1,
          color: widget.bordercolor,
        ),
      ),
      child: TextButton(
        onPressed: () {

          if(widget.btnColor == HexColor("#d5d5d5")) null;
          else {
            widget.iswidget == true && widget.btnText == "수선하기"
                ? Get.to(widget.widgetName)
                : widget.iswidget == true
                    ? {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => widget.widgetName)),
                        controller.backClick.value = false
                      }
                    : widget.iswidget == false
                        ? Get.dialog(widget.widgetName)
                        : controller.isshopping == false
                            ? null
                            : Get.dialog(widget.widgetName);
          }
          // 쇼핑몰에서 보낼 경우 수선 선택의 잘 맞는 옷을 함께 보낼께요 /  표시 안함
          if (widget.btnText == "쇼핑몰에서 보낼래요")
            controller.isShopping(true);
          else if (widget.btnText == "우리집에서 보내요") controller.isShopping(false);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.btnText,
              style: TextStyle(
                fontSize: widget.fontsize == "md" ? 16 : widget.fontsize == "sm" ? 11 : null,
                color: widget.fontcolor,
              ),
              textAlign: TextAlign.center,

            ),
            if (widget.btnIcon != "")
              SizedBox(
                width: 7,
              ),
            if (widget.btnIcon != "")
              SvgPicture.asset(
                "assets/icons/" + widget.btnIcon,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
