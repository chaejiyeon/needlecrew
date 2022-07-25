import 'package:needlecrew/bottomsheet/fixRegisterBottomSheet.dart';
import 'package:needlecrew/getxController/fixClothes/cartController.dart';
import 'package:needlecrew/widgets/fixClothes/fixClothesAppbar.dart';
import 'package:needlecrew/widgets/fixClothes/fixRegisterListItem.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'dart:ui' as ui;

class FixRegister extends GetView<CartController> {
  const FixRegister({Key? key}) : super(key: key);



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
                    // FutureBuilder(
                    //     future: controller.getOrder(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.done) {
                    //         return SingleChildScrollView(
                    //           child: Container(
                    //             padding:
                    //             EdgeInsets.only(left: 24, right: 24, top: 20),
                    //             child: Column(
                    //               children: List.generate(
                    //                   controller.registerOrders.length,
                    //                       (index) => FixRegisterListItem(
                    //                     lineItem: controller
                    //                         .registerOrders[index].lineItems!,
                    //                     index: index,
                    //                   )),
                    //             ),
                    //           ),
                    //         );
                    //       } else {
                    //         return Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       }
                    //     }),
                    FutureBuilder(future: controller.getOrder(),builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SingleChildScrollView(
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 24, right: 24, top: 20),
                            child: Column(
                              children: List.generate(
                                  controller.registerOrders.length,
                                  (index) => FixRegisterListItem(
                                        lineItem: controller
                                            .registerOrders[index].lineItems!,
                                        index: index,
                                      )),
                              // children: [
                              //   FixRegisterListItem(),
                              // ],
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
      bottomNavigationBar: GestureDetector(
        child: Container(
          height: 150,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FontStyle(
                            text: "총 의뢰 예상 금액 : ",
                            fontsize: "",
                            fontbold: "",
                            fontcolor: Colors.black,
                            textdirectionright: false),
                        FontStyle(
                            text: controller.setPrice(),
                            fontsize: "md",
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
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.chevron_up,
                          color: HexColor("#909090"),
                          size: 20,
                        )),
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
                    bottomsheetOpen(context, controller.wholePrice.value);
                  },
                  child: Text(
                    "총 " + controller.orderid.length.toString() + "건 의뢰 접수하기",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
