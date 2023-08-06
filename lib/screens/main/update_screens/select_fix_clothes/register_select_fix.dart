import 'dart:convert';
import 'dart:developer';

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/order_payload.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/fix_clothes/fixselect_controller.dart';
import 'package:needlecrew/controller/page_controller/select_clothes_type_controller.dart';
import 'package:needlecrew/controller/widget_controller/custom_text_field_controller.dart';
import 'package:needlecrew/controller/widget_controller/custom_widget_controller.dart';
import 'package:needlecrew/custom_bottom_btn.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/models/tooltip_text.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_question.dart';
import 'package:needlecrew/screens/main/fixClothes/image_upload.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/header.dart';
import 'package:needlecrew/widgets/fixClothes/progress_bar.dart';
import 'package:needlecrew/widgets/fixClothes/radio_btn.dart';
import 'package:needlecrew/widgets/tootip_custom.dart';

class RegisterSelectFix extends GetView<SelectClothesTypeController> {
  const RegisterSelectFix({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FixSelectController fixSelectController = Get.find();
    final CustomWidgetController customWidgetController =
    Get.put(CustomWidgetController(), tag: 'register_select_fix');
    final CustomTextFieldController customTextFieldController =
    Get.put(CustomTextFieldController(), tag: 'register_select_fix');

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fixSelectController.setImages.clear();
      fixSelectController.getImages.clear();
      fixSelectController.setImages.refresh();
      fixSelectController.getImages.refresh();
      fixSelectController.uploadImg.value = '';

      orderServices.isPressed.value = false;
      controller.selectWholePrice.value =
          int.parse(controller.productInfo['product'].price);

      customTextFieldController.setInit(controller.registerController);
      fixSelectController
          .setGetMySize(controller.productInfo['product'].name.toString());
    });

