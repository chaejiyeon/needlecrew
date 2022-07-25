import 'package:needlecrew/screens/main/fixClothes/addressInfo.dart';
import 'package:needlecrew/screens/main/fixClothes/chooseClothes.dart';
import 'package:needlecrew/screens/main/fixClothes/fixQuestion.dart';
import 'package:needlecrew/widgets/circleLineBtn.dart';
import 'package:needlecrew/widgets/fixClothes/header.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:flutter/cupertino.dart';
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
            bottomPadding: 50,
          ),

          // choose button
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                CircleLineBtn(
                  btnText: "쇼핑몰에서 보낼래요",
                  fontboxwidth: double.infinity,
                  bordercolor: HexColor("#d5d5d5"),
                  fontcolor: Colors.black,
                  fontsize: "md",
                  btnIcon: "",
                  btnColor: Colors.transparent,
                  widgetName: AddressInfo(isHome: false),
                  fontboxheight: "",
                  iswidget: true,
                ),
                SizedBox(
                  height: 10,
                ),
                CircleLineBtn(
                  btnText: "우리집에서 보내요",
                  fontboxwidth: double.infinity,
                  bordercolor: HexColor("#d5d5"
                      "d5"),
                  fontcolor: Colors.black,
                  fontsize: "md",
                  btnIcon: "",
                  btnColor: Colors.transparent,
                  widgetName: ChooseClothes(),
                  fontboxheight: "",
                  iswidget: true,
                )
              ],
            ),
          ),

          SizedBox(
            height: 150,
          ),
        ],
      ),
    );
  }
}
