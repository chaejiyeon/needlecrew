import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 85, left: 36, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: 53,
                    height: 15,
                    child: Image.asset("assets/icons/needlecrew_logo.png")),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                rowText("아나바고", "대표 : 김현영"),
                SizedBox(
                  height: 5,
                ),
                FontStyle(
                    text: "통신판매신고 : 제 2021-부산부산진-1467호",
                    fontsize: "sm",
                    fontbold: "",
                    fontcolor: HexColor("#909090"),textdirectionright: false),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(text: "주소 : ", fontsize: "sm", fontbold: "", fontcolor: HexColor("#909090"),textdirectionright: false),
                    Column(
                      children: [
                        FontStyle(text: "부산시 진구 서전로8 WEWORK서면 05-105호", fontsize: "sm", fontbold: "", fontcolor: HexColor("#909090"),textdirectionright: false),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                rowText("사업자 등록번호 : 748-61-00480", "고객센터 : 1588-1588"),
                SizedBox(
                  height: 5,
                ),
                FontStyle(
                    text: "Copyright 2022 needlecrew All rights reserved.",
                    fontsize: "sm",
                    fontbold: "",
                    fontcolor: HexColor("#909090"),textdirectionright: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rowText(String text1, String text2) {
    return Row(
      children: [
        FontStyle(
            text: text1,
            fontsize: "sm",
            fontbold: "",
            fontcolor: HexColor("#909090"),textdirectionright: false),
        FontStyle(
            text: " | ",
            fontsize: "sm",
            fontbold: "",
            fontcolor: HexColor("#909090"),textdirectionright: false),
        FontStyle(
            text: text2,
            fontsize: "sm",
            fontbold: "",
            fontcolor: HexColor("#909090"),textdirectionright: false),
      ],
    );
  }
}
