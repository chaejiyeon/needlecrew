import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/controller/my_use_info/useInfo_controller.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_update.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/widgets/tootip_custom.dart';
import 'package:needlecrew/models/tooltip_text.dart';

class FixInfoSheet extends StatelessWidget {
  final String fixInfoTitle;
  final int orderId;
  final UseInfoController controller;
  final int readyInfo;

  const FixInfoSheet(
      {Key? key,
      required this.fixInfoTitle,
      required this.orderId,
      required this.controller,
      this.readyInfo = 0})
      : super(key: key);

  // 물품 가액 표시
  String price(String price) {
    int changePrice = int.parse(price);
    String thisPrice = NumberFormat('#,###,###').format(changePrice);

    return thisPrice;
  }

  @override
  Widget build(BuildContext context) {
    controller.updateOrderId.value = orderId;

    ScrollController _scrollcontroller = ScrollController();

    List payinfo = [
      ["신용카드", ""],
      ["롯데(4892)", "자세히보기"],
    ];

    return FutureBuilder(
        future: controller.getFixInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            int costPrice =
                int.parse(controller.order.lineItems!.first.price.toString());
            int wholePrice = costPrice;

            return Container(
              child: ListView(
                controller: _scrollcontroller,
                shrinkWrap: true,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 24, right: 24, bottom: 30),
                    // height: 400,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              orderServices.getOrder['product_name'] ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListLine(
                              height: 1,
                              width: double.infinity,
                              lineColor: HexColor("#909090"),
                              opacity: 0.5),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 120,
                              child: NotificationListener(
                                onNotification: (notification) {
                                  return true;
                                },
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: List.generate(
                                        controller.orderMetaData['사진'].length,
                                        (index) => ImageItem(
                                            image: controller
                                                .orderMetaData['사진'][index]))),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            controller.order.lineItems!.first.name.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          fixInfo("의뢰 방법", controller.orderMetaData['의뢰 방법']),
                          fixInfo("치수", controller.orderMetaData['치수']),
                          fixInfo(
                              "추가 설명",
                              controller.orderMetaData['추가 설명'] == ''
                                  ? '없음'
                                  : controller.orderMetaData['추가 설명']),
                          fixInfo("물품 가액", controller.orderMetaData['물품 가액']),
                          SizedBox(
                            height: 20,
                          ),
                          ListLine(
                              height: 1,
                              width: double.infinity,
                              lineColor: HexColor("#d5d5d5").withOpacity(0.1),
                              opacity: 0.9),
                          SizedBox(
                            height: 20,
                          ),
                          priceInfo(
                              TooltipCustom(
                                tooltipText: cost.tooltipText,
                                titleText: cost.tooltipName,
                                boldText: cost.boldText,
                                tailPosition: "up",
                                fontsize: 14,
                              ),
                              "",
                              int.parse(controller.order.lineItems!.first.price
                                  .toString())),
                          fixInfoTitle == "detailInfo" || readyInfo != 6
                              ? priceInfo(null, "총 의뢰 예상 비용", wholePrice)
                              : priceInfo(null, "최종 결제 비용", wholePrice),
                          fixInfoTitle == "detailInfo"
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.dialog(
                                              barrierDismissible: false,
                                              CustomDialog(
                                                header: DialogHeader(
                                                    headerWidget: Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 14.h),
                                                      child: SvgPicture.asset(
                                                          "assets/icons/tearIcon.svg"),
                                                    ),
                                                    title: '접수한 의뢰를 취소할까요?'),
                                                bottom: DialogBottom(
                                                    isExpanded: true,
                                                    btn: [
                                                      BtnModel(
                                                          text: '아니요',
                                                          callback: () =>
                                                              Get.back()),
                                                      BtnModel(
                                                          text: '예, 취소할게요.',
                                                          callback: () async {
                                                            if (await controller
                                                                .updateOrder(
                                                                    orderId, {
                                                              'status':
                                                                  'fix-canclen',
                                                              'meta_data': [
                                                                {
                                                                  'key':
                                                                      '수선 불가 사유',
                                                                  'value':
                                                                      '사용자 취소'
                                                                }
                                                              ]
                                                            })) {
                                                              // if (await controller
                                                              //     .getCompleteOrder()) {
                                                              //   Get.close(2);
                                                              // }
                                                            }
                                                          })
                                                    ]),
                                              ));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.8,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            border: Border.all(
                                              color: HexColor("#d5d5d5"),
                                            ),
                                          ),
                                          child: Text("수선 취소"),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(FixUpdate(
                                              orderMetaData: OrderMetaData(
                                                  orderId: orderId,
                                                  productId: controller
                                                      .order
                                                      .lineItems!
                                                      .first
                                                      .productId!,
                                                  variationId: controller
                                                      .order
                                                      .lineItems!
                                                      .first
                                                      .variationId!,
                                                  cartProductName:
                                                      orderServices.getOrder['product_name'] ??
                                                          '',
                                                  cartCount: controller
                                                      .order
                                                      .lineItems!
                                                      .first
                                                      .quantity!,
                                                  cartImages: controller
                                                      .orderMetaData['사진'],
                                                  cartWay: controller
                                                      .orderMetaData['의뢰 방법'],
                                                  cartSize:
                                                      controller.orderMetaData['치수'],
                                                  cartContent: controller.orderMetaData['추가 설명'],
                                                  guaranteePrice: controller.orderMetaData['물품 가액'],
                                                  productPrice: controller.orderMetaData['상품 가격'])));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.8,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            border: Border.all(
                                              color: HexColor("#d5d5d5"),
                                            ),
                                          ),
                                          child: Text("의뢰 수정"),
                                        ),
                                      ),
                                    ])
                              : Container(
                                  width: 0,
                                )
                        ],
                      ),
                    ),
                  ),
                  formCustom(
                    formMargin: EdgeInsets.only(bottom: 20),
                    title: "배송지 정보",
                    info: [
                      {
                        'title': '수령인',
                        'content':
                            '${controller.order.shipping!.lastName}${controller.order.shipping!.firstName}'
                      },
                      {
                        'title': '연락처',
                        'content': homeInitService.userInfo['phone_number']
                      },
                      {
                        'title': '배송지',
                        'content': '${controller.order.shipping!.address1}'
                      },
                      {
                        'title': '수거 희망일',
                        'content': '${controller.orderMetaData['수거 희망일']}'
                      }
                    ],
                  ),
                  formCustom(
                    isCost: true,
                    formMargin: EdgeInsets.only(bottom: 20),
                    title: "총 의뢰 예상 비용",
                    cost: int.parse(
                        controller.order.lineItems!.first.price.toString()),
                    info: [
                      {
                        'title': '의뢰 예상 비용',
                        'content': NumberFormat('###,###,###,###원').format(
                            int.parse(controller.order.lineItems!.first.price
                                .toString()))
                      },
                    ],
                  ),
                  // info(
                  //   false,
                  //   "결제 정보",
                  //   (() => payinfo),
                  // ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

