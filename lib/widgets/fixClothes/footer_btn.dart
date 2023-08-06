import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/controller/widget_controller/custom_drop_down_controller.dart';
import 'package:needlecrew/custom_drop_down.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/widgets/mainhome/priceInfo/table_header.dart';
import 'package:needlecrew/widgets/mainhome/priceInfo/table_list_item.dart';

class FooterBtn extends StatelessWidget {
  const FooterBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomDropDownController dropDownController = Get.find();

    void bottomsheetOpen(BuildContext context) {
      showStickyFlexibleBottomSheet(
          minHeight: 0,
          initHeight: 0.9,
          maxHeight: 0.9,
          context: context,
          bottomSheetColor: Colors.transparent,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          headerHeight: 100,
          headerBuilder: (context, offset) {
            return Container(
              padding: EdgeInsets.only(left: 24, right: 24, top: 10.h),
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30.h),
                      height: 5,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                  CustomText(
                    formMargin: EdgeInsets.only(bottom: 5),
                    text: '니들크루 수선 가격표',
                    fontSize: FontSize().fs6,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    text: '아래의 카테고리를 선택 후 가격을 확인해주세요!',
                    fontSize: FontSize().fs4,
                  ),
                ],
              ),
            );
          },
          bodyBuilder: (context, offset) {
            print("init");
            return SliverChildListDelegate([
              Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height - 100,
                  child: Column(
                    children: [
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
                                dropDownItems:
                                    dropDownController.parentCategories,
                                onChange: (change) async {
                                  dropDownController.selectParent.value =
                                      change.toString();
                                  dropDownController.secondCategories.value =
                                      await productServices.searchCategoryById(
                                          int.parse(change.toString()));
                                  dropDownController.secondCategories.refresh();
                                  dropDownController.selectSecond.value =
                                      dropDownController
                                          .secondCategories.first['id'];
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
                                dropDownItems:
                                    dropDownController.secondCategories,
                                onChange: (change) async {
                                  dropDownController.selectSecond.value =
                                      change.toString();
                                  dropDownController.lastCategories.value =
                                      await productServices.searchCategoryById(
                                          int.parse(change.toString()));
                                  dropDownController.lastCategories.refresh();
                                  dropDownController.selectLast.value =
                                      dropDownController
                                          .lastCategories.first['id'];
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
                                dropDownItems:
                                    dropDownController.lastCategories,
                                onChange: (change) {
                                  dropDownController.selectLast.value =
                                      change.toString();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // table header
                      Container(
                        padding:
                            EdgeInsets.only(left: 20.w, top: 20.h, right: 20.w),
                        child: Row(
                          children: [
                            TableHeader(
                                width: 80.w,
                                borderColor:
                                    HexColor("#fd9a03").withOpacity(0.6),
                                text: "종류"),
                            Expanded(
                                child: TableHeader(
                                    width: double.infinity,
                                    borderColor:
                                        HexColor("#fd9a03").withOpacity(0.2),
                                    text: "수선")),
                            TableHeader(
                                width: 80.w,
                                borderColor:
                                    HexColor("#fd9a03").withOpacity(0.2),
                                text: "가격"),
                          ],
                        ),
                      ),

                      Obx(() => dropDownController.filteredPriceInfo.isEmpty
                          ? Container()
                          : Container(
                              child: SingleChildScrollView(
                              child: Column(
                                  children: List.generate(
                                      dropDownController
                                          .filteredPriceInfo.length,
                                      (index) => TableListItem(
                                          type: dropDownController.lastCategories[
                                              dropDownController.lastCategories
                                                  .indexWhere((element) =>
                                                      element['id'] ==
                                                      dropDownController
                                                          .selectLast
                                                          .value)]['name'],
                                          fixInfo: dropDownController.filteredPriceInfo[index].name,
                                          price: dropDownController.filteredPriceInfo[index].price))),
                            ))),
                    ],
                  ))
            ]);
          });
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("수선 비용이 궁금하신가요?"),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: HexColor("#fd9a03"),
                )),
            child: IconButton(
              icon: Icon(
                CupertinoIcons.chevron_up,
                color: HexColor("#fd9a03"),
              ),
              onPressed: () {
                bottomsheetOpen(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
