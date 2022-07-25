import 'package:needlecrew/modal/tearIconModal.dart';
import 'package:needlecrew/screens/main/fixClothes.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../getxController/fixClothes/cartController.dart';

List<String> images = [
  "sample_2.jpeg",
  "sample_2.jpeg",
  "sample_3.jpeg",
];

bool ischecked = false;

// 단위 변환
String setPrice(int price) {
  String setPrice = NumberFormat('###,###,###').format(price);
  return setPrice;
}

class FixTypeRegisterListItem extends GetView<CartController> {
  const FixTypeRegisterListItem(
      {Key? key, required this.item, required this.index})
      : super(key: key);

  final int index;
  final LineItems item;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.getOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image slide
                  Container(
                      height: 150,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(images.length,
                              (index) => ImageItem(images[index])))),
                  SizedBox(
                    height: 10,
                  ),

                  // detail info
                  FontStyle(
                      text: "기장 수선 - " + item.name.toString(),
                      fontsize: "md",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 10,
                  ),
                  detailInfo("의뢰 방법", "줄이고 싶은 만큼 치수 입력"),
                  detailInfo("치수", "101.5cm"),
                  detailInfo("추가 설명", "시접 여유분 충분히 남겨주세요."),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: ListLine(
                        height: 2,
                        width: double.infinity,
                        lineColor: HexColor("#909090"),
                        opacity: 0.2),
                  ),
                  priceInfo("의뢰 예상 비용", setPrice(int.parse(item.price!)), true,
                      false),
                  priceInfo("배송 비용", "6,000", true, false),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });

    // return Obx(() {
    //   if (controller.isInitialized.value) {
    //     return Container(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           // image slide
    //           Container(
    //               height: 150,
    //               child: ListView(
    //                   scrollDirection: Axis.horizontal,
    //                   children: List.generate(
    //                       images.length, (index) => ImageItem(images[index])))),
    //           SizedBox(
    //             height: 10,
    //           ),
    //
    //           // detail info
    //           FontStyle(
    //               text: "기장 수선 - " + widget.item.name.toString(),
    //               fontsize: "md",
    //               fontbold: "bold",
    //               fontcolor: Colors.black,
    //               textdirectionright: false),
    //           SizedBox(
    //             height: 10,
    //           ),
    //           detailInfo("의뢰 방법", "줄이고 싶은 만큼 치수 입력"),
    //           detailInfo("치수", "101.5cm"),
    //           detailInfo("추가 설명", "시접 여유분 충분히 남겨주세요."),
    //           Container(
    //             padding: EdgeInsets.only(top: 10, bottom: 10),
    //             child: ListLine(
    //                 height: 2,
    //                 width: double.infinity,
    //                 lineColor: HexColor("#909090"),
    //                 opacity: 0.2),
    //           ),
    //           priceInfo(
    //               "의뢰 예상 비용", setPrice(int.parse(widget.item.price!)), true,
    //               false),
    //           priceInfo("배송 비용", "6,000", true, false),
    //           SizedBox(
    //             height: 10,
    //           ),
    //         ],
    //       ),
    //     );
    //   } else {
    //     return Center(child: CircularProgressIndicator(),);
    //   }
    // });
  }

  // slider Image Item
  Widget ImageItem(String image) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 150,
        height: 150,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "assets/images/" + image,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  // detail 목록
  Widget detailInfo(String title, String content) {
    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2),
      child: Row(
        children: [
          FontStyle(
              text: title + " : ",
              fontsize: "",
              fontbold: "bold",
              fontcolor: Colors.black,
              textdirectionright: false),
          FontStyle(
              text: content,
              fontsize: "",
              fontbold: "",
              fontcolor: Colors.black,
              textdirectionright: false),
        ],
      ),
    );
  }

  // 비용 목록
  Widget priceInfo(String title, String price, bool infoIcon, bool wholePrice) {
    return Container(
      padding: EdgeInsets.only(top: 7, bottom: 7, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Row(
              children: [
                FontStyle(
                    text: title,
                    fontsize: "",
                    fontbold: "bold",
                    fontcolor: Colors.black,
                    textdirectionright: false),
                SizedBox(
                  width: 5,
                ),
                infoIcon == true
                    ? Icon(
                        CupertinoIcons.question_circle,
                        color: HexColor("#909090"),
                        size: 20,
                      )
                    : Container(),
              ],
            ),
          ),
          Row(
            children: [
              FontStyle(
                  text: price,
                  fontsize: "",
                  fontbold: "bold",
                  fontcolor:
                      wholePrice == true ? HexColor("#fd9a03") : Colors.black,
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
    );
  }

  // 삭제 / 수정 버튼
  Widget fixBtn(String text, Widget widget) {
    return GestureDetector(
      onTap: () {
        text == "삭제" ? Get.dialog(widget) : Get.to(widget);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        width: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: HexColor("#d5d5d5"),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
