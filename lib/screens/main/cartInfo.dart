import 'package:async/async.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/models/tooltip_text.dart';
import 'package:needlecrew/widgets/visible_info.dart';
import 'package:needlecrew/modal/alertDialogYes.dart';
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

class CartInfo extends StatefulWidget {
  const CartInfo({Key? key}) : super(key: key);

  @override
  State<CartInfo> createState() => _CartInfoState();
}

class _CartInfoState extends State<CartInfo> with TickerProviderStateMixin {
  final CartController controller = Get.put(CartController());
  late final AnimationController animationController;


  // 비용 표시
  String setprice(int price){
    String formatPrice = NumberFormat('###,###,###').format(price >= 0 ? price : 0);
    return formatPrice;
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        FixClothesAppBar(
                          appbar: AppBar(),
                          prev: "옷바구니",
                        ),

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
                                      controller.deleteOrderIds();
                                      if (controller.orderid.length != 0) {
                                        Get.dialog(TearIconModal(
                                            title: "선택한 의뢰를 삭제할까요?",
                                            btnText1: "취소",
                                            btnText2: "삭제"));
                                      } else {
                                        Get.dialog(AlertDialogYes(
                                            titleText: "삭제할 의뢰를 선택해 주세요."));
                                      }
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
                                                controller.cartItem.length,
                                                (index) => CartListItem(
                                                  cartItem: controller.cartItem,
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
      bottomNavigationBar:
      FutureBuilder(
          future: myFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return controller.orders.length == 0
                  ? Container(
                      height: 0,
                    )
                  : Obx(
                      () => Container(
                        height: controller.visibility.value == true ? 248 : 140,
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
                              child: Obx(() => VisibleInfo(
                                      visible: controller.visibility.value,
                                      formInfo: [
                                        {
                                          "titleText": "선택한 의뢰 예상 비용",
                                          "tooltipText": cost.tooltipText,
                                          "targetText" : cost.boldText,
                                          "price": controller.cartItem.indexWhere((element) => element.cartWay == "직접 입력") != -1 ? setprice(controller.wholePrice.value-6000) + " ~ " : controller.wholePrice.value-6000 <= 0 && controller.cartItem.indexWhere((element) => element.cartWay == "직접 입력") != -1 ? " - " : setprice(controller.wholePrice.value-6000),
                                          "istooltip": true
                                        },
                                        {
                                          "titleText": "총 배송 비용",
                                          "tooltipText": ship.tooltipText,
                                          "targetText" : ship.boldText,
                                          "price": setprice(6000),
                                          "istooltip": true
                                        },
                                        {
                                          "titleText": "총 의뢰 예상 비용",
                                          "tooltipText": "",
                                          "targetText" : [""],
                                          "price": controller.cartItem.indexWhere((element) => element.cartWay == "직접 입력") != -1 ? controller.setPrice() + " ~ " : controller.setPrice(),

                                          "istooltip": false
                                        },
                                      ])),
                            ),
                            Container(
                              height: 20,
                              margin: EdgeInsets.only(bottom: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Obx(
                                      () => EasyRichText(
                                        "총 의뢰 예상 비용 : ${controller.cartItem.indexWhere((element) => element.cartWay == "직접 입력") != -1 ? controller.setPrice() + " ~ " : controller.setPrice()}원",
                                        defaultStyle: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'NotoSansCJKkrRegular',
                                          color: Colors.black,
                                        ),
                                        patternList: [
                                          EasyRichTextPattern(
                                            targetString: controller.setPrice(),
                                            style: TextStyle(
                                                color: HexColor("#fd9a03"),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => IconButton(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          if (controller.visibility.value ==
                                              true) {
                                            controller.visibility.value = false;
                                          } else {
                                            controller.visibility.value = true;
                                          }
                                        },
                                        icon: AnimatedBuilder(
                                          animation: animationController,
                                          child: controller.visibility.value
                                              ? SvgPicture.asset(
                                                  "assets/icons/dropdownIcon.svg",
                                                  color: HexColor("#909090"),
                                                  width: 14,
                                                  height: 8,
                                                )
                                              : SvgPicture.asset(
                                                  "assets/icons/dropdownupIcon.svg",
                                                  color: HexColor("#909090"),
                                                  width: 14,
                                                  height: 8,
                                                ),
                                          builder: (context, child) {
                                            return Transform.rotate(
                                              angle: animationController.value *
                                                  2.0 *
                                                  3.14,
                                              child: child,
                                            );
                                          },
                                        )),
                                  ),
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
        controller.iswholeChecked();
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
