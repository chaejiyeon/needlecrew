
import 'package:needlecrew/main.dart';
import 'package:needlecrew/screens/join/chooseGender.dart';
import 'package:needlecrew/widgets/baseAppbar.dart';
import 'package:needlecrew/widgets/circleCheckBtn.dart';
import 'package:needlecrew/widgets/floatingNextBtn.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AgreeTerms extends StatefulWidget {
  const AgreeTerms({Key? key}) : super(key: key);

  @override
  State<AgreeTerms> createState() => _AgreeTermsState();
}

class _AgreeTermsState extends State<AgreeTerms> {
  bool whole_checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppBar(
        appbar: AppBar(),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 30),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontStyle(
                      text: "환영합니다 :D",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      fontsize: "lg",
                      textdirectionright: false),
                  FontStyle(
                      text: "니들크루 서비 이용에 필요한 사항을",
                      fontbold: "",
                      fontcolor: HexColor("#606060"),
                      fontsize: "md",
                      textdirectionright: false),
                  FontStyle(
                      text: "안내해드릴께요.",
                      fontbold: "",
                      fontcolor: HexColor("#606060"),
                      fontsize: "md",
                      textdirectionright: false),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 72),
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                shape: BoxShape.rectangle,
                border: Border.all(
                  width: 1,
                  color: HexColor("#d5d5d5"),
                ),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    if(whole_checked == false) {
                      whole_checked = true;
                    }else{
                      whole_checked = false;
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/icons/startPage/allcheckIcon.svg"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "약관 전체동의",
                      style: TextStyle(
                        color: HexColor("#404040"),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 17),
                child: Column(
                  children: [
                    CircleCheckBtn(
                        list: "개인정보 처리방침 (필수)",
                        listInfo: MyApp(),
                        checked: whole_checked),
                    CircleCheckBtn(
                        list: "서비스 이용 약관 (필수)",
                        listInfo: MyApp(),
                        checked: whole_checked),
                    CircleCheckBtn(
                        list: "혜택 정보 앱 푸시 알림 수신 (선택)",
                        listInfo: MyApp(),
                        checked: whole_checked),
                    CircleCheckBtn(
                        list: "추가비용 결제 안내 (필수)",
                        listInfo: MyApp(),
                        checked: whole_checked),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: whole_checked == true ? FloatingNextBtn(page: ChooseGender(),ischecked: true) : FloatingNextBtn(page: ChooseGender(),ischecked: false),
    );
  }

}
