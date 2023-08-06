import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:needlecrew/custom_circle_btn.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/screens/main/fixClothes/address_info.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_question.dart';
import 'package:needlecrew/screens/main/update_screens/select_fix_clothes/select_clothes_type.dart';
import 'package:needlecrew/widgets/fixClothes/header.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class StartAddressChoose extends StatefulWidget {
  const StartAddressChoose({Key? key}) : super(key: key);

  @override
  State<StartAddressChoose> createState() => _StartAddressState();
}

class _StartAddressState extends State<StartAddressChoose> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // progress bar
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/fixClothes/scissorsIcon.svg"),
                Expanded(
                  child: Container(
                    child: ListLine(
                        height: 2,
                        width: double.infinity,
                        lineColor: HexColor("#909090"),
                        opacity: 0.5),
                  ),
                ),
              ],
            ),
          ),

          Header(
            title: "출발지 선택",
            subtitle1: "고객님의 의류의 출발지를\n선택해주세요.",
            question: true,
            btnIcon: "chatIcon.svg",
            btnText: "수선 문의하기",
            widget: FixQuestion(),
            imgPath: "fixClothes",
            bottomPadding: 50.h,
          ),

          // choose button
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                CustomCircleBtn(
                  btnMargin: EdgeInsets.only(bottom: 10.h),
                  btnText: '쇼핑몰에서 보낼래요',
                  btnTextColor: Colors.black,
                  borderColor: SetColor().colorD5,
                  btnFt: () {
                    Get.close(1);
                    Get.to(AddressInfo(isHome: false));
                  },
                ),
                CustomCircleBtn(
                  btnText: '우리집에서 보내요',
                  btnTextColor: Colors.black,
                  borderColor: SetColor().colorD5,
                  btnFt: () {
                    Get.close(1);
                    Get.to(SelectClothesType(
                      isFirst: true,
                    ));
                    // Get.to(SelectClothesType());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
