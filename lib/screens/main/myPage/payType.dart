import 'package:needlecrew/modal/alertDialogYesNo.dart';
import 'package:needlecrew/models/user_card_info.dart';
import 'package:needlecrew/screens/main/myPage/payTypeAdd.dart';
import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/userInfoMenu.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PayType extends StatefulWidget {
  const PayType({Key? key}) : super(key: key);

  @override
  State<PayType> createState() => _PayTypeState();
}

class _PayTypeState extends State<PayType> {
  List<UserCardInfo> userinfos = [
    UserCardInfo("신응수", "cwal@amuz.co.kr", "롯데카드", "1234-5678-9101-4892", "01/19",
        "1234", "1993/05/23"),
    UserCardInfo("dddd", "cwal@amuz.co.kr", "롯데카드", "1234-5678-9101-4892", "01/19",
        "1234", "1993/05/23"),
    UserCardInfo("신응수", "cwal@amuz.co.kr", "롯데카드", "1234-5678-9101-4892", "01/19",
        "1234", "1993/05/23"),
  ];
  final _carouselcontroller = CarouselController();
  late int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            appbar("결제 수단", Icon(CupertinoIcons.plus_circle), "trashIcon.svg"),
            Container(
              height: 230,
              child: CarouselSlider(
                carouselController: _carouselcontroller,
                items: List.generate(
                    userinfos.length, (index) => cardCutom(userinfos[index])),
                options: CarouselOptions(
                    aspectRatio: 2.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPage = index;
                      });
                    }),
              ),
            ),

            Container(
              padding: EdgeInsets.zero,
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(CupertinoIcons.back, size: 20),
                  Container(
                    child: Row(
                      children: [
                        FontStyle(
                            text: (currentPage + 1).toString(),
                            fontsize: "",
                            fontbold: "",
                            fontcolor: Colors.black,textdirectionright: false),
                        FontStyle(
                            text: "/",
                            fontsize: "",
                            fontbold: "",
                            fontcolor: Colors.black,textdirectionright: false),
                        FontStyle(
                            text: userinfos.length.toString(),
                            fontsize: "",
                            fontbold: "",
                            fontcolor: Colors.black,textdirectionright: false),
                      ],
                    ),
                  ),
                  Icon(CupertinoIcons.forward, size: 20),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      UserInfoMenu(
                          appTitle: "결제 수단",
                          title: "이름",
                          info: userinfos[currentPage].userName,
                          line: true),
                      UserInfoMenu(
                          appTitle: "결제 수단",
                          title: "이메일",
                          info: userinfos[currentPage].userEmail,
                          line: true),
                      UserInfoMenu(
                          appTitle: "결제 수단",
                          title: "카드번호",
                          info: userinfos[currentPage].cardNum,
                          line: true),
                      UserInfoMenu(
                          appTitle: "결제 수단",
                          title: "유효기간",
                          info: userinfos[currentPage].date,
                          line: true),
                      UserInfoMenu(
                          appTitle: "결제 수단",
                          title: "비밀번호",
                          info: userinfos[currentPage].password,
                          line: true),
                      UserInfoMenu(
                          appTitle: "결제 수단",
                          title: "생년월일",
                          info: userinfos[currentPage].birthday,
                          line: false),
                    ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.all(20),
          child: CircleBlackBtn(btnText: "변경 완료", pageName: "mainHome")),
    );
  }

  // appbar 위젯
  Widget appbar(String title, Icon icon1, String icon2) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 10, right: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  CupertinoIcons.chevron_back,
                  color: Colors.black,
                  size: 20,
                )),
          ),
          Container(
            child: FontStyle(
                text: title,
                fontsize: "md",
                fontbold: "bold",
                fontcolor: Colors.black,textdirectionright: false),
          ),
          Container(
            child: Row(
              children: [
                IconButton(onPressed: () {
                  Get.to(
                      PayTypeAdd(isFirst: false,));
                }, icon: icon1),
                GestureDetector(
                    onTap: () {
                      Get.dialog(AlertDialogYesNo(titleText: "등록된 정보를 삭제하시겠습니까?",contentText: "결제 정보가 등록되어 있지 않으면\n수선의뢰 시 다시 작성해야합니다.", icon: "", iconPath: "", btntext1: "취소", btntext2: "삭제",));
                    },
                    child: SvgPicture.asset("assets/icons/" + icon2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // card custom 위젯
  Widget cardCutom(UserCardInfo userinfos) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          width: 300,
          child: Image.asset(
            "assets/images/card.png",
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          heightFactor: 2,
          child: Container(
            padding: EdgeInsets.only(left: 20),
            child: FontStyle(
              text: userinfos.cardName,
              fontcolor: Colors.white,
              fontsize: "md",
              fontbold: "",textdirectionright: false
            ),
          ),
        ),
        Align(
          widthFactor: 7.0,
          heightFactor: 6,
          alignment: Alignment.bottomRight,
          child: Container(
            child: FontStyle(
              text: userinfos.cardNum.substring(15, 19),
              fontcolor: Colors.white,
              fontbold: "",
              fontsize: "md",textdirectionright: false
            ),
          ),
        ),
      ],
    );
  }
}
