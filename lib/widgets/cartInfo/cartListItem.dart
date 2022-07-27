import 'package:needlecrew/models/cartItemModel.dart';
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
  // final List<LineItems> lineItem;

  final List<CartItem> cartItem;
  const CartListItem({Key? key, required this.cartItem, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());

    print("this status     ddd " + controller.orders[index].status.toString());


    return Container(
      margin: EdgeInsets.only(bottom: 18),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                checkBoxCustom(cartItem.first.cartCategory[cartItem.first.cartCategory.length-2] + cartItem.first.cartCategory[cartItem.first.cartCategory.length-1]),
                GestureDetector(
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
                      style: TextStyle(color: HexColor("#fd9a03")),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ListLine(
              height: 2,
              width: double.infinity,
              lineColor: HexColor("#909090"),
              opacity: 0.2),

          Column(
            children: List.generate(cartItem.length, (index) => FixTypeListItem(cartItem: cartItem[index], index: index)),
          ),
          // 슬러그 별 구별 해야함 20220602(목)
          // FixTypeListItem(cartItem: cartItem[index], index: index),
        ],
      ),
    );
  }

  // checkbox custom
  Widget checkBoxCustom(String text) {
    return GestureDetector(
      onTap: () {
        if (controller.isCategorychecked.value == false) {
          controller.isCategorychecked.value = true;
        } else {
          controller.isCategorychecked.value = false;
        }
      },
      child: Obx(
        () => Container(
          child: Row(
            children: [
              controller.isCategorychecked.value == false
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
