import 'package:intl/intl.dart';
import 'package:needlecrew/modal/tear_icon_modal.dart';
import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/models/tooltip_text.dart';
import 'package:needlecrew/screens/main/fixClothes/fixUpdate.dart';
import 'package:needlecrew/widgets/cartInfo/tooltip_price_info.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/widgets/tootipCustom.dart';

import '../../getxController/fixClothes/cartController.dart';

class FixTypeListItem extends GetView<CartController> {
  final int listIndex;
  final int parentIndex;
  final int index;
  final String pageName;

  final CartItem cartItem;

  const FixTypeListItem({
    Key? key,
    required this.cartItem,
    required this.listIndex,
    required this.parentIndex,
    required this.index,
    this.pageName = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      "sample_2.jpeg",
      "sample_2.jpeg",
      "sample_3.jpeg",
    ];

    List itemIndex = [];

    // 금액 단위 변환
    String setPrice(int price) {
      String setPrice = NumberFormat('###,###,###').format(price);
      return setPrice;
    }

    // 하위 카테고리 체크여부 리스트에 저장
    controller.checkItem[parentIndex].add({
      "orderid": cartItem.cartId,
      "price": cartItem.productPrice,
      "ischecked": true
    });


    return Container(
      padding: EdgeInsets.only(top: index != 0 ? 25 : 0),
      child: Column(children: [
        ListLine(
            height: 1,
            width: double.infinity,
            lineColor: HexColor("#909090"),
            opacity: 0.2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pageName == "register" ? Container() : Obx(() {
              if (controller.isInitialized.value) {
                return checkBoxCustom("");
              } else {
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              }
            }),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image slide
                  Container(
                      margin: EdgeInsets.only(top: index != 0 ? 15 : 5),
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
                      text: cartItem.cartProductName,
                      fontsize: "md",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 10,
                  ),
                  cartItem.cartWay == "기타"
                      ? Container()
                      : detailInfo("의뢰 방법", cartItem.cartWay),
                  cartItem.cartWay == "기타"
                      ? Container()
                      : detailInfo(
                          "치수",
                          cartItem.cartSize == ""
                              ? "0 cm"
                              : cartItem.cartSize + " cm"),
                  cartItem.cartWay == "기타"
                      ? detailInfo("수량", cartItem.cartCount.toString())
                      : Container(),
                  detailInfo("추가 설명", cartItem.cartContent),
                  detailInfo(
                      "물품 가액",
                      cartItem.guaranteePrice != ""
                          ? setPrice(int.parse(cartItem.guaranteePrice)) + "원"
                          : "0" + "원"),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: ListLine(
                        height: 1,
                        width: double.infinity,
                        lineColor: HexColor("#909090"),
                        opacity: 0.2),
                  ),
                  TooltipPriceInfo(title: "의뢰 예상 비용",price:
                      setPrice(int.parse(cartItem.productPrice)),tooltipText: controller.cartItem.indexWhere((element) => element.cartWay == "직접 입력") != -1 ? insert.tooltipText : cost.tooltipText ,targetText: controller.cartItem.indexWhere((element) => element.cartWay == "직접 입력") != -1 ? [] : cost.boldText, infoIcon: true),
                  TooltipPriceInfo(title: "배송 비용",price: setPrice(6000),tooltipText: ship.tooltipText,targetText: ship.boldText,infoIcon: true),
                  SizedBox(
                    height: 10,
                  ),
                  pageName == "register" ? Container() : Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        fixBtn(
                            "삭제",
                            TearIconModal(
                              title: "선택한 의뢰를 삭제할까요?",
                              btnText1: "취소",
                              btnText2: "삭제",
                              orderId: cartItem.cartId,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(child: fixBtn("의뢰 수정", FixUpdate(cartItem: cartItem,))),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }

  // checkbox custom
  Widget checkBoxCustom(String text) {
    return GestureDetector(
      onTap: () {
        controller.ischecked(parentIndex, index);
      },
      child: Obx(
        () => Container(
          margin: EdgeInsets.only(top: index != 0 ? 25 : 15),
          child: Row(
            children: [
              controller.checkItem[parentIndex][index]["ischecked"] == false
                  ? Container(
                      width: 22,
                      height: 22,
                      child: Image.asset("assets/icons/checkBtnIcon.png"))
                  : Container(
                      width: 22,
                      height: 22,
                      child: Image.asset("assets/icons/selectCheckIcon.png")),
              SizedBox(
                width: 7,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FontStyle(
              text: title + " : ",
              fontsize: "",
              fontbold: "bold",
              fontcolor: Colors.black,
              textdirectionright: false),
          Expanded(child: Text(content))
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
