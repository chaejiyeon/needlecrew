import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/controller/widget_controller/custom_widget_controller.dart';
import 'package:needlecrew/custom_bottom_btn.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/models/tooltip_text.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/fixClothes/choose_clothes.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/visible_info.dart';
import 'package:needlecrew/screens/main/nothing_info.dart';
import 'package:needlecrew/widgets/cartInfo/cart_list_item.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import 'fixClothes/address_insert.dart';

class CartInfo extends StatefulWidget {
  const CartInfo({Key? key}) : super(key: key);

  @override
  State<CartInfo> createState() => _CartInfoState();
}

class _CartInfoState extends State<CartInfo> with TickerProviderStateMixin {
  final CartController controller = Get.find();
  final CustomWidgetController widgetController = Get.put(
      CustomWidgetController(), tag: 'cart_info');

  // 비용 표시
  String setprice(int price) {
    String formatPrice =
    NumberFormat('###,###,###').format(price >= 0 ? price : 0);
    return formatPrice;
  }

  @override
  Widget build(BuildContext context) {
    controller.initialize();
    widgetController.isAnimated.value = true;

    return Scaffold(
        body: Obx(() {
          if (controller.isLoading.value) {
            return Obx(() =>
            controller.cartItem.isEmpty
                ? NothingInfo(title: "옷바구니", subtitle: "담겨있는 옷이 없습니다.")
                : Container(
              color: Colors.white,
              child: Column(
                children: [
                  // appbar
                  CustomAppbar(
                    leadingWidget: BackBtn(),
                    appbarcolor: 'white',
                    appbar: AppBar(),
                    actionItems: [
                      AppbarItem(
                        icon: 'homeIcon.svg',
                        iconColor: Colors.black,
                        iconFilename: 'main',
                        function: () {
                          Get.close(1);
                          Get.to(MainPage(pageNum: 0));
                        },
                      ),
                      // AppbarItem(
                      //   icon: 'cartIcon.svg',
                      //   iconColor: Colors.black,
                      //   iconFilename: 'main',
                      //   widget: CartInfo(),
                      // ),
                      AppbarItem(
                        icon: 'alramIcon.svg',
                        iconColor: Colors.black,
                        iconFilename: 'main',
                        widget: AlramInfo(),

                      ),
                    ],
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
                                // controller.deleteOrderIds;
                                Get.dialog(
                                    barrierDismissible: false,
                                    CustomDialog(header: DialogHeader(
                                      title: '선택한 의뢰를 삭제할까요?',
                                      btnIcon: 'tearIcon.svg',
                                    ),
                                      bottom: DialogBottom(
                                          isExpanded: true, btn: [
                                        BtnModel(text: '취소',
                                            callback: () => Get.back()),
                                        BtnModel(text: '삭제',
                                            callback: () async {
                                              await controller.deleteCart(
                                                  "many", null);
                                              await controller.deleteImage();
                                            })

                                      ]),)
                                );
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      "assets/icons/trashIcon.svg"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                    text: '선택 삭제', fontSize: FontSize().fs4,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 24.w, right: 24.w),
                      color: HexColor("#f7f7f7"),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 20),
                        child:
                        Obx(
                              () =>
                              Column(
                                children: List.generate(
                                  controller.cartItem.length,
                                      (index) =>
                                      CartListItem(
                                        cartInfo: controller.cartItem[index],
                                        // cartItem:
                                        // controller.cartItem,
                                        index: index,
                                      ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),)
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
        // FutureBuilder(
        //   future: controller.getCart(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       printInfo(
        //           info: 'get cart items =========== ${controller.cartItem}');
        //
        //       return controller.cartItem.isEmpty
        //           ? NothingInfo(title: "옷바구니", subtitle: "담겨있는 옷이 없습니다.")
        //           : Container(
        //         color: Colors.white,
        //         child: Column(
        //           children: [
        //             // appbar
        //             CustomAppbar(
        //               leadingWidget: BackBtn(),
        //               appbarcolor: 'white',
        //               appbar: AppBar(),
        //               actionItems: [
        //                 AppbarItem(
        //                   icon: 'homeIcon.svg',
        //                   iconColor: Colors.black,
        //                   iconFilename: 'main',
        //                   widget: MainPage(pageNum: 0),
        //                 ),
        //                 AppbarItem(
        //                   icon: 'cartIcon.svg',
        //                   iconColor: Colors.black,
        //                   iconFilename: 'main',
        //                   widget: CartInfo(),
        //                 ),
        //                 AppbarItem(
        //                   icon: 'alramIcon.svg',
        //                   iconColor: Colors.black,
        //                   iconFilename: 'main',
        //                   widget: AlramInfo(),
        //                 ),
        //               ],
        //             ),
        //             // 옷바구니
        //             Container(
        //               padding: EdgeInsets.all(20),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   FontStyle(
        //                       text: "옷바구니",
        //                       fontsize: "lg",
        //                       fontbold: "bold",
        //                       fontcolor: Colors.black,
        //                       textdirectionright: false),
        //                   SizedBox(
        //                     height: 15,
        //                   ),
        //                   Row(
        //                     mainAxisAlignment:
        //                     MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       checkBoxCustom("전체 선택"),
        //                       GestureDetector(
        //                         behavior: HitTestBehavior.opaque,
        //                         onTap: () {
        //                           // controller.deleteOrderIds;
        //                           if (controller.orderid.length != 0) {
        //                             Get.dialog(TearIconModal(
        //                                 title: "선택한 의뢰를 삭제할까요?",
        //                                 btnText1: "취소",
        //                                 btnText2: "삭제"));
        //                           } else {
        //                             Get.dialog(AlertDialogYes(
        //                                 titleText: "삭제할 의뢰를 선택해 주세요."));
        //                           }
        //                         },
        //                         child: Row(
        //                           children: [
        //                             SvgPicture.asset(
        //                                 "assets/icons/trashIcon.svg"),
        //                             SizedBox(
        //                               width: 10,
        //                             ),
        //                             FontStyle(
        //                                 text: "선택 삭제",
        //                                 fontsize: "",
        //                                 fontbold: "",
        //                                 fontcolor: Colors.black,
        //                                 textdirectionright: false),
        //                           ],
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //
        //             Expanded(
        //               child: Container(
        //                 padding: EdgeInsets.only(left: 24.w, right: 24.w),
        //                 color: HexColor("#f7f7f7"),
        //                 child: SingleChildScrollView(
        //                   padding: EdgeInsets.only(top: 20),
        //                   child:
        //                   // Obx(
        //                   //       () =>
        //                   Column(
        //                     children: List.generate(
        //                       controller.cartItem.length,
        //                           (index) =>
        //                           CartListItem(
        //                             cartInfo: controller.cartItem[index],
        //                             // cartItem:
        //                             // controller.cartItem,
        //                             index: index,
        //                           ),
        //                       // ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     } else {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //   },
        // ),

        // 고정 bottom navigation
        bottomNavigationBar:
        // CostBottomNavigation(),
        Obx(() =>
        controller.cartItem.isEmpty
            ? Container(
          height: 0,
        )
            : Obx(
              () =>
              CustomBottomBtn(
                formName: 'cart_info',
                formHeight: controller.visibility.value ? 250.h : 148.h,
                visibleWidget: Obx(() =>
                    VisibleInfo(
                        visible: controller.visibility.value,
                        formInfo: [
                          {
                            "titleText": "선택한 의뢰 예상 비용",
                            "tooltipText": cost.tooltipText,
                            "targetText": cost.boldText,
                            "price": controller.cartItem.any((element) =>
                                element['category_items']
                                    .any((Map e) =>
                                    e.containsValue(
                                        '직접입력')))
                                ? setprice(
                                controller.wholePrice.value) +
                                " ~ "
                                : controller.wholePrice.value <=
                                0 &&
                                controller.cartItem.any((element) =>
                                    element['category_items'].any((Map e) =>
                                        e.containsValue('직접입력')))
                                ? " - "
                                : setprice(
                                controller.wholePrice.value),
                            "istooltip": true
                          },
                          {
                            "titleText": "총 배송 비용",
                            "tooltipText": ship.tooltipText,
                            "targetText": ship.boldText,
                            "price": setprice(6000),
                            "istooltip": true
                          },
                          {
                            "titleText": "총 의뢰 예상 비용",
                            "tooltipText": "",
                            "targetText": [""],
                            "price": controller.cartItem.any((element) =>
                                element['category_items'].any((Map e) =>
                                    e.containsValue('직접입력')))
                                ? FormatMethod().convertPrice(
                                price: controller.wholePrice.value) +
                                " ~ "
                                : FormatMethod().convertPrice(
                                price: controller.wholePrice.value),
                            "istooltip": false
                          },
                        ])),
                infoWidget: Obx(
                      () =>
                      EasyRichText(
                        "총 의뢰 예상 비용 : ${controller.cartItem.any((element) =>
                            element['category_items'].any((Map e) =>
                                e.containsValue('직접입력'))) ? FormatMethod()
                            .convertPrice(
                            price: controller.wholePrice.value + 6000) +
                            " ~ " : FormatMethod().convertPrice(
                            price: controller.wholePrice.value + 6000)}원",
                        defaultStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'NotoSansCJKkrRegular',
                          color: Colors.black,
                        ),
                        patternList: [
                          EasyRichTextPattern(
                            targetString: FormatMethod().convertPrice(
                                price: controller.wholePrice.value + 6000),
                            style: TextStyle(
                                color: HexColor("#fd9a03"),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                ),
                btnItems: [
                  BtnModel(
                      text: '총 ${controller.orderCount.toString()} 건 의뢰 진행하기',
                      textSize: FontSize().fs6,
                      borderColor: controller.orderCount.value == 0
                          ? SetColor().colorD5
                          : SetColor().mainColor,
                      btnColor: controller.orderCount.value == 0
                          ? SetColor().colorD5
                          : SetColor().mainColor,
                      callback: () {
                        if (controller.orderCount.value != 0) {
                          Get.dialog(barrierDismissible: false,
                              CustomDialog(
                                headerWidget: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 24.w,
                                      height: 24.h,
                                      margin: EdgeInsets.only(bottom: 8.h),
                                      child: SvgPicture.asset(
                                          'assets/icons/defaultXmark.svg',
                                          width: 13.w,
                                          height: 13.h,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                header: DialogHeader(
                                  title: '다른 의류는 수선이 필요없으신가요?',
                                  content: "필요없으시다면 '다음 단계'를 눌러주세요!",),
                                bottom: DialogBottom(isExpanded: true, btn: [
                                  BtnModel(callback: () {
                                    Get.to(ChooseClothes());
                                  }, text: '수선할게요!'),
                                  BtnModel(callback: () {
                                    controller.setRegisterOrder();
                                    Get.off(() => AddressInsert());
                                  },
                                      text: '다음단계',
                                      textColor: SetColor().mainColor),
                                ]),));
                        }
                      })
                ],
                iconFt: () {
                  if (widgetController.isAnimated.value) {
                    controller.visibility.value = false;
                  } else {
                    controller.visibility.value = true;
                  }
                },
              ),
        )
        )
    );
  }

  // checkbox custom
  Widget checkBoxCustom(String text) {
    return GestureDetector(
      onTap: () {
        controller.isWholeChecked();
      },
      child:
      Container(
        child: Obx(
              () =>
              Row(
                children: [
                  controller.allSelectCategory.value == false
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
