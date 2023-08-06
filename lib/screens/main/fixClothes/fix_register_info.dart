import 'dart:developer';

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/controller/widget_controller/custom_widget_controller.dart';
import 'package:needlecrew/custom_bottom_btn.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/models/tooltip_text.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/myPage/pay_ment.dart';
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
  final CartController controller = Get.find();
  final HomeController homeController = Get.find();
  final CustomWidgetController widgetController =
  Get.put(CustomWidgetController(), tag: 'cart_register_confirm');


  @override
  Widget build(BuildContext context) {
    log('fix register info get arguments this');
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
                        Obx(
                              () =>
                              SingleChildScrollView(
                                child: Container(
                                  padding:
                                  EdgeInsets.only(left: 24, right: 24, top: 20),
                                  child: Column(
                                    children: List.generate(
                                        controller.registerOrders.length,
                                            (index) =>
                                            CartListItem(
                                              cartInfo:
                                              controller.registerOrders[index],
                                              pageName: "register",
                                              index: index,
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
        ),

        // 고정 bottom navigation
        bottomNavigationBar: Obx(
              () =>
              CustomBottomBtn(
                formName: 'cart_register_confirm',
                formHeight: !widgetController.isAnimated.value ? 250.h : 148.h,
                btnItems: [
                  BtnModel(text: '접수하기',
                      textSize: FontSize().fs6,
                      btnColor: SetColor().mainColor,
                      borderColor: SetColor().mainColor,
                      callback: () async {
                        log('pay order init&&&&&&&&&&');
                        Get.dialog(barrierDismissible: false, CustomDialog(
                          header: DialogHeader(
                            title: '배송비 결제', content: '주문 접수시, 배송비는 선결제 됩니다.',),
                          bottom: DialogBottom(isExpanded: true,
                              btn: [
                                BtnModel(text: '취소', callback: () =>
                                    Get.close(1)),
                                BtnModel(text: '확인', callback: () {
                                  paymentService.payOrder(
                                      paidShipping: {'paid_shipping': true,
                                        'order_id': 0}, payType: 'card',
                                      payInfo: {
                                        'order_name': '',
                                        'merchant_uid': 'mid_${FormatMethod()
                                            .convertDate(
                                            DateTime
                                                .now()
                                                .millisecondsSinceEpoch,
                                            'yyMMdd')}${controller
                                            .registerOrders
                                            .first['category_id']}',
                                        'amount': 6000
                                      });
                                  // controller.registerAddress();
                                })
                              ]),));

                        // Get.to(PayMent(
                        //     orderid: controller.registerOrders
                        //         .first['category_items']
                        //         .first['order_meta_data'].orderId));

                        // Ge.offAllNamed('mainHome');
                      })
                ],
                // btnText: '홈으로',
                infoWidget: Obx(
                      () =>
                      EasyRichText(
                        "총 의뢰 예상 금액 : ${controller.cartItem.any((element) =>
                            element['category_items'].any((Map e) =>
                                e.containsValue('직접입력'))) ? FormatMethod()
                            .convertPrice(
                            price: controller.wholePrice.value + 6000) +
                            " ~ " : controller.wholePrice.value <=
                            0 && controller.cartItem.any((element) =>
                            element['category_items'].any((Map e) =>
                                e.containsValue('직접입력')))
                            ? " - "
                            : FormatMethod().convertPrice(
                            price: controller.wholePrice.value + 6000)}원",
                        defaultStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'NotoSansCJKkrRegular',
                          color: Colors.black,
                        ),
                        patternList: [
                          EasyRichTextPattern(
                            targetString: FormatMethod().convertPrice(
                                price: controller.wholePrice.value + 6000),
                            style: TextStyle(
                                color: HexColor("#fd9a03"),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                ),
                visibleWidget: Obx(() =>
                    VisibleInfo(
                        visible: !widgetController.isAnimated.value,
                        formInfo: [
                          {
                            "titleText": "선택한 의뢰 예상 비용",
                            "tooltipText": cost.tooltipText,
                            "targetText": cost.boldText,
                            "price": controller.cartItem.any((element) =>
                                element['category_items']
                                    .any((Map e) => e.containsValue('직접입력')))
                                ? homeController
                                .setPrice(controller.wholePrice.value) +
                                " ~ "
                                : controller.wholePrice.value <= 0 &&
                                controller.cartItem.any((element) =>
                                    element['category_items'].any(
                                            (Map e) => e.containsValue('직접입력')))
                                ? " - "
                                : homeController
                                .setPrice(controller.wholePrice.value),
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
                                    .any((Map e) => e.containsValue('직접입력')))
                                ? FormatMethod().convertPrice(
                                price: controller.wholePrice.value) + " ~ "
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
        )
      // GestureDetector(
      //   child: Obx(
      //         () =>
      //         Container(
      //           height: controller.visibility.value == true ? 248 : 140,
      //           decoration: BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.only(
      //                 topLeft: Radius.circular(20),
      //                 topRight: Radius.circular(20)),
      //             boxShadow: [
      //               BoxShadow(
      //                 color: HexColor("#d5d5d5").withOpacity(0.1),
      //                 spreadRadius: 10,
      //                 blurRadius: 5,
      //               ),
      //             ],
      //           ),
      //           padding: EdgeInsets.all(20),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Expanded(
      //                 child: ,
      //               ),
      //               Container(
      //                 height: 20,
      //                 margin: EdgeInsets.only(bottom: 16),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Expanded(
      //                       child:
      //                     ),
      //                     Obx(
      //                           () =>
      //                           IconButton(
      //                               alignment: Alignment.centerRight,
      //                               padding: EdgeInsets.zero,
      //                               onPressed: () {
      //                                 if (controller.visibility.value == true) {
      //                                   controller.visibility.value = false;
      //                                 } else {
      //                                   controller.visibility.value = true;
      //                                 }
      //                               },
      //                               icon: AnimatedBuilder(
      //                                 animation: animationController,
      //                                 child: controller.visibility.value
      //                                     ? SvgPicture.asset(
      //                                   "assets/icons/dropdownIcon.svg",
      //                                   color: HexColor("#909090"),
      //                                   width: 14,
      //                                   height: 8,
      //                                 )
      //                                     : SvgPicture.asset(
      //                                   "assets/icons/dropdownupIcon.svg",
      //                                   color: HexColor("#909090"),
      //                                   width: 14,
      //                                   height: 8,
      //                                 ),
      //                                 builder: (context, child) {
      //                                   return Transform.rotate(
      //                                     angle: animationController.value *
      //                                         2.0 * 3.14,
      //                                     child: child,
      //                                   );
      //                                 },
      //                               )),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               Container(
      //                 margin: EdgeInsets.only(bottom: 10),
      //                 width: double.infinity,
      //                 height: 54,
      //                 decoration: BoxDecoration(
      //                   color: HexColor("#fd9a03"),
      //                   borderRadius: BorderRadius.circular(25),
      //                 ),
      //                 child: TextButton(
      //                   onPressed: () {
      //                     Get.toNamed('mainHome');
      //                     controller.registerAddress();
      //                   },
      //                   child: Text(
      //                     "홈으로",
      //                     style: TextStyle(color: Colors.white, fontSize: 16),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //   ),
      // ),
    );
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
              // contentList("결제 카드", list()[3]),
              contentList("수거 주소", controller.setAddress.value),
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
