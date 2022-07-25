import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
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
                    "수선사 검수 완료 후 최종 가격을 전달 드릴 예정이며 결제 진행 여부에 따라 결제금액이 상이할 수 있습니다.",
                    false,
                    true),
                SizedBox(
                  height: 14,
                ),
                listItem(
                    "수선 결제를 진행하지 않는 경우 배송비 결제(6,000원)이 결제되며 고객님께서 보내주신 의류는 다시 반송됩니다.",
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
              child: CircleBlackBtn(btnText: "확인", pageName: "payTypeAdd"))
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
