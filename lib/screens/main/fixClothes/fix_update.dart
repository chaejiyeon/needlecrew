import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/order_payload.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/controller/fix_clothes/fixselect_controller.dart';
import 'package:needlecrew/controller/my_use_info/useInfo_controller.dart';
import 'package:needlecrew/controller/widget_controller/custom_widget_controller.dart';
import 'package:needlecrew/custom_bottom_btn.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/functions.dart';
import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/fixClothes/image_upload.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/radio_btn.dart';
import 'package:needlecrew/widgets/fixClothes/circle_line_text_field.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class FixUpdate extends StatefulWidget {
  final OrderMetaData orderMetaData;

  const FixUpdate({Key? key, required this.orderMetaData}) : super(key: key);

  @override
  State<FixUpdate> createState() => _FixUpdateState();
}

class _FixUpdateState extends State<FixUpdate> {
  final CartController cartController = Get.find();
  final FixSelectController fixselectController =
      Get.put(FixSelectController());
  final UseInfoController useInfoController = Get.find();
  final CustomWidgetController widgetController =
      Get.put(CustomWidgetController(), tag: 'order_update');

  List editingControllers = [
    {
      '치수 입력': TextEditingController(),
      '물품 가액': TextEditingController(),
      '추가 설명': TextEditingController(),
      '수거 주소': TextEditingController(),
      '수거 희망일': TextEditingController()
    }
  ];

  List delImg = [];

  getOrder() async {
    useInfoController.updateOrderId.value = widget.orderMetaData.orderId!;

    var result = await useInfoController.getFixInfo();
    if (await cartController.getVariation(widget.orderMetaData.productId!)) {
      if (cartController.variation.isNotEmpty) {
        printInfo(
            info:
                'cart controller variation this ${cartController.variation} ${widget.orderMetaData.variationId}');
        fixselectController.radioGroup['variation_id'] =
            widget.orderMetaData.variationId;
        fixselectController.radioId.value = widget.orderMetaData.variationId!;
        fixselectController.radioGroup['추가 옵션'] = Functions().cvtOptionName(
            cartController.variation[cartController.variation.indexWhere(
                (element) => element.id == widget.orderMetaData.variationId)]);

        fixselectController.wholePrice.value = int.parse(cartController
                .variation[cartController.variation.indexWhere((element) =>
                    element.id == widget.orderMetaData.variationId)]
                .price!) +
            6000;
      }
    }

    if (result) {
      fixselectController.isSelected.value = widget.orderMetaData.cartWay!;
      fixselectController.setImages.value = widget.orderMetaData.cartImages!;
      editingControllers[editingControllers
              .indexWhere((element) => element.containsKey('치수 입력'))]['치수 입력']
          .text = widget.orderMetaData.cartSize;
      editingControllers[editingControllers
              .indexWhere((element) => element.containsKey('물품 가액'))]['물품 가액']
          .text = widget.orderMetaData.guaranteePrice;
      editingControllers[editingControllers
              .indexWhere((element) => element.containsKey('추가 설명'))]['추가 설명']
          .text = widget.orderMetaData.cartContent;
      editingControllers[editingControllers
              .indexWhere((element) => element.containsKey('수거 주소'))]['수거 주소']
          .text = useInfoController.order.shipping?.address1;
      editingControllers[editingControllers
              .indexWhere((element) => element.containsKey('수거 희망일'))]['수거 희망일']
          .text = useInfoController.orderMetaData['수거 희망일'] ?? '';
    }
  }

