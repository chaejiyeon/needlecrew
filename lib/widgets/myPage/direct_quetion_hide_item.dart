import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class DirectQuestionHideItem extends StatefulWidget {
  const DirectQuestionHideItem({Key? key}) : super(key: key);

  @override
  State<DirectQuestionHideItem> createState() => _DirectQuestionHideItemState();
}

class _DirectQuestionHideItemState extends State<DirectQuestionHideItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: HexColor("#ededed"),
          ),
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          collapsedIconColor: HexColor("#909090"),
          title: Container(
            height: 60,
            child: Row(
              children: [
                FontStyle(
                    text: "Q",
                    fontsize: "md",
                    fontbold: "bold",
                    fontcolor: HexColor("fd9a03"),
                    textdirectionright: false),
                SizedBox(
                  width: 10,
                ),
                FontStyle(
                    text: "수선 접수 취소는 어떻게 하나요?",
                    fontsize: "",
                    fontbold: "",
                    fontcolor: Colors.black,
                    textdirectionright: false),
              ],
            ),
          ),
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                  color: HexColor("#d5d5d5").withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "수선 접수 취소는 어떻게 하나요? 어떻게 해야할지 몰라서 이렇게 여쭈어 봅니다.\n\n최대한 빠른 답변 부탁드릴게요.",
                  ),
                  ListLine(
                      height: 1,
                      width: double.infinity,
                      lineColor: HexColor("#d5d5d5"),
                      opacity: 0.9),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FontStyle(
                          text: "A",
                          fontsize: "md",
                          fontbold: "bold",
                          fontcolor: HexColor("#fd9a03"),
                          textdirectionright: false),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          "안녕하세요!\n\n고객님의 문의소식을 듣고 달려온 니들크루입니다:)\n\n'수선 접수 취소'부분으로 문의를 주셨는데 안녕하세요!\n\n고객님의 문의소식을 듣고 달려온 니들크루입니다:)\n\n'수선 접수 취소'부분으로 문의를 주셨는데",
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // circlebtn
  Widget circleBtn(double fontboxwidth, Color btnColor, Color bordercolor,
      String text, Color fontcolor) {
    return Container(
      alignment: Alignment.center,
      width: fontboxwidth,
      height: 30,
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 1,
          color: bordercolor,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: fontcolor, fontSize: 14),
      ),
    );
  }
}