// slider Image Item
//   Widget ImageItem(String image) {
//     printInfo(info: 'image set this $image ${image.length}');
//     List imageInfo = [];
//     if (image.contains('|')) {
//       imageInfo = image != "" ? image.trim().split('|') : [""];
//     } else {
//       if (image.length != 0) {
//         imageInfo.add('image');
//         imageInfo.add(image);
//       }
//     }
//
//     printInfo(info: 'image this $image');
//     printInfo(info: 'image info list this ${imageInfo.length}');
//
//     return GestureDetector(
//       child: Container(
//         padding: EdgeInsets.all(10),
//         width: 120.w,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: imageInfo.isNotEmpty && imageInfo[0] != ""
//               ? Image.network(imageInfo[1], fit: BoxFit.cover)
//               : null,
//         ),
//       ),
//     );
//   }

  // 수선 정보
  Widget fixInfo(String title, String recomend) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            FontStyle(
                text: title + " : ",
                fontsize: "",
                fontbold: "bold",
                fontcolor: Colors.black,
                textdirectionright: false),
            FontStyle(
                text: title == "치수"
                    ? recomend + "cm"
                    : title == "물품 가액"
                        ? price(recomend)
                        : recomend,
                fontsize: "",
                fontbold: "",
                fontcolor: Colors.black,
                textdirectionright: false),
          ],
        ),
      ],
    );
  }

  // 수선 비용
  Widget priceInfo(Widget? toolTip, String costtitle, int price) {
    final priceformat = NumberFormat('###,###,###,###').format(price);

    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Row(
                  children: [
                    FontStyle(
                        text: costtitle,
                        fontsize: "bold",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    SizedBox(
                      width: 5,
                    ),
                    costtitle == "총 의뢰 예상 비용" || costtitle == "최종 결제 비용"
                        ? Container(
                            width: 0,
                          )
                        : toolTip!,
                  ],
                ),
              ),
              Row(
                children: [
                  FontStyle(
                      text: priceformat,
                      fontsize: priceformat,
                      fontbold: "bold",
                      fontcolor:
                          costtitle == "총 의뢰 예상 비용" || costtitle == "최종 결제 비용"
                              ? HexColor("#fa9d03")
                              : Colors.black,
                      textdirectionright: false),
                  FontStyle(
                      text: "원",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 총 의뢰 예상 비용
  String totalPrice(int price) {
    return NumberFormat('###,###,###,###').format(price);
  }

  // form custom
  Widget formCustom({
    EdgeInsets? formMargin,
    String title = '',
    int cost = 0,
    bool isCost = false,
    List info = const [],
  }) {
    return Container(
      padding: EdgeInsets.only(left: 44, top: 20, right: 44, bottom: 20),
      margin: formMargin,
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
              CustomText(
                text: title,
                fontSize: FontSize().fs4,
                fontWeight: FontWeight.bold,
              ),
              isCost
                  ? Row(
                      children: [
                        CustomText(
                          text: totalPrice(cost),
                          fontSize: FontSize().fs4,
                          fontWeight: FontWeight.bold,
                          fontColor: SetColor().mainColor,
                        ),
                        CustomText(
                          text: "원",
                          fontSize: FontSize().fs4,
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
          ListLine(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              height: 1,
              width: double.infinity,
              lineColor: HexColor("#d5d5d5").withOpacity(0.1),
              opacity: 0.5),
          Column(
            children: info
                .map(
                  (item) => Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                            textAlign: TextAlign.left,
                            formWidth: 97.w,
                            text: item['title'],
                            fontSize: FontSize().fs4),
                        title == "결제 정보" && item['title'] == 'card_info'
                            ? Expanded(
                                child: GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomText(
                                        text: item['content'],
                                        fontSize: FontSize().fs4,
                                      ),
                                      Icon(
                                        CupertinoIcons.forward,
                                        size: 20,
                                        color: HexColor("#909090"),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(
                                child: CustomText(
                                  textAlign: TextAlign.right,
                                  textMaxLines: 100,
                                  text: item['content'],
                                  fontSize: FontSize().fs4,
                                ),
                              )
                      ],
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

// 입력된 정보 리스트
// Widget info(
//   bool isprice,
//   String title,
//   List list(),
// ) {
//   return Container(
//     padding: EdgeInsets.all(20),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       boxShadow: [
//         BoxShadow(
//           color: HexColor("#f5f5f5").withOpacity(0.5),
//           spreadRadius: 0.5,
//           blurRadius: 7,
//           offset: Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         isprice == true // 비용일 경우 타이틀에 총 금액 표시
//             ? Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   FontStyle(
//                       text: title,
//                       fontsize: "",
//                       fontbold: "bold",
//                       fontcolor: Colors.black,
//                       textdirectionright: false),
//                   Row(
//                     children: [
//                       FontStyle(
//                           text: totalPrice(list()[0][1], list()[1][1]),
//                           fontsize: "",
//                           fontbold: "bold",
//                           fontcolor: HexColor("#fd9a03"),
//                           textdirectionright: false),
//                       FontStyle(
//                           text: "원",
//                           fontsize: "",
//                           fontbold: "",
//                           fontcolor: Colors.black,
//                           textdirectionright: false),
//                     ],
//                   ),
//                 ],
//               )
//             : FontStyle(
//                 text: title,
//                 fontsize: "",
//                 fontbold: "bold",
//                 fontcolor: Colors.black,
//                 textdirectionright: false),
//         SizedBox(
//           height: 10,
//         ),
//         ListLine(
//             height: 1,
//             width: double.infinity,
//             lineColor: HexColor("#d5d5d5").withOpacity(0.1),
//             opacity: 0.5),
//         SizedBox(
//           height: 10,
//         ),
//
//         // 리스트 값만큼 뿌려줌
//         for (int i = 0; i < list().length; i++)
//           Container(
//             padding: EdgeInsets.only(bottom: 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 FontStyle(
//                     text: list()[i][0].toString(),
//                     fontsize: "",
//                     fontbold: "",
//                     fontcolor: Colors.black,
//                     textdirectionright: false),
//                 title == "결제 정보" // 결제 정보일 경우 아이콘 표시
//                     ? GestureDetector(
//                         child: Row(
//                           children: [
//                             FontStyle(
//                                 text: list()[i][1].toString(),
//                                 fontsize: "",
//                                 fontbold: "",
//                                 fontcolor: Colors.black,
//                                 textdirectionright: false),
//                             list()[i][1] != ""
//                                 ? Icon(
//                                     CupertinoIcons.forward,
//                                     size: 20,
//                                     color: HexColor("#909090"),
//                                   )
//                                 : Container()
//                           ],
//                         ),
//                       )
//                     : isprice == true // 비용일 경우
//                         ? Row(
//                             children: [
//                               FontStyle(
//                                   text: NumberFormat('###,###,###,###')
//                                       .format(list()[i][1])
//                                       .toString(),
//                                   fontsize: "",
//                                   fontbold: "",
//                                   fontcolor: Colors.black,
//                                   textdirectionright: false),
//                               FontStyle(
//                                   text: "원",
//                                   fontsize: "",
//                                   fontbold: "",
//                                   fontcolor: Colors.black,
//                                   textdirectionright: false),
//                             ],
//                           )
//                         : Align(
//                             alignment: Alignment.centerRight,
//                             child: FontStyle(
//                                 text: list()[i][1].toString(),
//                                 fontsize: "",
//                                 fontbold: "",
//                                 fontcolor: Colors.black,
//                                 textdirectionright: true),
//                           ),
//               ],
//             ),
//           ),
//       ],
//     ),
//   );
// }
}
