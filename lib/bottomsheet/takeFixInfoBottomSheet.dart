import 'package:needlecrew/widgets/fontStyle.dart';
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
      child: ListView(
        controller: controller,
        children: [
          Container(
            padding: EdgeInsets.only(top: 5, left: 150, right: 150),
            child: Container(
              height: 7,
              decoration: BoxDecoration(color: HexColor("#909090"),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: SvgPicture.asset("assets/images/takeFix/takeFix.svg"),
          ),
          Container(
            padding: EdgeInsets.only(left: 24, right: 24, top: 38),
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
                guideList(1, "수거 예정 알림을 받으면 예정된 날짜에 옷을 포장해 문 앞에 내놓아 주세요."),
                SizedBox(
                  height: 10,
                ),
                guideList(
                    2, "옷을 포장할 때는 옷이 상하지 않게 두겹으로 비닐 포장하거나 포장 박스를 이용해 주세요.")
              ],
            ),
          ),
        ],
      ),
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
