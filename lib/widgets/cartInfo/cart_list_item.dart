import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/screens/main/fixClothes/choose_clothes.dart';
import 'package:needlecrew/widgets/cartInfo/fix_type_list_item.dart';
import 'package:needlecrew/widgets/fixClothes/radio_btn.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;

import '../../controller/fixClothes/cartController.dart';

class CartListItem extends GetView<CartController> {
  final int index;

  //
  // final List cartItem;
  final Map
      cartInfo; //{'category_id': '', 'category_name' : '', 'category_checked' : true, 'category_items' : []}

  final String pageName; // register - 수선 접수 페이지

  const CartListItem(
      {Key? key,
      required this.cartInfo,
      // required this.cartItem,
      required this.index,
      this.pageName = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        cartInfo['category_name'],
                        // listItem.first.cartCategory,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    : checkBoxCustom(cartInfo['category_checked'],
                        cartInfo['category_name']),
                pageName == "register"
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          Get.to(() => ChooseClothes(
                                parentNum: cartInfo['category_id'],
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
                cartInfo['category_items'].length,
                (i) => FixTypeListItem(
                      index: i,
                      orderMetaData: cartInfo['category_items'][i]
                          ['order_meta_data'],
                      listIndex: cartInfo['category_items'].length,
                      parentIndex: index,
                      pageName: pageName != "" ? pageName : "",
                    )),
          ),
        ],
      ),
    );
  }

  // checkbox custom
  Widget checkBoxCustom(bool isChecked, String text) {
    return GestureDetector(
      onTap: () {
        controller.iscategoryChecked(index);
      },
      child: Container(
        child: Row(
          children: [
            Obx(
              () => !controller.cartItem[index]['category_checked']
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
