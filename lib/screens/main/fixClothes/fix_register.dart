import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:needlecrew/bottomsheet/fix_register_bottom_sheet.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/controller/widget_controller/custom_widget_controller.dart';
import 'package:needlecrew/custom_bottom_btn.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/cartInfo/cart_list_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/visible_info.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'dart:ui' as ui;

import 'take_fix_info.dart';

class FixRegister extends StatefulWidget {
  const FixRegister({Key? key}) : super(key: key);

  @override
  State<FixRegister> createState() => _FixRegisterState();
}

class _FixRegisterState extends State<FixRegister>
    with TickerProviderStateMixin {
  final CustomWidgetController widgetController =
  Get.put(CustomWidgetController(), tag: 'cart_register_info');
  final CartController controller = Get.find();
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
    printInfo(
        info:
        '수선 접수 개수${controller.registerOrders.first}');

    return Scaffold(
        appBar: CustomAppbar(
          leadingWidget: BackBtn(backFt: () {
            Get.off(() => TakeFixInfo());
          }),
          appbarcolor: 'white',
          appbar: AppBar(),
          actionItems: [
            AppbarItem(
              icon: 'homeIcon.svg',
              iconColor: Colors.black,
              iconFilename: 'main',
              widget: MainPage(pageNum: 0),
            ),
            AppbarItem(
              icon: 'cartIcon.svg',
              iconColor: Colors.black,
              iconFilename: 'main',
              widget: CartInfo(),
            ),
            AppbarItem(
              icon: 'alramIcon.svg',
              iconColor: Colors.black,
              iconFilename: 'main',
              widget: AlramInfo(),
            ),
          ],
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
                      "의뢰하신 접수 내역을 확인해주세요.",
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
                      SingleChildScrollView(
                        child: Container(
                          padding:
                          EdgeInsets.only(left: 24, right: 24, top: 20),
                          child: Obx(
                                () =>
                                Column(
                                  children: List.generate(
                                      controller.registerOrders.length,
                                          (index) =>
                                          CartListItem(
                                            cartInfo:
                                            controller.registerOrders[index],
                                            index: index,
                                            pageName: "register",
                                          )),
                                ),
                          ),
                        ),
                      ),
                      info(
                        "총 의뢰 예상 비용",
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
              () =>
              CustomBottomBtn(
                formName: 'cart_register_info',
                formHeight: !widgetController.isAnimated.value ? 250.h : 148.h,
                btnItems: [
                  BtnModel(
                      text:
                      "총 의뢰 예상 금액: ${controller.cartItem.any((element) =>
                          element['category_items'].any((Map e) =>
                              e.containsValue('직접입력'))) ? setprice(
                          controller.wholePrice.value) + " ~ " : controller
                          .wholePrice.value <= 0 &&
                          controller.cartItem.any((element) =>
                              element['category_items'].any((Map e) =>
                                  e.containsValue('직접입력'))) ? " - " : setprice(
                          controller.wholePrice.value + 6000)}원",
                      textSize: FontSize().fs6,
                      btnColor: SetColor().mainColor,
                      borderColor: SetColor().mainColor,
                      callback: () {
                        bottomsheetOpen(
                            context, controller.wholePrice.value + 6000);
                      })
                ],
                infoWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                          () =>
                          EasyRichText(
                            "총 의뢰 예상 금액: ${controller.cartItem.any((element) =>
                                element['category_items'].any((Map e) =>
                                    e.containsValue('직접입력')))
                                ? setprice(controller.wholePrice.value) + " ~ "
                                : controller.wholePrice.value <= 0 &&
                                controller.cartItem.any((element) =>
                                    element['category_items'].any((Map e) =>
                                        e.containsValue('직접입력')))
                                ? " - "
                                : setprice(
                                controller.wholePrice.value + 6000)}원",
                            defaultStyle: TextStyle(
                              fontSize: 14,
                              fontFamily: 'NotoSansCJKkrRegular',
                              color: Colors.black,
                            ),
                            patternList: [
                              EasyRichTextPattern(
                                targetString: FormatMethod()
                                    .convertPrice(
                                    price: controller.wholePrice.value + 6000),
                                style: TextStyle(
                                    color: HexColor("#fd9a03"),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
                visibleWidget: Obx(() =>
                    VisibleInfo(
                        visible: !widgetController.isAnimated.value,
                        formInfo: [
                          {
                            "titleText": "선택한 의뢰 예상 비용",
                            "tooltipText":
                            "옷의 부위와 재질, 수선 난이도에 따라 추가 비용이 발생할 수 있습니다.",
                            "targetText": ["추가 비용이 발생"],
                            "price": controller.cartItem.any((element) =>
                                element['category_items']
                                    .any((Map e) => e.containsValue('직접입력')))
                                ? setprice(controller.wholePrice.value) + " ~ "
                                : controller.wholePrice.value <= 0 &&
                                controller.cartItem.any((element) =>
                                    element['category_items'].any(
                                            (Map e) => e.containsValue('직접입력')))
                                ? " - "
                                : setprice(controller.wholePrice.value),
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
                            "price": controller.cartItem.any((element) =>
                                element['category_items']
                                    .any((Map e) => e.containsValue('직접입력')))
                                ? FormatMethod().convertPrice(
                                price: controller.wholePrice.value + 6000) +
                                " ~ "
                                : controller.wholePrice.value <= 0 &&
                                controller.cartItem.any((element) =>
                                    element['category_items'].any(
                                            (Map e) => e.containsValue('직접입력')))
                                ? " - "
                                : FormatMethod().convertPrice(
                                price: controller.wholePrice.value + 6000),
                            "istooltip": false
                          },
                        ])),
              ),
        ));
  }

  // 입력된 정보 리스트
  Widget info(String title,) {
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
                        FormatMethod().convertPrice(
                            price: controller.wholePrice.value + 6000),
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
              contentList("수거 희망일", controller.fixdate.value),
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
