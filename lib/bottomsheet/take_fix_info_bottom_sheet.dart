import 'package:get/get.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_register.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_register_info.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class TakeFixInfoBottomSheet extends StatelessWidget {
  final ScrollController controller;

  const TakeFixInfoBottomSheet({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: Container(
            width: 60,
            height: 5,
            decoration: BoxDecoration(
              color: HexColor("#707070"),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            controller: controller,
            children: [
              Container(
                padding: EdgeInsets.zero,
                width: double.infinity,
                margin: EdgeInsets.only(top: 40, bottom: 20),
                child: SvgPicture.asset("assets/images/takeFix/takeFix.svg",
                    fit: BoxFit.fill),
              ),
              Container(
                padding: EdgeInsets.only(top: 38),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(
                        text: "의류 수거 가이드",
                        fontsize: "md",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    SizedBox(
                      height: 10,
                    ),
                    guideList(1,
                        "옷을 두겹으로 비닐 포장하거나 박스를 이용해\n포장한 후 '수거 예약'이라 적어주시고 수거 예정일에 문앞에 놓아주세요!"),
                    SizedBox(
                      height: 20,
                    ),
                    guideList(2, "대한통운에서 반품수거로 연락이 갈 수 있으니\n참고해주세요."),
                    SizedBox(
                      height: 20,
                    ),
                    guideList(3, "택배사 사정에 따라 소요 기간이 달라질 수 있습니다."),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Get.off(() => FixRegister());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 50, bottom: 56),
                    height: 54,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      shape: BoxShape.rectangle,
                      color: Colors.black,
                    ),
                    child: Text(
                      "확인",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  // guidelist
  Widget guideList(int num, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FontStyle(
            text: num.toString() + ".",
            fontsize: "",
            fontbold: "bold",
            fontcolor: HexColor("#fd9a03"),
            textdirectionright: false),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(content),
        ),
      ],
    );
  }
}