    log(
        'register select fix init============== images length ${fixSelectController
            .getImages.length} ${fixSelectController.setImages.length}');
    return GestureDetector(
      onTap: () {
        customTextFieldController.formFocus.value.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppbar(
          leadingWidget: BackBtn(
            backFt: () {
              Get.close(1);
            },
          ),
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
        body: Obx(
              () =>
          controller.productInfo['product_category_info'] == null
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Container(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // progressbar
                    Container(
                      alignment: Alignment.topLeft,
                      child:
                      ProgressBar(progressImg: "fixProgressbar_2.svg"),
                    ),
                    // header
                    Header(
                      title: "수선 선택",
                      subtitle1: "",
                      question: true,
                      btnIcon: "rollIcon.svg",
                      btnText: "치수 측정 가이드",
                      widget: FixQuestion(),
                      imgPath: "fixClothes",
                      bottomPadding: 35,
                    ),
                    // 선택한 제품 정보
                    Container(
                      padding: EdgeInsets.only(bottom: 38.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                                () =>
                                CustomText(
                                    text: controller
                                        .productInfo['product_category_info']
                                        .name
                                        .toString(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontSize().fs6),
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                    () =>
                                    CustomText(
                                        text: controller
                                            .productInfo['product'].name
                                            .toString(),
                                        fontSize: FontSize().fs4),
                              ),
                              Obx(
                                    () =>
                                    EasyRichText(
                                      '${FormatMethod().convertPrice(
                                          price: int.parse(
                                              controller.productInfo['product']
                                                  .price))}원',
                                      patternList: [
                                        EasyRichTextPattern(
                                            targetString: FormatMethod()
                                                .convertPrice(
                                                price: int.parse(controller
                                                    .productInfo['product']
                                                    .price)),
                                            style: TextStyle(
                                                color: SetColor().mainColor,
                                                fontSize: FontSize().fs6,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    // 수량 선택
                    Obx(
                          () =>
                      controller.lastCategoryName.value == '기타'
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            formMargin: EdgeInsets.only(bottom: 17.h),
                            text: '수량 선택',
                            fontSize: FontSize().fs6,
                            fontWeight: FontWeight.bold,
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 40.h),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (controller.selectCount.value >
                                        1) {
                                      controller.selectCount.value--;
                                      controller.selectWholePrice
                                          .value = int.parse(
                                          controller
                                              .productInfo[
                                          'product']
                                              .price) *
                                          controller
                                              .selectCount.value;
                                    }
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: 40.w,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                              SetColor().colorD5),
                                          borderRadius:
                                          BorderRadius.circular(
                                              4)),
                                      child: Text(
                                        String.fromCharCode(
                                            CupertinoIcons
                                                .minus.codePoint),
                                        style: TextStyle(
                                            color: SetColor().color70,
                                            fontWeight:
                                            FontWeight.bold,
                                            fontFamily: CupertinoIcons
                                                .minus.fontFamily,
                                            package: CupertinoIcons
                                                .minus.fontPackage),
                                      )),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 30.w, right: 30.w),
                                  child: Obx(
                                        () =>
                                        CustomText(
                                            text: controller
                                                .selectCount.value
                                                .toString(),
                                            fontSize: FontSize().fs6),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.selectCount.value++;
                                    controller.selectWholePrice
                                        .value = int.parse(controller
                                        .productInfo['product']
                                        .price) *
                                        controller.selectCount.value;
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: 40.w,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                              SetColor().colorD5),
                                          borderRadius:
                                          BorderRadius.circular(
                                              4)),
                                      child: Text(
                                        String.fromCharCode(
                                            CupertinoIcons
                                                .plus.codePoint),
                                        style: TextStyle(
                                            color: SetColor().color70,
                                            fontWeight:
                                            FontWeight.bold,
                                            fontFamily: CupertinoIcons
                                                .plus.fontFamily,
                                            package: CupertinoIcons
                                                .plus.fontPackage),
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                          : Container(),
                    ),
                    // 참고사항 - 기타일 경우에만 표시
                    Obx(
                          () =>
                      FormatMethod().convertHtmlToText(controller
                          .productInfo['product']
                          .description) !=
                          '' &&
                          (!FormatMethod()
                              .convertHtmlToText(controller
                              .productInfo['product']
                              .description)
                              .contains('0') &&
                              FormatMethod()
                                  .convertHtmlToText(controller
                                  .productInfo['product']
                                  .description)
                                  .length >
                                  1)
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            formMargin: EdgeInsets.only(bottom: 10.h),
                            text: '참고 사항',
                            fontSize: FontSize().fs6,
                            fontWeight: FontWeight.bold,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 11.h,
                              right: 13.w,
                              left: 15.w,
                            ),
                            margin: EdgeInsets.only(bottom: 40.h),
                            decoration: BoxDecoration(
                                color: SetColor().colorF7,
                                borderRadius:
                                BorderRadius.circular(6)),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                    'assets/icons/fixClothes/pointIcon.svg'),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Expanded(
                                    child: Obx(
                                          () =>
                                          CustomText(
                                              textOverflow: null,
                                              textMaxLines: null,
                                              textAlign: TextAlign.start,
                                              text: FormatMethod()
                                                  .convertHtmlToText(
                                                  controller
                                                      .productInfo[
                                                  'product']
                                                      .description),
                                              fontSize: FontSize().fs2),
                                    ))
                              ],
                            ),
                          )
                        ],
                      )
                          : Container(),
                    ),
                    // 추가 옵션
                    Obx(
                          () =>
                      controller.productInfo['variation'] != null &&
                          controller.productInfo['variation'].isNotEmpty
                          ? Container(
                        margin: EdgeInsets.only(bottom: 40.h),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              formMargin:
                              EdgeInsets.only(bottom: 15.h),
                              text: '추가 옵션',
                              fontSize: FontSize().fs6,
                              fontWeight: FontWeight.bold,
                            ),
                            Obx(
                                  () =>
                                  Column(
                                      children: List.generate(
                                          controller
                                              .productInfo['variation']
                                              .length,
                                              (index) =>
                                              optionItem(
                                                  controller.productInfo[
                                                  'variation'][index]))),
                            )
                          ],
                        ),
                      )
                          : Container(),
                    ),
                    // 의뢰 방법
                    Obx(
                          () =>
                      controller.lastCategoryName.value != '기타'
                          ? Container(
                        padding: EdgeInsets.only(bottom: 41.h),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              formMargin:
                              EdgeInsets.only(bottom: 17.h),
                              text: '의뢰 방법',
                              fontSize: FontSize().fs6,
                              fontWeight: FontWeight.bold,
                            ),
                            RadioBtn(
                                list: '원하는 총 기장 길이 입력',
                                bottomPadding: 15,
                                textBold: ''),
                            RadioBtn(
                                list: '완성 치수를 입력할게요.',
                                bottomPadding: 15,
                                textBold: ''),
                            Obx(
                                  () =>
                              fixSelectController.isshopping !=
                                  true
                                  ? RadioBtn(
                                  list: '잘 맞는 옷을 함께 보낼게요.',
                                  bottomPadding: 15,
                                  textBold: '')
                                  : Container(),
                            ),
                          ],
                        ),
                      )
                          : Container(),
                    ),

                    // 치수 입력
                    Obx(
                          () =>
                      controller.lastCategoryName.value != '기타' &&
                          (fixSelectController.isshopping.value ||
                              fixSelectController.isSelected.value !=
                                  '잘 맞는 옷을 함께 보낼게요.')
                          ? customTextForm(
                        null,
                        '치수 입력',
                        GestureDetector(
                          onTap: () {
                            Get.dialog(
                                barrierDismissible: false,
                                Obx(
                                      () =>
                                      CustomDialog(
                                        header: DialogHeader(
                                            title: '내 치수를 불러오시겠습니까?',
                                            content:
                                            '총 길이 : ${fixSelectController
                                                .selectSize.value
                                                .toString()}cm'),
                                        bottom: DialogBottom(
                                            isExpanded: true,
                                            btn: [
                                              BtnModel(
                                                  text: '취소',
                                                  callback: () =>
                                                      Get.back()),
                                              BtnModel(
                                                  text: '불러오기',
                                                  callback: () {
                                                    customTextFieldController
                                                        .textFieldControllers[
                                                    customTextFieldController
                                                        .textFieldControllers
                                                        .indexWhere((element) =>
                                                    element['name'] ==
                                                        'size')]
                                                    [
                                                    'editing_controller']
                                                        .text =
                                                        fixSelectController
                                                            .selectSize
                                                            .value
                                                            .toString();
                                                    Get.close(1);
                                                  })
                                            ]),
                                      ),
                                ));
                          },
                          child: Row(
                            children: [
                              CustomText(
                                  text: '내 치수 불러오기',
                                  fontSize: FontSize().fs4),
                              Icon(
                                CupertinoIcons.chevron_forward,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        Obx(
                              () =>
                              CustomTextField(
                                controllerName: 'register_select_fix',
                                textEditingController:
                                customTextFieldController
                                    .textFieldControllers[
                                customTextFieldController
                                    .textFieldControllers
                                    .indexWhere((element) =>
                                element['name'] ==
                                    'size')]
                                ['editing_controller'],
                                focusNode: customTextFieldController
                                    .textFieldControllers[
                                customTextFieldController
                                    .textFieldControllers
                                    .indexWhere((element) =>
                                element['name'] ==
                                    'size')]['focus_node'],
                                textInputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'))
                                ],
                                suffixIcon: Container(
                                  padding: EdgeInsets.only(right: 17),
                                  child: Text("cm"),
                                ),
                                hintText: '의뢰 방법에 해당하는 치수를 입력해주세요.',
                              ),
                        ),
                      )
                          : Container(),
                    ),
                    // 사진 업로드
                    Container(
                      padding: EdgeInsets.only(bottom: 40.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            formMargin: EdgeInsets.only(bottom: 10.h),
                            text: '사진 업로드',
                            fontSize: FontSize().fs6,
                            fontWeight: FontWeight.bold,
                          ),
                          ImageUpload(
                              icon: 'cameraIcon.svg', isShopping: false)
                        ],
                      ),
                    ),
                    // 물품 가액
                    customTextForm(
                        EdgeInsets.only(bottom: 10.h),
                        '물품 가액',
                        null,
                        Obx(
                              () =>
                              CustomTextField(
                                controllerName: 'register_select_fix',
                                textEditingController: customTextFieldController
                                    .textFieldControllers[
                                customTextFieldController
                                    .textFieldControllers
                                    .indexWhere((element) =>
                                element['name'] ==
                                    'product_price')]
                                ['editing_controller'],
                                focusNode: customTextFieldController
                                    .textFieldControllers[
                                customTextFieldController
                                    .textFieldControllers
                                    .indexWhere((element) =>
                                element['name'] ==
                                    'product_price')]['focus_node'],
                                textInputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'))
                                ],
                                suffixIcon: Container(
                                  padding: EdgeInsets.only(right: 17),
                                  child: Text("원"),
                                ),
                                hintText: '수선물품의 가액을 입력해주세요.',
                              ),
                        )),
                    // 물품가액에 대한 설명
                    Container(
                      padding: EdgeInsets.only(
                          top: 11.h, right: 13.w, bottom: 17.h, left: 15.w),
                      margin: EdgeInsets.only(bottom: 40.h),
                      decoration: BoxDecoration(
                        color: SetColor().colorF7,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "* ",
                            style: TextStyle(
                                color: Colors.black, fontSize: 14),
                          ),
                          Expanded(
                            child: Text(
                              "물품가액은 배송 사고 및 수선 사고시 보장의 기준이 되며, 허위 기재 시 배송과정에서 불이익이 발생할 수 있으니 실제 물품의 가치를 정확히 기재해 주시기 바랍니다.",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 추가 설명
                    Container(
                      padding: EdgeInsets.only(bottom: 40.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            formMargin: EdgeInsets.only(bottom: 10.h),
                            text: '추가 설명',
                            fontSize: FontSize().fs6,
                            fontWeight: FontWeight.bold,
                          ),
                          Obx(
                                () =>
                                CustomTextField(
                                  contentPadding: EdgeInsets.only(
                                      left: 20.w, top: 17.h, right: 35.w),
                                  formHeight: 245.h,
                                  controllerName: 'register_select_fix',
                                  textEditingController:
                                  customTextFieldController
                                      .textFieldControllers[
                                  customTextFieldController
                                      .textFieldControllers
                                      .indexWhere((element) =>
                                  element['name'] ==
                                      'add_description')]
                                  ['editing_controller'],
                                  focusNode: customTextFieldController
                                      .textFieldControllers[
                                  customTextFieldController
                                      .textFieldControllers
                                      .indexWhere((element) =>
                                  element['name'] ==
                                      'add_description')]['focus_node'],
                                  maxLines: 10,
                                  maxLength: 300,
                                  hintText:
                                  "추가로 설명할 부분을 입력해주세요.\n\n예) 흰색 바지와 함께 보내는 옷입니다. 흰색 바지의 기장 참고해서 수선 부탁드릴게요!",
                                  counterStyle: TextStyle(
                                      color: customTextFieldController
                                          .textFieldControllers[
                                      customTextFieldController
                                          .textFieldControllers
                                          .indexWhere((element) =>
                                      element['name'] ==
                                          'add_description')]
                                      ['editing_controller']
                                          .text
                                          .length >=
                                          300
                                          ? Colors.red
                                          : SetColor().color76),
                                ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
        bottomNavigationBar: CustomBottomBtn(
          isNextBtn: true,
          formName: 'register_select_fix',
          nextWidget: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Obx(
                          () =>
                          EasyRichText(
                              '예상 비용 : ${FormatMethod().convertPrice(
                                  price: controller.selectWholePrice.value)}원',
                              defaultStyle: TextStyle(fontSize: FontSize().fs6),
                              patternList: [
                                EasyRichTextPattern(
                                    targetString: '예상 비용 : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                EasyRichTextPattern(
                                    targetString: FormatMethod().convertPrice(
                                        price: controller.selectWholePrice
                                            .value),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ))
                              ]),
                    ),
                    TooltipCustom(
                        tooltipText: cost.tooltipText,
                        titleText: '',
                        boldText: cost.boldText,
                        tailPosition: 'up',
                        iconColor: SetColor().color70),
                  ]),
                  Obx(
                        () =>
                        CustomNextBtn(
                          btnFt: () async {
                            if (fixSelectController.getImages.length == 0) {
                              Get.dialog(
                                  barrierDismissible: false,
                                  CustomDialog(
                                      header: DialogHeader(
                                        title: '이미지 등록',
                                        content: '이미지를 1장이상 등록해주세요!',
                                      ),
                                      bottom: DialogBottom(
                                          isExpanded: true, btn: [
                                        BtnModel(
                                          callback: () {
                                            Get.back();
                                          },
                                          text: '확인',
                                        )
                                      ])));
                            } else {
                              if (!orderServices.isPressed.value) {
                                orderServices.isPressed.value = true;
                                if (fixSelectController.getImages.length >= 1) {
                                  bool isUploaded =
                                  await fixSelectController.uploadImage();

                                  if ((customTextFieldController
                                      .textFieldControllers[0]
                                  ['editing_controller']
                                      .text
                                      .length >
                                      0 &&
                                      customTextFieldController
                                          .textFieldControllers[1]
                                      ['editing_controller']
                                          .text
                                          .length >
                                          0) ||
                                      ((controller.lastCategoryName.value ==
                                          "기타" ||
                                          fixSelectController.isSelected
                                              .value ==
                                              '잘 맞는 옷을 함께 보낼게요.') &&
                                          customTextFieldController
                                              .textFieldControllers[1]
                                          ['editing_controller']
                                              .text
                                              .length >
                                              0)) {
                                    if (isUploaded) {
                                      var registerCart = await orderServices
                                          .addCart(registerInfo: {
                                        "product_id":
                                        controller.productInfo['product'].id,
                                        "variation_id":
                                        fixSelectController.radioId.value,
                                        "select_count":
                                        controller.selectCount.value,
                                      }, metadata: [
                                        WooOrderPayloadMetaData(
                                            key: controller
                                                .productInfo['product'].name,
                                            value: jsonEncode(OrderMetaData(
                                                cartId: FormatMethod().setId(),
                                                productId: controller
                                                    .productInfo['product'].id,
                                                productPrice: (int.parse(
                                                    controller
                                                        .productInfo['product']
                                                        .price) + int.parse(
                                                    fixSelectController
                                                        .radioGroup['가격']))
                                                    .toString(),
                                                cartWay: controller
                                                    .lastCategoryName.value ==
                                                    "기타"
                                                    ? "기타"
                                                    : fixSelectController
                                                    .isSelected.value
                                                    .toString(),
                                                cartSize: customTextFieldController
                                                    .textFieldControllers[
                                                customTextFieldController
                                                    .textFieldControllers
                                                    .indexWhere((element) =>
                                                element['name'] ==
                                                    'size')]
                                                ['editing_controller']
                                                    .text,
                                                cartImages: fixSelectController
                                                    .uploadImg.value !=
                                                    ""
                                                    ? fixSelectController
                                                    .uploadImg.value
                                                    .split(',')
                                                    : [],
                                                guaranteePrice:
                                                customTextFieldController
                                                    .textFieldControllers[
                                                customTextFieldController
                                                    .textFieldControllers
                                                    .indexWhere((element) =>
                                                element['name'] ==
                                                    'product_price')]
                                                ['editing_controller']
                                                    .text,
                                                addOption: fixSelectController
                                                    .radioGroup["추가 옵션"],
                                                cartContent: customTextFieldController
                                                    .textFieldControllers[
                                                customTextFieldController
                                                    .textFieldControllers
                                                    .indexWhere((element) =>
                                                element['name'] ==
                                                    'add_description')]
                                                ['editing_controller']
                                                    .text,
                                                cartCount:
                                                controller.selectCount.value,
                                                cartProductName: controller
                                                    .productInfo['product']
                                                    .name,
                                                cartCategoryName: controller
                                                    .productInfo['product_category_info']
                                                    .name,
                                                variationId: fixSelectController
                                                    .radioId.value
                                            ).toMap())),
                                      ]);
                                      if (registerCart['result']) {
                                        Get.offAndToNamed('/cart');
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                          isAvailable: customTextFieldController
                              .textFieldControllers.isNotEmpty &&
                              ((customTextFieldController
                                  .textFieldControllers[0]
                              ['editing_controller']
                                  .text
                                  .length >
                                  0 &&
                                  customTextFieldController
                                      .textFieldControllers[1]
                                  ['editing_controller']
                                      .text
                                      .length >
                                      0) ||
                                  ((controller.lastCategoryName.value == "기타" ||
                                      fixSelectController.isSelected.value ==
                                          '잘 맞는 옷을 함께 보낼게요.') &&
                                      customTextFieldController
                                          .textFieldControllers[1]
                                      ['editing_controller']
                                          .text
                                          .length >
                                          0))
                              ? true
                              : false,
                        ),
                  )
                ]),
          ),
          btnItems: [],
          iconFt: () {},
        ),
      ),
    );
  }

  Widget optionItem(WooProductVariation variation) {
    FixSelectController fixSelectController = Get.find();

    // 디코딩된 옵션이름 변환
    String optionName = "";

    if (variation.attributes[0].option.toString().indexOf('%') != -1) {
      optionName =
          Uri.decodeComponent(variation.attributes[0].option.toString());
    } else {
      optionName = variation.attributes[0].option.toString();
    }

    // 원 가격
    int currentPrice = int.parse(controller.productInfo['product'].price!);
    print("currentPrice" + currentPrice.toString());

    // optin 추가 된 가격
    int addPrice = int.parse(variation.price!);
    print("addPrice" + addPrice.toString());

    // 추가 될 가격
    int finalPrice = addPrice - currentPrice;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomRadioWidgetOrigin(
              optionName: FormatMethod().convertOptionName(optionName),
              value: fixSelectController.radioId.value,
              groupValue: variation.id,
              onChanged: (value) {
                fixSelectController.isRadioGroup({
                  'variation_id': variation.id,
                  '추가 옵션': FormatMethod().convertOptionName(optionName),
                  '가격': finalPrice.toString()
                });
                fixSelectController.radioId.value = variation.id!;
                controller.selectWholePrice.value = addPrice;
              }),
          Row(
            children: [
              CustomText(
                text: '+ ${FormatMethod().convertPrice(price: finalPrice)}',
                fontSize: FontSize().fs6,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                text: '원',
                fontSize: FontSize().fs6,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // text form
  Widget customTextForm(EdgeInsets? formPadding, String title,
      Widget? widgetItem, Widget? customTextField) {
    return Container(
      padding: formPadding ?? EdgeInsets.only(bottom: 40.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: title,
                fontSize: FontSize().fs6,
                fontWeight: FontWeight.bold,
              ),
              widgetItem ?? Container(),
            ],
          ),
          Container(margin: EdgeInsets.only(top: 10.h), child: customTextField)
        ],
      ),
    );
  }
}
