import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:needlecrew/bottomsheet/fix_register_bottom_sheet.dart';
import 'package:needlecrew/widgets/cartInfo/cartListItem.dart';
import 'package:needlecrew/widgets/visible_info.dart';
import 'package:needlecrew/getxController/fixClothes/cartController.dart';
import 'package:needlecrew/modal/cartInfoModal.dart';
import 'package:needlecrew/widgets/circleLineBtn.dart';
import 'package:needlecrew/widgets/fixClothes/fixClothesAppbar.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'dart:ui' as ui;

class FixRegister extends StatefulWidget {
  const FixRegister({Key? key}) : super(key: key);

  @override
  State<FixRegister> createState() => _FixRegisterState();
}

class _FixRegisterState extends State<FixRegister>
    with TickerProviderStateMixin {
  final CartController controller = Get.put(CartController());
  late final AnimationController animationController;

  // 예상 결제금액 안내 bottomsheet
  void bottomsheetOpen(BuildContext context, int price) {
    showFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 0.7,
        maxHeight: 0.7,
        bottomSheetColor: Colors.transparent,
        decoration: BoxDecoration(
          color: HexColor("#f5f5f5"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context, controller, offset) =>
            FixRegisterBottomSheet(scrollController: controller, price: price));
  }

  // 비용 표시
  String setprice(int price) {
    String formatPrice =
        NumberFormat('###,###,###').format(price >= 0 ? price : 0);
    return formatPrice;
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List priceinfo = [
      11000,
      "경기 수원시 팔달구 인계동 156 104동 1702호",
      DateTime(2022, 2, 15)
    ];

    return Scaffold(
        appBar: FixClothesAppBar(
          appbar: AppBar(),
          prev: "수거 알림",
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              // 옷바구니
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 24, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(
                        text: "수선 접수",
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
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 24, right: 24, top: 20),
                                  child: Column(
                                    children: List.generate(
                                        controller.orderItem.length,
                                        (index) => CartListItem(
                                              cartItem: controller.orderItem,
                                              index: index,
                                              pageName: "register",
                                            )),
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
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

        // 고정 bottom navigation
        bottomNavigationBar: Obx(
          () => Container(
            height: controller.visibility.value == true ? 248 : 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                  child: Obx(() => VisibleInfo(
                          visible: controller.visibility.value,
                          formInfo: [
                            {
                              "titleText": "선택한 의뢰 예상 비용",
                              "tooltipText":
                                  "옷의 부위와 재질, 수선 난이도에 따라 추가 비용이 발생할 수 있습니다.",
                              "targetText": ["추가 비용이 발생"],
                              "price": controller.cartItem.indexWhere(
                                          (element) =>
                                              element.cartWay == "직접 입력") !=
                                      -1
                                  ? setprice(
                                          controller.wholePrice.value) +
                                      " ~ "
                                  : controller.wholePrice.value<= 0 &&
                                          controller.cartItem.indexWhere(
                                                  (element) =>
                                                      element.cartWay ==
                                                      "직접 입력") !=
                                              -1
                                      ? " - "
                                      : setprice(
                                          controller.wholePrice.value),
                              "istooltip": true
                            },
                            {
                              "titleText": "총 배송 비용",
                              "tooltipText":
                                  "의류 수거 비용 3,000원, 배송지 발송 비용 3,000원이 부과되며, 한 번에 결제한 의뢰 건 기준(6,000원)으로 묶음배송 진행됩니다.",
                              "targetText": [
                                "3,000",
                                "한 번에 결제한 의뢰 건 기준",
                                "(6,000원)"
                              ],
                              "price": setprice(6000),
                              "istooltip": true
                            },
                            {
                              "titleText": "총 의뢰 예상 비용",
                              "tooltipText": "",
                              "targetText": [""],
                              "price": controller.cartItem.indexWhere(
                                          (element) =>
                                              element.cartWay == "직접 입력") !=
                                      -1
                                  ? controller.setPrice() + " ~ "
                                  : controller.setPrice(),
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
                          () => EasyRichText(
                            "총 의뢰 예상 금액: ${controller.cartItem.indexWhere((element) => element.cartWay == "직접 입력") != -1 ? controller.setPrice() + " ~ " : controller.setPrice()}원",
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
                        () => IconButton(
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
                                  angle: animationController.value * 2.0 * 3.14,
                                  child: child,
                                );
                              },
                            )),
                      ),
                    ],
                  ),
                ),
                Obx(() => Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            color: controller.orderCount.value == 0
                                ? HexColor("#d5d5d5")
                                : HexColor("#fd9a03"),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              width: 1,
                              color: controller.orderCount.value == 0
                                  ? HexColor("#d5d5d5")
                                  : HexColor("#fd9a03"),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              bottomsheetOpen(
                                  context, controller.wholePrice.value + 6000);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "총 " +
                                      controller.orderCount.toString() +
                                      " 건 의뢰 진행하기",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                    // CircleLineBtn(
                    //   btnText:
                    //       "총 " + controller.orderCount.toString() + " 건 의뢰 진행하기",
                    //   fontboxwidth: double.infinity,
                    //   bordercolor: controller.orderCount.value == 0
                    //       ? HexColor("#d5d5d5")
                    //       : HexColor("#fd9a03"),
                    //   fontcolor: Colors.white,
                    //   fontsize: "md",
                    //   btnIcon: "",
                    //   btnColor: controller.orderCount.value == 0
                    //       ? HexColor("#d5d5d5")
                    //       : HexColor("#fd9a03"),
                    //   widgetName: bottomsheetOpen(context, controller.setPrice()),
                    //   fontboxheight: "",
                    //   iswidget: false,
                    // )),
                    ),
              ],
            ),
          ),
        ));
  }

  // 입력된 정보 리스트
  Widget info(
    String title,
    List list(),
  ) {
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
              contentList("수거 주소", controller.setAddress.toString()),
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
              child: Text(
            content,
            textDirection: ui.TextDirection.rtl,
          )),
        ],
      ),
    );
  }
}
