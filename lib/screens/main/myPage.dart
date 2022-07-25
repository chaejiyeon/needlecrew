import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/modal/mypage/userLogoutYesNo.dart';
import 'package:needlecrew/screens/main/myPage/alramSetting.dart';
import 'package:needlecrew/screens/main/myPage/announcementInfo.dart';
import 'package:needlecrew/screens/main/myPage/myPayInfo.dart';
import 'package:needlecrew/screens/main/myPage/mysizeInfo.dart';
import 'package:needlecrew/screens/main/myPage/serviceCenterInfo.dart';
import 'package:needlecrew/screens/main/myPage/servicePolicyInfo.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/mypageMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import 'myPage/userInfo.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String? name = "";

  Future<void> username() async {
    name = await wp_api.storage.read(key: 'username');
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        FontStyle(
                            text: "My",
                            fontsize: "md",
                            fontbold: "bold",
                            fontcolor: Colors.black,
                            textdirectionright: false),
                        iconStyle("alramIcon.svg", "main", Colors.black),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                            future: username(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return FontStyle(
                                    text: name! +
                                        "님",
                                    fontbold: "bold",
                                    fontsize: "lg",
                                    fontcolor: Colors.black,
                                    textdirectionright: false);
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                        Text("니들크루와 함께"),
                        Text("일상의 작은 변화를 만들어봐요!"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        iconwrapBtn(
                            'userwrapIcon.svg', "main", "회원 정보", UserInfo()),
                        iconwrapBtn(
                            'mysizeIcon.svg', "main", "내 치수", MySizeInfo()),
                        iconwrapBtn(
                            'payinfoIcon.svg', "main", "결제 내역", MypayInfo()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            listLine(8, double.infinity, HexColor("#d5d5d5"), 0.5),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 24, right: 24),
                child: Column(
                  children: [
                    MypageMenu(listTitle: "고객센터", widget: ServiceCenterInfo()),
                    MypageMenu(
                        listTitle: "서비스 정책", widget: ServicePolicyInfo()),
                    MypageMenu(listTitle: "알림 설정", widget: AlramSetting()),
                    MypageMenu(listTitle: "공지사항", widget: AnnouncementInfo()),
                    MypageMenu(
                        listTitle: "로그아웃",
                        widget: UserLogoutYesNo(
                          titleText: "로그아웃 하시겠습니까?",
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // appbar icon style 설정
  Widget iconStyle(String icon, String filename, Color iconColor) {
    return SvgPicture.asset(
      "assets/icons/" + filename + "/" + icon,
      width: 25,
      height: 25,
      color: iconColor,
    );
  }

  // icon 버튼
  Widget iconwrapBtn(
      String icon, String fileName, String btnText, Widget widget) {
    return Container(
      width: 70,
      child: GestureDetector(
        onTap: () {
          Get.to(widget);
        },
        child: Column(
          children: [
            SvgPicture.asset("assets/icons/" + fileName + "/" + icon),
            Text(btnText),
          ],
        ),
      ),
    );
  }

  // list 구별 선
  Widget listLine(
      double height, double width, Color lineColor, double opacity) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      height: height,
      width: width,
      decoration: BoxDecoration(color: lineColor.withOpacity(opacity)),
    );
  }
}
