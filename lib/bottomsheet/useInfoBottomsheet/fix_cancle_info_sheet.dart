import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/controller/my_use_info/useInfo_controller.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_update.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/widgets/phone_call_btn.dart';

class FixCancleInfoSheet extends StatelessWidget {
  final String fixInfoTitle;
  final int orderId;
  final bool fixPossible;
  final UseInfoController controller;

  ///
  final String productName;

  const FixCancleInfoSheet({
    Key? key,
    required this.fixInfoTitle,
    required this.orderId,
    required this.fixPossible,
    required this.controller,

    ///
    required this.productName,
  }) : super(key: key);

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

    List<String> images = [
      "guideImage_1.png",
      "sample_2.jpeg",
      "sample_3.jpeg",
    ];

    List deliverinfo = [
      ["수령인", "신응수"],
      ["연락처", "010-9282-2434"],
      ["배송지", "부산광역시 강서구 명지국제3로 97\n(명지동, 삼정그린코아 더베스트)\n105동 2215호"],
      ["수거 희망일", "2022년 2월 15일"],
    ];

    List priceinfo = [
      ["의뢰 예상 비용", 5000],
      ["배송 비용", 6000],
    ];

    List payinfo = [
      ["신용카드", ""],
      ["롯데(4892)", "자세히보기"],
    ];

