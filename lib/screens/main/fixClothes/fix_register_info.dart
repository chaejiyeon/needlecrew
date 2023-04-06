import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:needlecrew/controller/fixClothes/cartController.dart';
import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/models/tooltip_text.dart';
import 'package:needlecrew/widgets/cartInfo/cart_list_item.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/widgets/visible_info.dart';

import 'dart:ui' as ui;

class FixRegisterInfo extends StatefulWidget {
  const FixRegisterInfo({Key? key}) : super(key: key);

  @override
  State<FixRegisterInfo> createState() => _FixRegisterInfoState();
}

class _FixRegisterInfoState extends State<FixRegisterInfo>
    with TickerProviderStateMixin {
  final CartController controller = Get.put(CartController());
  final HomeController homeController = Get.put(HomeController());
  late final AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int price = 0;
    List priceinfo = [
      11000,
      "경기 수원시 팔달구 인계동 156 104동 1702호",
      DateTime(2022, 2, 15),
      "롯데카드(4892)"
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // 옷바구니
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 24, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(
                        text: "접수가 완료되었습니다.",
                        fontsize: "lg",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "의뢰하신 접수 내역을 환인해주세요.",
                      style: TextStyle(color: HexColor("#909090")),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.zero,
                  color: HexColor("#f7f7f7"),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      FutureBuilder(
                          future: controller.getOrder(),
                          builder: (context, snapshot) {
                            if (controller.isInitialized.value) {
                              print("registerOrders " +
                                  controller.registerOrders.length.toString());
                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 24, right: 24, top: 20),
                                  child: Column(
                                    children: List.generate(
                                        controller.registerOrders.length,
                                            (index) =>
                                            CartListItem(
                                              cartInfo: controller
                                                  .registerOrders[index],
                                              pageName: "register",
                                              index: index,
                                            )),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                      info(
                        "총 의뢰 예상 비용",
                        (() => priceinfo),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // 고정 bottom navigation
      bottomNavigationBar: GestureDetector(
        child: Obx(
              () =>
              Container(
                height: controller.visibility.value == true ? 248 : 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor("#d5d5d5").withOpacity(0.1),
                      spreadRadius: 10,
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(() =>
                          VisibleInfo(
                              visible: controller.visibility.value,
                              formInfo: [
                                {
                                  "titleText": "선택한 의뢰 예상 비용",
                                  "tooltipText": cost.tooltipText,
                                  "targetText": cost.boldText,
                                  "price": controller.cartItem.any((element) =>
                                      element['category_items']
                                          .any((Map e) =>
                                          e.containsValue(
                                              '직접입력')))
                                      ? homeController.setPrice(
                                      controller.wholePrice.value) +
                                      " ~ "
                                      : controller.wholePrice.value <=
                                      0 &&
                                      controller.cartItem.any((element) =>
                                          element['category_items'].any((
                                              Map e) =>
                                              e.containsValue('직접입력')))
                                      ? " - "
                                      : homeController.setPrice(
                                      controller.wholePrice.value),
                                  "istooltip": true
                                },
                                {
                                  "titleText": "총 배송 비용",
                                  "tooltipText": ship.tooltipText,
                                  "targetText": ship.boldText,
                                  "price": homeController.setPrice(6000),
                                  "istooltip": true
                                },
                                {
                                  "titleText": "총 의뢰 예상 비용",
                                  "tooltipText": "",
                                  "targetText": [""],
                                  "price": controller.cartItem.any((element) =>
                                      element['category_items']
                                          .any((Map e) =>
                                          e.containsValue(
                                              '직접입력')))
                                      ? controller.setPrice(
                                  ) +
                                      " ~ "
                                      : controller.wholePrice.value <=
                                      0 &&
                                      controller.cartItem.any((element) =>
                                          element['category_items'].any((
                                              Map e) =>
                                              e.containsValue('직접입력')))
                                      ? " - "
                                      : controller.setPrice(
                                  ),
                                  "istooltip": false
                                },
                              ])),
                    ),
                    Container(
                      height: 20,
                      margin: EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Obx(
                                  () =>
                                  EasyRichText(
                                    "총 의뢰 예상 금액 : ${controller.cartItem.any((
                                        element) =>
                                        element['category_items']
                                            .any((Map e) =>
                                            e.containsValue(
                                                '직접입력')))
                                        ? controller.setPrice(
                                    ) +
                                        " ~ "
                                        : controller.wholePrice.value <=
                                        0 &&
                                        controller.cartItem.any((element) =>
                                            element['category_items'].any((
                                                Map e) =>
                                                e.containsValue('직접입력')))
                                        ? " - "
                                        : controller.setPrice(
                                    )}원",
                                    defaultStyle: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'NotoSansCJKkrRegular',
                                      color: Colors.black,
                                    ),
                                    patternList: [
                                      EasyRichTextPattern(
                                        targetString: controller.setPrice(),
                                        style: TextStyle(
                                            color: HexColor("#fd9a03"),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                          Obx(
                                () =>
                                IconButton(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      if (controller.visibility.value == true) {
                                        controller.visibility.value = false;
                                      } else {
                                        controller.visibility.value = true;
                                      }
                                    },
                                    icon: AnimatedBuilder(
                                      animation: animationController,
                                      child: controller.visibility.value
                                          ? SvgPicture.asset(
                                        "assets/icons/dropdownIcon.svg",
                                        color: HexColor("#909090"),
                                        width: 14,
                                        height: 8,
                                      )
                                          : SvgPicture.asset(
                                        "assets/icons/dropdownupIcon.svg",
                                        color: HexColor("#909090"),
                                        width: 14,
                                        height: 8,
                                      ),
                                      builder: (context, child) {
                                        return Transform.rotate(
                                          angle: animationController.value *
                                              2.0 * 3.14,
                                          child: child,
                                        );
                                      },
                                    )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        color: HexColor("#fd9a03"),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed('mainHome');
                          controller.registerAddress();
                        },
                        child: Text(
                          "홈으로",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  // 입력된 정보 리스트
  Widget info(String title,
      List list(),) {
    String price =
    NumberFormat('###,###,###').format(list()[0]).replaceAll(' ', '');
    String date = DateFormat('yyyy년 mm월 dd일').format(list()[2]);
    return Column(children: [
      SizedBox(
        height: 20,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: HexColor("#f5f5f5").withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: HexColor("#f5f5f5").withOpacity(0.5),
                spreadRadius: 0.5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleText(title),
                  Row(
                    children: [
                      Text(
                        controller.setPrice(),
                        style: TextStyle(
                            color: HexColor("#fd9a03"),
                            fontWeight: FontWeight.bold),
                      ),
                      Text("원"),
                    ],
                  ),
                ],
              ),
              contentList("결제 카드", list()[3]),
              contentList("수거 주소", list()[1]),
              contentList("수거 희망일", date),
            ],
          ),
        ),
      ),
    ]);
  }

  // title style
  Widget titleText(String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  // content form
  Widget contentList(String title, String content) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 120,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: title == "결제 카드"
                  ? GestureDetector(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          content,
                          textDirection: ui.TextDirection.rtl,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset("assets/icons/nextIcon.svg")
                      ]))
                  : Text(
                content,
                textDirection: ui.TextDirection.rtl,
              )),
        ],
      ),
    );
  }
}
