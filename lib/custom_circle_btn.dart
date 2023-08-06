import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:needlecrew/custom_text.dart';

class CustomCircleBtn extends StatelessWidget {
  final EdgeInsets? btnMargin;
  final double? btnWidth;
  final double btnHeight;
  final Color? btnColor;
  final Color? borderColor;
  final FontWeight? btnWeight;
  final dynamic btnFt;

  //
  final String btnText;
  final double? btnTextSize;
  final Color? btnTextColor;

  //
  final String? btnIcon;

  const CustomCircleBtn(
      {Key? key,
      this.btnMargin,
      this.btnWidth,
      this.btnHeight = 54,
      this.btnColor,
      this.borderColor,
      this.btnFt,
      required this.btnText,
      this.btnTextSize,
      this.btnTextColor,
      this.btnWeight,
      this.btnIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (btnFt != null) {
          btnFt();
        }
      },
      child: Container(
        margin: btnMargin,
        width: btnWidth,
        height: btnHeight.h,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            width: 1,
            color: borderColor ?? Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: btnText,
              fontSize: btnTextSize ?? 16,
              fontColor: btnTextColor ?? Colors.white,
              fontWeight: btnWeight,
            ),
            btnIcon != null
                ? Container(
                    margin: EdgeInsets.only(left: 7),
                    child: SvgPicture.asset(
                      "assets/icons/" + btnIcon!,
                      color: Colors.white,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
