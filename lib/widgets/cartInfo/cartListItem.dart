import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/screens/main/fixClothes/chooseClothes.dart';
import 'package:needlecrew/widgets/cartInfo/fixtypeListItem.dart';
import 'package:needlecrew/widgets/fixClothes/checkBtn.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;

import '../../getxController/fixClothes/cartController.dart';

class CartListItem extends GetView<CartController> {
  final int index;

  final List<CartItem> cartItem;

  final String pageName; // register - 수선 접수 페이지

  const CartListItem(
      {Key? key,
      required this.cartItem,
      required this.index,
      this.pageName = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 상위카테고리 구별
    controller.isCategory(cartItem[index].cartCategory, index);

    // 해당하는 카테고리에 상품 배열
    List<CartItem> listItem = [];

    for (int i = 0; i < cartItem.length; i++) {
      if (cartItem[index].cartCategory == cartItem[i].cartCategory) {
        listItem.add(cartItem[i]);
      }
    }

    if (controller.thisCategory == listItem.first.cartCategory &&
        controller.categoryCount == index) {
      return Container(
        margin: EdgeInsets.only(bottom: 18),
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pageName == "register"
                      ? Text(
                          listItem.first.cartCategory,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      : checkBoxCustom(listItem.first.cartCategory),
                  pageName == "register"
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            Get.to(() => ChooseClothes(
                                  parentNum: cartItem[index].categoryId,
                                ));
                          },
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.only(left: 13, right: 13),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: HexColor("#fd9a03"),
                                )),
                            child: Text(
                              "추가 수선하기",
                              style: TextStyle(
                                  color: HexColor("#fd9a03"), fontSize: 13),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Column(
              children: List.generate(
                  listItem.length,
                  (i) => FixTypeListItem(
                        cartItem: listItem[i],
                        index: i,
                        listIndex: listItem.length,
                        parentIndex: index,
                    pageName: pageName != "" ? pageName : "",
                      )),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  // checkbox custom
  Widget checkBoxCustom(String text) {
    return GestureDetector(
      onTap: () {
        controller.iscategoryChecked(index);
      },
      child: Obx(
        () => Container(
          child: Row(
            children: [
              controller.isCategorychecked[index] == false
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
