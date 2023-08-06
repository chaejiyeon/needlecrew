import 'package:intl/intl.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/models/tooltip_text.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_update.dart';
import 'package:needlecrew/widgets/cartInfo/tooltip_price_info.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/widgets/tootip_custom.dart';

class FixTypeListItem extends GetView<CartController> {
  final int listIndex;
  final int parentIndex;
  final int index;
  final String pageName;

  final OrderMetaData orderMetaData;

  const FixTypeListItem({
    Key? key,
    required this.orderMetaData,
    required this.listIndex,
    required this.parentIndex,
    required this.index,
    this.pageName = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List images = cartItem.cartImages;
    //
    // List itemIndex = [];
    //
    // 금액 단위 변환
    String setPrice(int price) {
      String setPrice = NumberFormat('###,###,###').format(price);
      return setPrice;
    }
    //
    // // 하위 카테고리 체크여부 리스트에 저장
    // controller.checkItem[parentIndex].add({
    //   "orderid": cartItem.cartId,
    //   "image": cartItem.cartImages,
    //   "price": cartItem.productPrice,
    //   "ischecked": true
    // });

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
            pageName == "register"
                ? Container()
                : checkBoxCustom(orderMetaData.orderId!, ''),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image slide
                  Container(
                      margin: EdgeInsets.only(top: index != 0 ? 15 : 5),
                      height: 150,
                      child: orderMetaData.cartImages?.length == 1 &&
                              orderMetaData.cartImages?[0] == ""
                          ? Image.asset("assets/images/defaultImg.png")
                          : ListView(
                              scrollDirection: Axis.horizontal,
                              children: List.generate(
                                  orderMetaData.cartImages!.length,
                                  (index) => ImageItem(
                                      orderMetaData.cartImages![index])))),
                  SizedBox(
                    height: 10,
                  ),

                  // detail info
                  FontStyle(
                      text: orderMetaData.cartProductName!,
                      fontsize: "md",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 10,
                  ),
                  orderMetaData.cartWay == "기타"
                      ? Container()
                      : detailInfo("의뢰 방법", orderMetaData.cartWay!),
                  orderMetaData.cartWay == "기타"
                      ? Container()
                      : detailInfo(
                          "치수",
                          orderMetaData.cartSize == ""
                              ? "0 cm"
                              : orderMetaData.cartSize! + " cm"),
                  orderMetaData.cartWay == "기타"
                      ? detailInfo("수량", orderMetaData.cartCount.toString())
                      : Container(),
                  detailInfo("추가 설명", orderMetaData.cartContent!),
                  detailInfo(
                      "물품 가액",
                      orderMetaData.guaranteePrice != ""
                          ? setPrice(int.parse(orderMetaData.guaranteePrice!)) +
                              "원"
                          : "0" + "원"),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: ListLine(
                        height: 1,
                        width: double.infinity,
                        lineColor: HexColor("#909090"),
                        opacity: 0.2),
                  ),
                  TooltipPriceInfo(
                      title: "의뢰 예상 비용",
                      price: setPrice(int.parse(orderMetaData.productPrice!)),
                      tooltipText: controller.cartItem.any((element) =>
                              element['category_items']
                                  .any((Map e) => e.containsValue('직접입력')))
                          ? insert.tooltipText
                          : cost.tooltipText,
                      targetText: controller.cartItem.any((element) =>
                              element['category_items']
                                  .any((Map e) => e.containsValue('직접입력')))
                          ? []
                          : cost.boldText,
                      infoIcon: true),
                  TooltipPriceInfo(
                      title: "배송 비용",
                      price: setPrice(6000),
                      tooltipText: ship.tooltipText,
                      targetText: ship.boldText,
                      infoIcon: true),
                  SizedBox(
                    height: 10,
                  ),
                  pageName == "register"
                      ? Container()
                      : Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              fixBtn(
                                  "삭제",
                                  CustomDialog(
                                    header: DialogHeader(
                                      title: '선택한 의뢰를 삭제할까요?',
                                      btnIcon: 'tearIcon.svg',
                                    ),
                                    bottom:
                                        DialogBottom(isExpanded: true, btn: [
                                      BtnModel(
                                          text: '취소',
                                          callback: () => Get.back()),
                                      BtnModel(
                                          text: '삭제',
                                          callback: () async {
                                            await controller.deleteCart(
                                                "single",
                                                orderMetaData.orderId);
                                            await controller.deleteImage();
                                          })
                                    ]),
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: fixBtn(
                                      "의뢰 수정",
                                      FixUpdate(
                                        orderMetaData: orderMetaData,
                                      ))),
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
  Widget checkBoxCustom(int orderId, String text) {
    return GestureDetector(
      onTap: () {
        controller.isChecked(parentIndex, index);
      },
      child: Container(
        margin: EdgeInsets.only(top: index != 0 ? 25 : 15),
        child: Row(
          children: [
            Obx(
              () => !controller.cartItem[parentIndex]['category_items'][index]
                      ['order_checked']
                  ? Container(
                      width: 22,
                      height: 22,
                      child: Image.asset("assets/icons/checkBtnIcon.png"))
                  : Container(
                      width: 22,
                      height: 22,
                      child: Image.asset("assets/icons/selectCheckIcon.png")),
            ),
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
    );
  }

  // slider Image Item
  Widget ImageItem(String image) {
    printInfo(info: 'image set this $image ${image.length}');
    List imageInfo = [];
    if (image.contains('|')) {
      imageInfo = image != "" ? image.trim().split('|') : [""];
    } else {
      if (image.length != 0) {
        imageInfo.add('image');
        imageInfo.add(image);
      }
    }

    printInfo(info: 'image this $image');
    printInfo(info: 'image info list this ${imageInfo.length}');

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 150,
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: imageInfo.isNotEmpty && imageInfo[0] != ""
              ? Image.network(imageInfo[1], fit: BoxFit.cover)
              : null,
        ),
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
