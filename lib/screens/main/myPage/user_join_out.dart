import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:needlecrew/modal/mypage/user_join_out_dialog.dart';
import 'package:needlecrew/screens/main/main_home.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class UserJoinOut extends StatefulWidget {
  const UserJoinOut({Key? key}) : super(key: key);

  @override
  State<UserJoinOut> createState() => _UserJoinOutState();
}

class _UserJoinOutState extends State<UserJoinOut> {
  List<String> outList = [
    '불편사항을 선택해주세요.',
    '자주 사용하지 않아요',
    '개인정보 유출이 우려돼요.',
    '서비스 금액이 부담스러워요.',
    '배송 및 주문에 불만이 있어요.',
    '다른 플랫폼을 사용하고 있어요.',
    '기타',
  ];

  String selectValue = "불편사항을 선택해주세요.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: '회원탈퇴',
        leadingWidget: BackBtn(),
      ),
      body: Container(
        color: HexColor("#d5d5d5").withOpacity(0.3),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              color: Colors.white,
              height: 300,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FontStyle(
                      text:
                          "더 나은 니들크루가 되기 위해 사용하시면서 불편하셨던\n점이나 불편사항을 알려주시면 적극 반영하여 앞으로의\n불편함을 해결하도록 노력하겠습니다.",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FontStyle(
                            text: "회원탈퇴 안내",
                            fontsize: "",
                            fontbold: "bold",
                            fontcolor: Colors.black,
                            textdirectionright: false),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FontStyle(
                                text: "1. ",
                                fontsize: "",
                                fontbold: "bold",
                                fontcolor: Colors.black,
                                textdirectionright: false),
                            Expanded(
                                child: Text(
                                    "회원 탈퇴 시 고객님의 정보는 1년간 전자상거래 소비자 보호에 관한 법률에 의거한 고객 정보 보호정책에 따라 관리됩니다.")),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FontStyle(
                                text: "2. ",
                                fontsize: "",
                                fontbold: "bold",
                                fontcolor: Colors.black,
                                textdirectionright: false),
                            Expanded(
                                child: Text(
                                    "회원 탈퇴한 아이디는 본인과 타인 모두 재사용 및 복구가 불가능하오니 신중하게 선택하시길 바랍니다.")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(
                        text: "무엇이 불편하셨나요?",
                        fontsize: "",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 44,
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          value: selectValue,
                          onChanged: (value) {
                            setState(() {
                              selectValue = value.toString();
                            });
                          },
                          hint: Text(
                            outList[0],
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          items: outList
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Container(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          buttonWidth: 166,
                          buttonHeight: 36,
                          buttonPadding: EdgeInsets.only(left: 10, right: 14),
                          buttonDecoration: BoxDecoration(
                              border: Border.all(color: HexColor("#ededed")),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          icon: SvgPicture.asset(
                            "assets/icons/dropdownIcon.svg",
                            color: HexColor("#909090"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: circleBtn(
              UserJoinOutDialog(
                titleText: "정말 회원 탈퇴하시겠습니까?",
              ),
              "탈퇴하기")),
    );
  }

  // 탈퇴하기 버튼
  Widget circleBtn(Widget widget, String btnText) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      child: TextButton(
        onPressed: () {
          Get.dialog(widget);
        },
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
