import 'package:intl/intl.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/modal/alert_dialog_yes.dart';
import 'package:needlecrew/modal/alert_dialog_yes_no.dart';
import 'package:needlecrew/models/billing_info.dart';
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
  final _carouselcontroller = CarouselController();
  late int currentPage = 0;

  final HomeController controller = Get.find();

  // 카드 번호 설정
  String setCardNum(String cardnum) {
    String number = "";

    number = cardnum.substring(0, 4) +
        "-" +
        cardnum.substring(4, 8) +
        "-" +
        cardnum.substring(8, 12) +
        "-" +
        cardnum.substring(12, 16);

    return number;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.updateUserInfo("default_card");

    controller.selectCard = currentPage;

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            appbar("결제 수단", Icon(CupertinoIcons.plus_circle), "trashIcon.svg"),
            Expanded(
              child: controller.cardsInfo.length == 0
                  ? Container(
                      alignment: Alignment.center,
                      child: Text("등록된 카드가 없습니다."),
                    )
                  : Container(
                      child: Column(
                        children: [
                          Container(
                            height: 230,
                            child: CarouselSlider(
                              carouselController: _carouselcontroller,
                              items: List.generate(
                                  controller.cardsInfo.length,
                                  (index) =>
                                      cardCutom(controller.cardsInfo[index])),
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
                                          fontcolor: Colors.black,
                                          textdirectionright: false),
                                      FontStyle(
                                          text: "/",
                                          fontsize: "",
                                          fontbold: "",
                                          fontcolor: Colors.black,
                                          textdirectionright: false),
                                      FontStyle(
                                          text: controller.cardsInfo.length
                                              .toString(),
                                          fontsize: "",
                                          fontbold: "",
                                          fontcolor: Colors.black,
                                          textdirectionright: false),
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
                                      info: controller
                                          .cardsInfo[currentPage].customer_name,
                                      line: true),
                                  UserInfoMenu(
                                      appTitle: "결제 수단",
                                      title: "이메일",
                                      info: controller.cardsInfo[currentPage]
                                          .customer_email,
                                      line: true),
                                  UserInfoMenu(
                                      appTitle: "결제 수단",
                                      title: "카드번호",
                                      info: setCardNum(controller
                                          .cardsInfo[currentPage].card_number),
                                      line: true),
                                ],
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
      bottomNavigationBar: controller.cardsInfo.length == 0
          ? Container(
              height: 0,
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: CircleBlackBtn(
                btnText: "선택 완료",
                pageName: "payType",
                updateName: "결제 수단",
              )),
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
                fontcolor: Colors.black,
                textdirectionright: false),
          ),
          Container(
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.to(PayTypeAdd(
                        isFirst: false,
                      ));
                    },
                    icon: icon1),
                GestureDetector(
                    onTap: () {
                      Get.dialog(AlertDialogYesNo(
                        titleText: "등록된 정보를 삭제하시겠습니까?",
                        contentText: "결제 정보가 등록되어 있지 않으면\n수선의뢰 시 다시 작성해야합니다.",
                        icon: "",
                        iconPath: "",
                        btntext1: "취소",
                        btntext2: "삭제",
                      ));
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
  Widget cardCutom(CardInfo cardInfo) {
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
                text: cardInfo.card_name,
                fontcolor: Colors.white,
                fontsize: "md",
                fontbold: "",
                textdirectionright: false),
          ),
        ),
        Align(
          widthFactor: 7.0,
          heightFactor: 6,
          alignment: Alignment.bottomRight,
          child: Container(
            child: FontStyle(
                text: cardInfo.card_number.substring(12, 16),
                fontcolor: Colors.white,
                fontbold: "",
                fontsize: "md",
                textdirectionright: false),
          ),
        ),
      ],
    );
  }
}
