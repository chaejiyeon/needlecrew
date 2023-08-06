import 'package:get/get.dart';
import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/functions.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart'
    as fix_register_bottom_sheet;
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class FixRegisterBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final int price;

  const FixRegisterBottomSheet(
      {Key? key, required this.scrollController, required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String payPrice = NumberFormat('###,###,###').format(price);
    final HomeController controller = Get.find();

    return Container(
      child: ListView(
        controller: scrollController,
        children: [
          Center(
            heightFactor: 5,
            child: Container(
              padding: EdgeInsets.only(top: 10),
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: HexColor("#909090"),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 24, right: 24, top: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "예상 결제금액 안내",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    textStyle("고객님의 수선 의뢰 예상 결제금액은 "),
                    Text(
                      payPrice,
                      style: TextStyle(color: HexColor("#fd9a03")),
                    ),
                    textStyle("원 입니다."),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 24, right: 24, top: 44),
            child: Column(
              children: [
                listItem(
                    "디자인 및 소재(또는 수선 난이도)에 따라 최종 금액이 변동될 수 있습니다.", false, true),
                SizedBox(
                  height: 14,
                ),
                listItem(
                    "택배비용(6,000)은 선결제이며, 수선 결제를 진행하지 않는 경우 고객님께서 보내주신 의류는 다시 반송됩니다.",
                    false,
                    true),
                SizedBox(
                  height: 14,
                ),
                listItem(
                    "최종 결제 금액은 수선사가 고객님의 의류를 전달 받아 연락드릴 예정입니다.", true, false),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 24, right: 24, top: 55),
              child: fix_register_bottom_sheet.CircleBlackBtn(
                function: () => Functions().payTypeAdd(),
                btnText: "확인",
              ))
        ],
      ),
    );
  }

  // text style
  Widget textStyle(String text) {
    return Text(
      text,
      style: TextStyle(color: HexColor("#606060")),
    );
  }

  // payDetail Info
  Widget listItem(String content, bool isColor, bool isLine) {
    return Container(
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "• ",
              style: TextStyle(
                  color: isColor == true
                      ? HexColor("#fd9a03")
                      : HexColor("#606060")),
            ),
            Expanded(
              child: Text(
                content,
                style: TextStyle(
                    color: isColor == true
                        ? HexColor("#fd9a03")
                        : HexColor("#606060")),
              ),
            ),
          ]),
          SizedBox(
            height: 14,
          ),
          isLine == true
              ? ListLine(
                  width: double.infinity,
                  height: 1,
                  lineColor: HexColor("#ededed"),
                  opacity: 1,
                )
              : Container(),
        ],
      ),
    );
  }
}
