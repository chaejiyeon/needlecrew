import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class UseInfoProcessSheet extends StatelessWidget {
  final int progressNum;
  final String date;

  const UseInfoProcessSheet({Key? key, required this.progressNum, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollcontroller = ScrollController();

    List<String> images = [
      "useinfo_register.png",
      "useinfo_take.png",
      "useinfo_shipping.png",
      "useinfo_arrive.png",
      "useinfo_confirm.png",
      "useinfo_complete.png",
    ];

    List<String> process = [
      "접수 완료",
      "수거 준비",
      "의류 수거",
      "의류 도착",
      "의류 확인",
      "수선 확정",
    ];

    return Container(
      color: Colors.white,
      child: ListView(
        controller: _scrollcontroller,
        shrinkWrap: true,
        children: [
          Container(
            padding: EdgeInsets.only(left: 24, right: 24),
            // height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: List.generate(
                            images.length, (index) => ImageItem(images[index])),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 15, right: 7.8),
                        child: Column(
                          children:
                              List.generate(6, (index) => progress(index)),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                              process.length,
                              (index) =>
                                  processItem(process[index], date)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 진행 상황 icon
  Widget ImageItem(String image) {
    return Container(
      padding: EdgeInsets.only(bottom: 33, right: 18),
      width: 50,
      child: Image.asset(
        "assets/icons/useinfo/" + image,
        fit: BoxFit.cover,
      ),
    );
  }

  // progress bar custom
  Widget progress(int index) {
    return Container(
      child: Column(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  progressNum == index + 1 ? HexColor("fd9a03") : Colors.white,
              border: Border.all(
                  color: index + 1 <= progressNum
                      ? HexColor("fd9a03")
                      : HexColor("#d5d5d5")),
            ),
          ),
          index != 5
              ? Container(
                  width: 1,
                  height: 59,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: index < progressNum - 1
                            ? HexColor("fd9a03")
                            : HexColor("#d5d5d5")),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  // 진행 상황
  Widget processItem(String title, String date) {
    return Container(
      padding: EdgeInsets.only(bottom: 26),
      child: ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        contentPadding: EdgeInsets.zero,
        trailing: Text(date, style: TextStyle(color: HexColor("#909090")),),
        leading: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
