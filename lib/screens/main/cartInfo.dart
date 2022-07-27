import 'package:needlecrew/modal/tearIconModal.dart';
import 'package:needlecrew/modal/cartInfoModal.dart';
import 'package:needlecrew/screens/main/nothingInfo.dart';
import 'package:needlecrew/widgets/cartInfo/cartListItem.dart';
import 'package:needlecrew/widgets/circleLineBtn.dart';
import 'package:needlecrew/widgets/fixClothes/fixClothesAppbar.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../getxController/fixClothes/cartController.dart';

class CartInfo extends GetView <CartController> {
  const CartInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());

    Future myFuture = controller.getCart();

    print("register orders id info " + controller.orders.length.toString());

    return Scaffold(
      body: FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return controller.orders.length == 0
                ? NothingInfo(title: "옷바구니", subtitle: "담겨있는 옷이 없습니다.")
                : Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        // appbar
                        FixClothesAppBar(appbar: AppBar()),

                        // 옷바구니
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FontStyle(
                                  text: "옷바구니",
                                  fontsize: "lg",
                                  fontbold: "bold",
                                  fontcolor: Colors.black,
                                  textdirectionright: false),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  checkBoxCustom("전체 선택"),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Get.dialog(TearIconModal(
                                          title: "선택한 의뢰를 삭제할까요?",
                                          btnText1: "취소",
                                          btnText2: "삭제"));
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/trashIcon.svg"),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        FontStyle(
                                            text: "선택 삭제",
                                            fontsize: "",
                                            fontbold: "",
                                            fontcolor: Colors.black,
                                            textdirectionright: false),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                            future: controller.getCart(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                print("주문건수 " +
                                    controller.orders.length.toString());

                                return Expanded(
                                  child: controller.orders.length == 0
                                      ? NothingInfo(
                                          title: "옷바구니",
                                          subtitle: "담겨있는 옷이 없습니다.",
                                        )
                                      : Container(
                                          padding: EdgeInsets.only(
                                              left: 24, right: 24),
                                          color: HexColor("#f7f7f7"),
                                          child: SingleChildScrollView(
                                            padding: EdgeInsets.only(top: 20),
                                            child: Column(
                                              children: List.generate(
                                                controller.cartListitem.length,
                                                (index) => CartListItem(
                                                  cartItem: controller.cartListitem[index],
                                                  index: index,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      ],
                    ),
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

      // 고정 bottom navigation
      bottomNavigationBar: FutureBuilder(
          future: myFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return controller.orders.length == 0
                  ? Container(
                      height: 0,
                    )
                  : GestureDetector(
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      FontStyle(
                                          text: "총 의뢰 예상 비용 : ",
                                          fontsize: "",
                                          fontbold: "",
                                          fontcolor: Colors.black,
                                          textdirectionright: false),
                                      Obx(() => FontStyle(
                                          text: controller.setPrice(),
                                          fontsize: "md",
                                          fontbold: "bold",
                                          fontcolor: HexColor("#fd9a03"),
                                          textdirectionright: false)),
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
                            Obx(() => CircleLineBtn(
                                  btnText: "총 " +
                                      controller.orderCount.toString() +
                                      " 건 의뢰 진행하기",
                                  fontboxwidth: double.infinity,
                                  bordercolor: controller.orderCount.value == 0
                                      ? HexColor("#d5d5d5")
                                      : HexColor("#fd9a03"),
                                  fontcolor: Colors.white,
                                  fontsize: "md",
                                  btnIcon: "",
                                  btnColor: controller.orderCount.value == 0
                                      ? HexColor("#d5d5d5")
                                      : HexColor("#fd9a03"),
                                  widgetName: CartInfoModal(),
                                  fontboxheight: "",
                                  iswidget: false,
                                )),
                          ],
                        ),
                      ),
                    );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  // checkbox custom
  Widget checkBoxCustom(String text) {
    return GestureDetector(
      onTap: () {
        if (controller.isWholechecked.value == false) {
          controller.isWholechecked.value = true;
        } else {
          controller.isWholechecked.value = false;
        }
      },
      child: Obx(
        () => Container(
          child: Row(
            children: [
              controller.isWholechecked.value == false
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
}
