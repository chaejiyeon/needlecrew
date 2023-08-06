import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:needlecrew/bottomsheet/fix_size_guide_sheet.dart';
import 'package:needlecrew/controller/widget_controller/custom_widget_controller.dart';
import 'package:needlecrew/custom_bottom_btn.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/functions.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class MysizeBottom extends StatefulWidget {
  const MysizeBottom({Key? key}) : super(key: key);

  @override
  State<MysizeBottom> createState() => _MysizeBottomState();
}

class _MysizeBottomState extends State<MysizeBottom> {
  @override
  Widget build(BuildContext context) {
    return CustomBottomBtn(
      formName: 'my_size',
      formHeight: 148.h,
      iconFt: () {
        CustomWidgetController widgetController = Get.find();

        if (widgetController.isAnimated.value) {
          Functions().showSizeGuideBottomSheet(context);
          widgetController.isAnimated.value = false;
        }
      },
      infoWidget: Container(
        height: 20.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/fixClothes/rollIcon.svg",
            ),
            CustomText(
              text: '치수 측정가이드',
              fontSize: FontSize().fs4,
              formMargin: EdgeInsets.only(left: 5),
            ),
          ],
        ),
      ),
      btnItems: [BtnModel(text: '수정 완료',textSize: FontSize().fs6, callback: () {})],
    );
  }
}