  @override
  void initState() {
    delImg.clear();

    print("widget cart prpoductId this" +
        widget.orderMetaData.productId.toString());

    getOrder();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppbar(
            leadingWidget: BackBtn(),
            appbarcolor: 'white',
            appbar: AppBar(),
            actionItems: [
              AppbarItem(
                icon: 'homeIcon.svg',
                iconColor: Colors.black,
                iconFilename: 'main',
                widget: MainPage(pageNum: 0),
              ),
              AppbarItem(
                icon: 'cartIcon.svg',
                iconColor: Colors.black,
                iconFilename: 'main',
                widget: CartInfo(),
              ),
              AppbarItem(
                icon: 'alramIcon.svg',
                iconColor: Colors.black,
                iconFilename: 'main',
                widget: AlramInfo(),
              ),
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  child: FontStyle(
                      text: "의뢰 수정",
                      fontsize: "lg",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      // 사진 업로드
                      Container(
                        padding: EdgeInsets.only(top: 14.h),
                        child: ImageUpload(
                            icon: "cameraIcon.svg", isShopping: false),
                      ),

                      // 의뢰 방법
                      Container(
                        margin: EdgeInsets.only(top: 40.h, bottom: 40.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FontStyle(
                                text: "치수 표기 방법",
                                fontsize: "md",
                                fontbold: "bold",
                                fontcolor: Colors.black,
                                textdirectionright: false),
                            SizedBox(
                              height: 10,
                            ),
                            RadioBtn(
                                list: "원하는 총 기장 길이 입력",
                                bottomPadding: 15,
                                textBold: ""),
                            RadioBtn(
                                list: "완성 치수를 입력할게요.",
                                bottomPadding: 15,
                                textBold: ""),
                            RadioBtn(
                                list: "잘 맞는 옷을 함께 보낼게요.",
                                bottomPadding: 15,
                                textBold: ""),
                          ],
                        ),
                      ),

                      // 치수 입력
                      textForm(
                          titleText: "치수 입력",
                          hintText: widget.orderMetaData.cartSize!,
                          hintColor: Colors.black,
                          isxmark: true,
                          keyboardType: TextInputType.number),

                      // 물품 가액
                      textForm(
                          titleText: "물품 가액",
                          hintText: widget.orderMetaData.guaranteePrice!,
                          hintColor: Colors.black,
                          isxmark: false,
                          keyboardType: TextInputType.number),

                      Container(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "• ",
                              style: TextStyle(color: HexColor("#aaaaaa")),
                            ),
                            Expanded(
                              child: Text(
                                "물품가액은 배송 사고시 보상의 기준이 되며, 허위 기재 시 배송과정에서 불이익이 발생할 수 있으니 실제 물품의 가치를 정확히 기재해주시기 바랍니다.",
                                style: TextStyle(color: HexColor("#aaaaaa")),
                              ),
                            )
                          ],
                        ),
                      ),

