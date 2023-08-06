import 'dart:developer';
import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/widget_controller/custom_drop_down_controller.dart';
import 'package:needlecrew/custom_drop_down.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/mainhome/priceInfo/price_info_header.dart';
import 'package:needlecrew/widgets/mainhome/priceInfo/table_header.dart';
import 'package:needlecrew/widgets/mainhome/priceInfo/table_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class PriceInfo extends StatefulWidget {
  const PriceInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<PriceInfo> createState() => _PriceInfoState();
}

class _PriceInfoState extends State<PriceInfo> {
  final CustomDropDownController dropDownController = Get.find();
  final scrollCotroller = ScrollController();

  late Color color = Colors.transparent;

  setInit() async {
    dropDownController.filteredPriceInfo.value =
        await productServices.searchProductsById([
      int.parse(dropDownController.selectParent.value),
      int.parse(dropDownController.selectSecond.value),
      int.parse(dropDownController.selectLast.value)
    ]);
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      setInit();
    });
    super.initState();
    scrollCotroller.addListener(listenScrolling);
  }

  @override
  void dispose() {
    super.dispose();
    scrollCotroller.dispose();
  }

  void listenScrolling() {
    if (scrollCotroller.position.atEdge) {
      final isTop = scrollCotroller.position.pixels == 0;
      setState(() {
        color = Colors.transparent;
      });
      if (isTop) {
        print("start");
      } else if (scrollCotroller.position.pixels >= 100) {
        setState(() {
          color = Colors.white;
        });
      } else {
        print("end");
        setState(() {
          color = Colors.transparent;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        appbarcolor: color == Colors.white ? "white" : "black",
        appbar: AppBar(),
        title: '이용 가이드',
        leadingWidget: BackBtn(
            iconColor: color == Colors.white ? Colors.black : Colors.white),
        actionItems: [
          AppbarItem(
            icon: 'cartIcon.svg',
            iconColor: color == Colors.white ? Colors.black : Colors.white,
            iconFilename: 'main',
            widget: CartInfo(),
          ),
          AppbarItem(
            icon: 'alramIcon.svg',
            iconColor: color == Colors.white ? Colors.black : Colors.white,
            iconFilename: 'main',
            widget: AlramInfo(),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        controller: scrollCotroller,
        children: [
          PriceInfoHeader(
            bannerImg: "guideImage_2.png",
            mainText1: "믿을 수 있는 품질과",
            mainText2: "합리적인 가격으로 만나보세요!",
            titleText: "니들크루 수선 가격표",
            subtitle: "아래의 카테고리를 선택 후 가격을 확인해주세요!",
          ),

          Container(
            padding: EdgeInsets.only(left: 24.w, right: 24.w),
            child: Column(
              children: [
                Obx(
                  () => CustomDropDown(
                    dropDownHeight: 41.h,
                    dropDownMargin: EdgeInsets.only(bottom: 10),
                    dropDownBtnPadding:
                        EdgeInsets.only(left: 24.w, right: 24.w),
                    value: dropDownController.selectParent.value,
                    dropDownItems: dropDownController.parentCategories,
                    onChange: (change) async {
                      dropDownController.selectParent.value = change.toString();
                      dropDownController.secondCategories.value =
                          await productServices
                              .searchCategoryById(int.parse(change.toString()));

                      dropDownController.secondCategories.refresh();
                      dropDownController.lastCategories.value =
                          await productServices.searchCategoryById(int.parse(
                              dropDownController.secondCategories.first['id']));
                      dropDownController.lastCategories.refresh();
                      dropDownController.selectSecond.value =
                          dropDownController.secondCategories.first['id'];
                      dropDownController.selectLast.value =
                          dropDownController.lastCategories.first['id'];
                    },
                  ),
                ),
                Obx(
                  () => CustomDropDown(
                    dropDownHeight: 41.h,
                    dropDownMargin: EdgeInsets.only(bottom: 10),
                    dropDownBtnPadding:
                        EdgeInsets.only(left: 24.w, right: 24.w),
                    value: dropDownController.selectSecond.value,
                    dropDownItems: dropDownController.secondCategories,
                    onChange: (change) async {
                      if (!productServices.isLoading.value) {
                        if (dropDownController.secondCategories.indexWhere(
                                (element) =>
                                    element['id'] == change.toString()) !=
                            -1) {
                          dropDownController.selectSecond.value =
                              change.toString();
                        }
                        dropDownController.lastCategories.value =
                            await productServices.searchCategoryById(
                                int.parse(change.toString()));
                        dropDownController.lastCategories.refresh();
                        dropDownController.selectLast.value =
                            dropDownController.lastCategories.first['id'];
                      }
                    },
                  ),
                ),
                Obx(
                  () => CustomDropDown(
                    dropDownHeight: 41.h,
                    dropDownMargin: EdgeInsets.only(bottom: 10),
                    dropDownBtnPadding:
                        EdgeInsets.only(left: 24.w, right: 24.w),
                    value: dropDownController.selectLast.value,
                    dropDownItems: dropDownController.lastCategories,
                    onChange: (change) {
                      if (!productServices.isLoading.value) {
                        if (dropDownController.lastCategories.indexWhere(
                                (element) =>
                                    element['id'] == change.toString()) !=
                            -1) {
                          dropDownController.selectLast.value =
                              change.toString();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // table header
          Container(
            padding: EdgeInsets.only(left: 20.w, top: 20.h, right: 20.w),
            child: Row(
              children: [
                TableHeader(
                    width: 80.w,
                    borderColor: HexColor("#fd9a03").withOpacity(0.6),
                    text: "종류"),
                Expanded(
                    child: TableHeader(
                        width: double.infinity,
                        borderColor: HexColor("#fd9a03").withOpacity(0.2),
                        text: "수선")),
                TableHeader(
                    width: 80.w,
                    borderColor: HexColor("#fd9a03").withOpacity(0.2),
                    text: "가격"),
              ],
            ),
          ),

          Obx(() => dropDownController.filteredPriceInfo.isEmpty
              ? Container()
              : Container(
                  child: Column(
                      children: List.generate(
                          dropDownController.filteredPriceInfo.length,
                          (index) => TableListItem(
                              type: dropDownController.lastCategories[
                                  dropDownController.lastCategories.indexWhere(
                                      (element) =>
                                          element['id'] ==
                                          dropDownController
                                              .selectLast.value)]['name'],
                              fixInfo: dropDownController.filteredPriceInfo[index].name,
                              price: dropDownController.filteredPriceInfo[index].price))))),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          scrollCotroller.animateTo(0,
              duration: Duration(milliseconds: 1), curve: Curves.linear);
        },
        child: SvgPicture.asset("assets/icons/upIcon.svg"),
      ),
    );
  }
}
