import 'package:intl/intl.dart';
import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/modal/alert_dialog_yes.dart';
import 'package:needlecrew/modal/alert_dialog_yes_no.dart';
import 'package:needlecrew/models/billing_info.dart';
import 'package:needlecrew/screens/main/myPage/pay_type_add.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:needlecrew/widgets/myPage/user_info_menu.dart';
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

  final HomeController controller = Get.put(HomeController());

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
  Widget build(BuildContext context) {
    paymentService.selectCard = paymentService.cardsBillkey[currentPage];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
          appbarcolor: 'white',
          appbar: AppBar(),
          title: '결제 수단',
          leadingWidget: BackBtn(),
          actionItems: [
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.to(PayTypeAdd(
                    isFirst: false,
                  ));
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    size: 23,
                    CupertinoIcons.plus_circle,
                    color: Colors.black,
                  ),
                )),
            AppbarItem(
              icon: 'trashIcon.svg',
              iconColor: Colors.black,
              iconFilename: '',
              function: () {
                Get.dialog(AlertDialogYesNo(
                  titleText: "등록된 정보를 삭제하시겠습니까?",
                  contentText: "결제 정보가 등록되어 있지 않으면\n수선의뢰 시 다시 작성해야합니다.",
                  icon: "",
                  iconPath: "",
                  btntext1: "취소",
                  btntext2: "삭제",
                  formname: "카드 삭제",
                ));
              },
            ),
          ]),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: Future.delayed(
                          Duration(seconds: 1), () => paymentService.getCardAll())
                      .asStream(),
                  builder: (context, snapshot) {
                    // if(snapshot.hasData){
                    //
                    // }
                    return paymentService.cardsInfo.length == 0
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
                                        paymentService.cardsInfo.length,
                                        (index) => cardCutom(
                                            paymentService.cardsInfo[index])),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(CupertinoIcons.back, size: 20),
                                      Container(
                                        child: Row(
                                          children: [
                                            FontStyle(
                                                text: (currentPage + 1)
                                                    .toString(),
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
                                                text: paymentService
                                                    .cardsInfo.length
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
                                            info: paymentService
                                                .cardsInfo[currentPage]
                                                .customer_name,
                                            line: true),
                                        UserInfoMenu(
                                            appTitle: "결제 수단",
                                            title: "이메일",
                                            info: paymentService
                                                .cardsInfo[currentPage]
                                                .customer_email,
                                            line: true),
                                        UserInfoMenu(
                                            appTitle: "결제 수단",
                                            title: "카드번호",
                                            info: setCardNum(paymentService
                                                .cardsInfo[currentPage]
                                                .card_number),
                                            line: true),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: paymentService.cardsInfo.length == 0
          ? Container(
              height: 0,
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: CircleBlackBtn(
                function: () => controller.registerCard('select_default'),
                btnText: "선택 완료",
              )),
    );
  }

  // card custom 위젯
  Widget cardCutom(CardInfo cardInfo) {
    if (currentPage == 0) {
      controller.updateUserInfo("default_card");
    } else {
      controller.updateUserInfo("pay_cards");
    }

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