                      // 추가 설명
                      Container(
                        margin: EdgeInsets.only(top: 40.h, bottom: 40.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FontStyle(
                                text: "추가 설명",
                                fontsize: "md",
                                fontbold: "bold",
                                fontcolor: Colors.black,
                                textdirectionright: false),
                            SizedBox(
                              height: 10,
                            ),
                            CircleLineTextField(
                                controller: editingControllers[
                                    editingControllers.indexWhere((element) =>
                                        element.containsKey('추가 설명'))]['추가 설명'],
                                maxLines: 10,
                                hintText: widget.orderMetaData.cartContent!,
                                hintTextColor: Colors.black,
                                borderRadius: 10,
                                borderSideColor: HexColor("#d5d5d5"),
                                widthOpacity: true),
                          ],
                        ),
                      ),

                      // 추가 옵션
                      Obx(
                        () => cartController.variation.length != 0
                            ? Container(
                                margin: EdgeInsets.only(bottom: 40),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: FontStyle(
                                            text: "추가 옵션",
                                            fontsize: "md",
                                            fontbold: "bold",
                                            fontcolor: Colors.black,
                                            textdirectionright: false),
                                      ),
                                      Column(
                                        children: List.generate(
                                            cartController.variation.length,
                                            (index) => optionItem(cartController
                                                .variation[index])),
                                      ),
                                    ]),
                              )
                            : Container(),
                      ),

                      // 수거 주소 - 이용내역 > 접수 완료 후 의뢰 수정 시 표시
                      textForm(
                          titleText: "수거 주소",
                          hintColor: Colors.black,
                          isxmark: false),
                      textForm(
                          titleText: "수거 희망일",
                          hintColor: Colors.black,
                          isxmark: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomBtn(
            formName: 'order_update',
            infoWidget: Obx(
              () => EasyRichText(
                  '총 의뢰 예상 비용 : ${fixselectController.wholePrice}원',
                  patternList: [
                    EasyRichTextPattern(
                        targetString: '${fixselectController.wholePrice}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: SetColor().mainColor))
                  ]),
            ),
            btnItems: [
              BtnModel(
                  text: '취소',
                  textSize: FontSize().fs6,
                  textColor: Colors.black,
                  btnColor: Colors.white,
                  borderColor: SetColor().colorD5,
                  callback: () => Get.close(1)),
              BtnModel(
                  text: '수정 완료',
                  textSize: FontSize().fs6,
                  btnColor: SetColor().mainColor,
                  borderColor: SetColor().mainColor,
                  callback: () async {
                    if (await orderServices
                        .updateOrder(useInfoController.order.id!, {
                      'line_items': [
                        LineItems(
                            productId: useInfoController
                                .order.lineItems!.first.productId!,
                            variationId:
                                fixselectController.radioGroup['variation_id'],
                            quantity: 1)
                      ],
                      'shipping': {
                        'address_1': editingControllers[
                                editingControllers.indexWhere((element) =>
                                    element.containsKey('수거 주소'))]['수거 주소']
                            .text
                      },
                      'meta_data': [
                        {
                          'key': '치수',
                          'value': editingControllers[
                                  editingControllers.indexWhere((element) =>
                                      element.containsKey('치수 입력'))]['치수 입력']
                              .text
                        },
                        {
                          'key': '수거 희망일',
                          'value': editingControllers[
                                  editingControllers.indexWhere((element) =>
                                      element.containsKey('수거 희망일'))]['수거 희망일']
                              .text
                        },
                        // {
                        //   'key': '추가 설명',
                        //   'value': editingControllers[
                        //           editingControllers.indexWhere((element) =>
                        //               element.containsKey('추가 설명'))]['추가 설명']
                        //       .text
                        // },
                        {
                          'key': '의뢰 방법',
                          'value': fixselectController.isSelected.value
                        }
                      ],
                      '추가 설명': editingControllers[editingControllers.indexWhere(
                                  (element) => element.containsKey('추가 설명'))]
                              ['추가 설명']
                          .text
                    })) {
                      if (await fixselectController.uploadImage()) {
                        if (await fixselectController
                            .delImage(useInfoController.delImgs)) {
                          // await useInfoController.getCompleteOrder();
                          Get.close(1);
                        }
                      }
                    }
                  })
            ],
          )),
    );
  }

  // bottomNavigationbar button
  Widget bottomBtn(String btnText) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      width: MediaQuery.of(context).size.width * 0.4,
      height: 54,
      decoration: BoxDecoration(
          color: btnText == "취소" ? Colors.white : HexColor("#fd9a03"),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color:
                  btnText == "취소" ? HexColor("#d5d5d5") : HexColor("#fd9a30"))),
      child: TextButton(
        onPressed: () {},
        child: Text(
          btnText,
          style: TextStyle(
              color: btnText == "취소" ? Colors.black : Colors.white,
              fontSize: 16),
        ),
      ),
    );
  }

  // textForm
  Widget textForm(
      {String titleText = '',
      String hintText = '',
      Color hintColor = Colors.black,
      bool isxmark = false,
      dynamic keyboardType}) {
    return Container(
      margin: EdgeInsets.only(bottom: titleText == '수거 희망일' ? 100.h : 40.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FontStyle(
                  text: titleText,
                  fontsize: "md",
                  fontbold: "bold",
                  fontcolor: Colors.black,
                  textdirectionright: false),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 54.h,
            child: TextFormField(
              keyboardType: keyboardType,
              controller: editingControllers[editingControllers.indexWhere(
                  (element) => element.containsKey(titleText))][titleText],
              decoration: InputDecoration(
                hintText: hintText,
                hintMaxLines: 2,
                hintStyle: TextStyle(color: hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: HexColor("#d5d5d5"),
                  ),
                ),
                suffixIcon: isxmark == true
                    ? IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "assets/icons/xmarkIcon_full_acolor.svg",
                          height: 18,
                          width: 18,
                        ),
                      )
                    : titleText == "물품 가액"
                        ? Container(
                            padding: EdgeInsets.only(top: 10, right: 10),
                            child: Text(
                              "원",
                              textAlign: TextAlign.right,
                            ),
                          )
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // optionItem custom
  Widget optionItem(WooProductVariation variation) {
    print("variation " + variation.attributes[0].option.toString());

    // 디코딩된 옵션이름 변환
    var optionName = Functions().cvtOptionName(variation);

    // 원 가격
    int currentPrice = int.parse(widget.orderMetaData.productPrice!);
    print("currentPrice" + currentPrice.toString());

    // optin 추가 된 가격
    int addPrice = int.parse(variation.price!);
    print("addPrice" + addPrice.toString());

    // 추가 될 가격
    int finalPrice = addPrice - currentPrice;

    return Obx(
      () => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomRadioWidget(
              optionname: cartController.name(optionName),
              groupValue: variation.id!,
              value: fixselectController.radioId.value,
              onChanged: (value) {
                fixselectController.isRadioGroup({
                  'variation_id': variation.id!,
                  '추가 옵션': cartController.name(optionName),
                  '가격': finalPrice.toString()
                });
                fixselectController.radioId.value = variation.id!;
                fixselectController.iswholePrice(addPrice);
              },
            ),
            Row(
              children: [
                FontStyle(
                    text: "+" + finalPrice.toString(),
                    fontsize: "md",
                    fontbold: "bold",
                    fontcolor: Colors.black,
                    textdirectionright: false),
                FontStyle(
                    text: "원",
                    fontsize: "md",
                    fontbold: "",
                    fontcolor: Colors.black,
                    textdirectionright: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// radio cucstom
class CustomRadioWidget<T> extends StatelessWidget {
  final String optionname;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  CustomRadioWidget({
    required this.optionname,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(this.value);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: [
            Container(
                width: 22,
                height: 22,
                child: value == groupValue
                    ? Image.asset("assets/icons/selectCheckIcon.png")
                    : Image.asset("assets/icons/checkBtnIcon.png")),
            SizedBox(
              width: 10,
            ),
            Text(optionname),
          ],
        ),
      ),
    );
  }
}
