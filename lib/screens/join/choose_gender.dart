import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/screens/join/user_info_insert.dart';
import 'package:needlecrew/widgets/base_appbar.dart';
import 'package:needlecrew/widgets/floating_next_btn.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ChooseGender extends StatefulWidget {
  const ChooseGender({Key? key}) : super(key: key);

  @override
  State<ChooseGender> createState() => _ChooseGenderState();
}

class _ChooseGenderState extends State<ChooseGender> {
  final HomeController homeController = Get.find();
  int value = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppbar(
        appbar: AppBar(),
        prevFunction: () => Get.back(),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 24, right: 24, bottom: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 32),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontStyle(
                      text: "성별선택",
                      fontsize: "lg",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  FontStyle(
                      text: "고객님의 성별을 선택해주세요",
                      fontsize: "md",
                      fontbold: "",
                      fontcolor: HexColor("#606060"),
                      textdirectionright: false),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: 96,
                ),
                child: Column(
                  children: [
                    chooseGenderBtn(
                      "여성",
                      1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    chooseGenderBtn(
                      "남성",
                      2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    chooseGenderBtn(
                      "선택안함",
                      3,
                    ),
                  ],
                ),
              ),
            ),
            FloatingNextBtn(
              function: () => Get.to(UserInfoInsert()),
              ischecked: value != 0 ? true : false,
            )
          ],
        ),
      ),
      // floatingActionButton:
    );
  }

  // 성별 선택 버튼 위젯
  Widget chooseGenderBtn(String btnText, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          value = index;
        });

        homeController.setUserInfo(
            "gender",
            index == 1
                ? "F"
                : index == 2
                    ? "M"
                    : "N");
      },
      child: Container(
        width: double.infinity,
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            width: 1,
            color: value == index ? Colors.black : HexColor("#d5d5d5"),
          ),
        ),
        child: Text(
          btnText,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