    return FutureBuilder(
        future: controller.getFixInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            int cost =
                int.parse(controller.order.lineItems!.first.price.toString());
            int shipCost = 6000;

            int wholePrice = cost + shipCost;

            return ListView(
              controller: _scrollcontroller,
              shrinkWrap: true,
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, bottom: 30, top: 16),
                  // height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 50),
                        decoration: BoxDecoration(
                          color: HexColor("#f7f7f7"),
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
                        child: Obx(
                          () => EasyRichText(
                            "안녕하세요 고객님\n니들크루입니다.\n\n고객님께서 접수해주신 의뢰 '${"$productName 치수: ${controller.orderMetaData['치수']} cm"}'는 아래와 같은 사유로 수선이 불가능합니다.\n\n • ${controller.orderMetaData['수선 불가 사유']} \n\n의뢰 수정을 원하실 경우 아래의 버튼을 눌러 원하는 수선 길이를 수정해주시길 바랍니다.\n\n기타 문의사항이 있으신 경우 고객센터로 연락\n부탁드리겠습니다.\n\n감사합니다.",
                            defaultStyle: TextStyle(fontSize: 14),
                            patternList: [
                              EasyRichTextPattern(
                                  targetString:
                                      "'${"$productName 치수: ${controller.orderMetaData['치수']} cm"}'",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              btnCustom(context, "수선 취소"),
                              btnCustom(context, "의뢰 수정"),
                            ]),
                      ),
                    ],
                  ),
                ),
                PhoneCallBtn()
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  // slider Image Item
  Widget ImageItem(String image) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 120,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "assets/images/" + image,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

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
  Widget priceInfo(String costtitle, int price) {
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
                        : Icon(
                            CupertinoIcons.question_circle,
                            color: HexColor("#909090"),
                            size: 20,
                          ),
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
  String totalPrice(int expectPrice, int deliverPrice) {
    return NumberFormat('###,###,###,###').format(expectPrice + deliverPrice);
  }

  // 입력된 정보 리스트
  Widget info(
    bool isprice,
    String title,
    List list(),
  ) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isprice == true // 비용일 경우 타이틀에 총 금액 표시
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FontStyle(
                        text: title,
                        fontsize: "",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    Row(
                      children: [
                        FontStyle(
                            text: totalPrice(list()[0][1], list()[1][1]),
                            fontsize: "",
                            fontbold: "bold",
                            fontcolor: HexColor("#fd9a03"),
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
                )
              : FontStyle(
                  text: title,
                  fontsize: "",
                  fontbold: "bold",
                  fontcolor: Colors.black,
                  textdirectionright: false),
          SizedBox(
            height: 10,
          ),
          ListLine(
              height: 1,
              width: double.infinity,
              lineColor: HexColor("#d5d5d5").withOpacity(0.1),
              opacity: 0.5),
          SizedBox(
            height: 10,
          ),

          // 리스트 값만큼 뿌려줌
          for (int i = 0; i < list().length; i++)
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FontStyle(
                      text: list()[i][0].toString(),
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  title == "결제 정보" // 결제 정보일 경우 아이콘 표시
                      ? GestureDetector(
                          child: Row(
                            children: [
                              FontStyle(
                                  text: list()[i][1].toString(),
                                  fontsize: "",
                                  fontbold: "",
                                  fontcolor: Colors.black,
                                  textdirectionright: false),
                              list()[i][1] != ""
                                  ? Icon(
                                      CupertinoIcons.forward,
                                      size: 20,
                                      color: HexColor("#909090"),
                                    )
                                  : Container()
                            ],
                          ),
                        )
                      : isprice == true // 비용일 경우
                          ? Row(
                              children: [
                                FontStyle(
                                    text: NumberFormat('###,###,###,###')
                                        .format(list()[i][1])
                                        .toString(),
                                    fontsize: "",
                                    fontbold: "",
                                    fontcolor: Colors.black,
                                    textdirectionright: false),
                                FontStyle(
                                    text: "원",
                                    fontsize: "",
                                    fontbold: "",
                                    fontcolor: Colors.black,
                                    textdirectionright: false),
                              ],
                            )
                          : Align(
                              alignment: Alignment.centerRight,
                              child: FontStyle(
                                  text: list()[i][1].toString(),
                                  fontsize: "",
                                  fontbold: "",
                                  fontcolor: Colors.black,
                                  textdirectionright: true),
                            ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // 버튼 커스텀
  Widget btnCustom(BuildContext context, String btnText) {
    return GestureDetector(
      onTap: () {
        printInfo(info: 'btn text this $btnText is fix possible $fixPossible');
        CartController cartController = Get.find();

        if (fixPossible) {
          Get.dialog(
              barrierDismissible: false,
              CustomDialog(
                header: DialogHeader(
                  title: '접수한 의뢰를 취소할까요?',
                  btnIcon: 'tearIcon.svg',
                ),
                bottom: DialogBottom(isExpanded: true, btn: [
                  BtnModel(text: '아니요', callback: () => Get.back()),
                  BtnModel(
                      text: '예, 취소할게요.',
                      callback: () async {
                        await cartController.deleteCart("single", orderId);
                        await cartController.deleteImage();
                      })
                ]),
              ));
          // TearIconModal(
          // title: "접수한 의뢰를 취소할까요?",
          // btnText1: "아니요",
          // btnText2: "예, 취소할게요."));
        } else {
          switch (btnText) {
            case '의뢰 수정':
              Get.to(FixUpdate(
                  orderMetaData: OrderMetaData(
                      orderId: orderId,
                      productId: controller.order.lineItems!.first.productId!,
                      variationId:
                          controller.order.lineItems!.first.variationId!,
                      cartProductName: productName,
                      cartCount: controller.order.lineItems!.first.quantity!,
                      cartImages: controller.orderMetaData['사진'],
                      cartWay: controller.orderMetaData['의뢰 방법'],
                      cartSize: controller.orderMetaData['치수'],
                      cartContent: controller.orderMetaData['추가 설명'],
                      guaranteePrice: controller.orderMetaData['물품 가액'],
                      productPrice: controller.orderMetaData['상품 가격'])));
              break;
            case '수선 취소':
              Get.dialog(
                  barrierDismissible: false,
                  CustomDialog(
                      header: DialogHeader(
                          title: '수선을 취소하시겠습니까?',
                          content: '수선 취소시 등록된 카드 정보로\n왕복 배송비 6,000원이 결제됩니다.'),
                      bottom: DialogBottom(isExpanded: true, btn: [
                        BtnModel(text: '이전', callback: () => Get.back()),
                        BtnModel(
                            text: '확인',
                            callback: () async {
                              if (await controller.updateOrder(orderId, {
                                'status': 'fix-canclen',
                                'meta_data': [
                                  {'key': '수선 불가 사유', 'value': '수선 불가'}
                                ]
                              })) {
                                // if (await controller.getCompleteOrder()) {
                                //   Get.close(2);
                                // }
                              }
                            })
                      ])));
              break;
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: fixPossible == false && btnText == "수선 취소"
                ? HexColor("fd9a03")
                : HexColor("f7f7f7"),
            boxShadow: [
              BoxShadow(
                color: HexColor("#d5d5d5").withOpacity(0.5),
                spreadRadius: 0.5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ]),
        child: Text(
          btnText,
          style: TextStyle(
              color: fixPossible == false && btnText == "수선 취소"
                  ? Colors.white
                  : HexColor("aaaaaa")),
        ),
      ),
    );
  }
}
