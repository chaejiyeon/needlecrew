import 'dart:developer';

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/fix_clothes/fixselect_controller.dart';
import 'package:needlecrew/controller/page_controller/select_clothes_type_controller.dart';
import 'package:needlecrew/custom_circle_btn.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/fixClothes/direct_insert.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_question.dart';
import 'package:needlecrew/screens/main/fix_clothes.dart';
import 'package:needlecrew/screens/main/update_screens/select_fix_clothes/register_select_fix.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/channeltalk.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/header.dart';
import 'package:needlecrew/widgets/fixClothes/progress_bar.dart';
import 'package:needlecrew/widgets/tootip_custom.dart';

import '../../../../models/util/set_color.dart';

class SelectClothesType extends GetView<SelectClothesTypeController> {
  final bool isFirst;

  const SelectClothesType({Key? key, this.isFirst = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FixSelectController fixSelectController =
        Get.put(FixSelectController());

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (isFirst) {
        controller.selectParentId.value = 0;
        log('init select clothes type first ${controller.selectParentId.value}');
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        leadingWidget: BackBtn(backFt: () {
          if (fixSelectController.crumbs.length == 0 && !isFirst) {
            Get.to(FixClothes());
          } else {
            // back버튼 클릭시 crumbs 마지막 카테고리 Id remove
            if (fixSelectController.crumbs.length > 1) {
              log('fix select crumbs this ${fixSelectController.crumbs} fix clothes info this ${fixSelectController.fixClothesInfo}');
              controller.selectParentId.value = fixSelectController.crumbs.last;
              fixSelectController.crumbs.removeLast();
              fixSelectController.fixClothesInfo.removeLast();
            }
            Get.close(1);
            Get.to(SelectClothesType(
              isFirst: controller.selectParentId.value == 0 ? true : false,
            ));
          }
        }),
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
        () => Container(
          padding: EdgeInsets.only(left: 24.w, right: 24.w),
          child: controller.selectCategories
                      .indexWhere((element) => element.name == '기타') !=
                  -1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------- progress bar section --------
                    ProgressBar(progressImg: "fixProgressbar_2.svg"),
                    // -------- header section --------
                    Header(
                      title: "수선 선택",
                      subtitle1: "",
                      question: true,
                      btnIcon: "updateIcon.svg",
                      btnText: "직접 입력하기",
                      widget: DirectInsert(),
                      imgPath: "",
                      bottomPadding: 30,
                    ),
                    // -------- category section > gridView --------
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Container(
                                height: 34,
                                child: Obx(
                                  () => TabBar(
                                    onTap: (index) {
                                      log('select category this ${controller.selectCategories[index]}');
                                      // controller.selectParentId.value =
                                      //     controller.selectCategories[index].id;
                                      controller.selectCategoryId.value =
                                          controller.selectCategories[index].id;
                                      controller.lastCategoryName.value =
                                          controller
                                              .selectCategories[index].name
                                              .toString();
                                    },
                                    controller:
                                        controller.tabController.value.value,
                                    // isScrollable: true,
                                    indicatorColor: Colors.transparent,
                                    unselectedLabelColor: Colors.black,
                                    labelColor: Colors.white,
                                    labelPadding: EdgeInsets.all(0),
                                    indicatorPadding: EdgeInsets.zero,
                                    tabs: List.generate(
                                      controller.selectCategories.length,
                                      (index) => CategoryItem(
                                          controller.selectCategories[index]),
                                    ),
                                  ),
                                )),
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(top: 29),
                                  child: Obx(
                                    () => TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      controller:
                                          controller.tabController.value.value,
                                      children: List.generate(
                                        controller
                                            .tabController.value.value!.length,
                                        (index) => Obx(
                                          () => GridView(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisExtent: 270,
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 5,
                                              crossAxisSpacing: 10,
                                            ),
                                            children: List.generate(
                                              controller.selectProducts.length,
                                              (index) => chooseOptionItem(
                                                  controller
                                                      .selectProducts[index],
                                                  index,
                                                  controller.selectCategories
                                                      .first.id),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------- progress bar section --------
                    ProgressBar(progressImg: "fixProgressbar.svg"),
                    // -------- header section --------
                    Obx(
                      () => Header(
                        title: "의류 선택",
                        subtitle1: controller.selectParentId.value == 2261
                            ? "수선하고자 하는 성별의 의류를\n선택해주세요."
                            : "어떤 옷을 수선하고 싶으세요?",
                        question: true,
                        btnIcon: "chatIcon.svg",
                        btnText: '',
                        // btnText: "수선 문의하기",
                        widget: FixQuestion(),
                        imgPath: "fixClothes",
                        bottomPadding: 50,
                      ),
                    ),
                    // -------- category section --------
                    Expanded(
                      child: Obx(
                        () => ListView(
                          children: List.generate(
                              controller.selectCategories.length,
                              (index) => CustomCircleBtn(
                                    btnFt: () {
                                      fixSelectController.fixClothesInfo.add(
                                          controller
                                              .selectCategories[index].name
                                              .toString());
                                      fixSelectController.crumbs
                                          .add(controller.selectParentId.value);
                                      controller.selectParentId.value =
                                          controller.selectCategories[index].id;
                                      log('btn click!!!!!!');
                                    },
                                    btnText:
                                        controller.selectCategories[index].name,
                                    btnTextColor: Colors.black,
                                    btnHeight: 54,
                                    borderColor: SetColor().colorD5,
                                    btnMargin: EdgeInsets.only(bottom: 10),
                                  )),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  //
  // category 목록 -> gridView tab custom
  Widget CategoryItem(WooProductCategory category) {
    return Container(
      width: double.infinity,
      child: Obx(
        () => Container(
          padding: EdgeInsets.only(bottom: 6),
          alignment: Alignment.center,
          width: 75,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            width: controller.selectCategoryId.value == category.id ? 2 : 1,
            color: controller.selectCategoryId.value == category.id
                ? SetColor().mainColor
                : SetColor().colorD5,
          ))),
          child: Obx(
            () => Text(
              category.name!,
              style: TextStyle(
                fontSize: 16,
                color: controller.selectCategoryId.value == category.id
                    ? SetColor().mainColor
                    : SetColor().color70,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // gridview 아이템
  Widget chooseOptionItem(WooProduct product, int index, int categoryId) {
    String imageSrc = "";
    if (product.images.isNotEmpty) imageSrc = product.images.first.src ?? "";
    FixSelectController fixSelectController = Get.find();

    log('short description length this ${product.shortDescription.toString().length}');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              controller.productInfo['product'] = product;
              controller.getVariationById(
                  product.id, fixSelectController.crumbs.last);
              if (product.name.toString() == "복원수선") {
                Get.to(Channeltalk());
              } else {
                Get.to(() => RegisterSelectFix());
                // Get.to(() => FixSelect(
                //       productId: product.id!,
                //       crumbs: fixSelectController.crumbs,
                //       lastCategory: controller.lasCategoryName.value == ""
                //           ? controller.selectCategories.first.name.toString()
                //           : controller.lasCategoryName.value,
                //     ));
              }
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: SetColor().colorD5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 200.h,
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: (imageSrc != "")
                      ? Image.network(imageSrc)
                      : Image.asset(
                          "assets/images/sample_2.jpeg",
                          fit: BoxFit.cover,
                        ),
                )),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TooltipCustom(
                  tooltipText:
                      product.shortDescription.toString().contains('0') &&
                              (product.shortDescription.toString().length <= 9)
                          ? ""
                          : product.shortDescription.toString(),
                  titleText: product.name.toString(),
                  boldText: []),
              Expanded(
                child: ontapWidget(
                    Align(
                      alignment: Alignment.topLeft,
                      child: EasyRichText(
                        product.price.toString() == "0"
                            ? "직접문의"
                            : product.price.toString() + "원",
                        textAlign: TextAlign.start,
                        patternList: product.price.toString() == "0"
                            ? null
                            : [
                                EasyRichTextPattern(
                                    targetString: product.price.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'NotoSansCJKkrMedium')),
                                EasyRichTextPattern(
                                    targetString: "원",
                                    style: TextStyle(fontSize: 14)),
                              ],
                      ),
                    ),
                    product),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget ontapWidget(Widget widget, WooProduct product) {
    return GestureDetector(
      onTap: () {
        if (product.name.toString() == "복원수선") {
          Get.to(Channeltalk());
        } else {
          Get.to(() => RegisterSelectFix());
        }
      },
      child: widget,
    );
  }
}
