import 'package:needlecrew/bottomsheet/fix_address_bottom_sheet_header.dart';
import 'package:needlecrew/bottomsheet/fix_my_address_list.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/fixClothes/take_fix_date.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kpostal/kpostal.dart';

import '../../../widgets/fixClothes/progress_bar.dart';

class AddressInsert extends GetView<CartController> {
  const AddressInsert({Key? key}) : super(key: key);

  // 주소 관리 bottomsheet
  void bottomsheetOpen(BuildContext context) {
    showStickyFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 0.5,
        maxHeight: 0.5,
        context: context,
        bottomSheetColor: HexColor("#909090").withOpacity(0.2),
        decoration: BoxDecoration(
          color: HexColor("#f5f5f5"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        headerHeight: 85,
        headerBuilder: (context, offset) {
          return homeInitService.items.length != 0
              ? FixAddressBottomSheetHeader(
                  addressExist: true,
                )
              : FixAddressBottomSheetHeader(
                  addressExist: false,
                );
        },
        bodyBuilder: (context, offset) {
          return SliverChildListDelegate([
            homeInitService.items.length != 0
                ? FixMyAddressList(
                    addressExist: true,
                    items: homeInitService.items,
                  )
                : FixMyAddressList(
                    addressExist: false,
                    items: homeInitService.items,
                  )
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  child: ProgressBar(progressImg: "fixProgressbar_3.svg")),
              Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(
                        text: "주소 입력",
                        fontsize: "lg",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    FontStyle(
                        text: "수거된 의류는 결제일로부터 3~4일 후\n수선사에게 도착합니다.",
                        fontsize: "",
                        fontbold: "",
                        fontcolor: Colors.black.withOpacity(0.7),
                        textdirectionright: false),
                    Container(
                      padding: EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          searchAddress("지번,도로명,건물명 검색"),
                          insertTextfield("상세주소"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: myaddressBtn(context),
      ),
    );
  }

  // address 입력 필드
  Widget insertTextfield(String hintTxt) {
    printInfo(
        info:
            'address editing content this ${controller.addressEditingController.value.text}');
    return Obx(
      () => Container(
        child: TextField(
          controller: controller.addressEditingController.value,
          textAlign: controller.addressEditingController.value.text.isNotEmpty
              ? TextAlign.left
              : TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                left: controller.addressEditingController.value.text.isNotEmpty
                    ? 30
                    : 0,
                top: 20,
                bottom: 20),
            hintText: hintTxt,
            hintStyle: TextStyle(color: HexColor("#909090")),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: HexColor("#909090"),
                )),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: HexColor("#909090").withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 주소 검색
  Widget searchAddress(String text) {
    return GestureDetector(
      onTap: () async {
        await Get.to(KpostalView(
          useLocalServer: true,
          localPort: 1024,
          // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
          callback: (Kpostal result) {
            controller.detailAddress.value = result.address;
          },
        ));
      },
      child: Obx(
        () => Container(
          margin: EdgeInsets.only(bottom: 10),
          alignment: controller.detailAddress.value != '지번, 도로명, 건물명 검색'
              ? Alignment.centerLeft
              : Alignment.center,
          padding: controller.detailAddress.value != '지번, 도로명, 건물명 검색'
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.zero,
          height: 64,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: HexColor("#909090").withOpacity(0.5))),
          child: Obx(
            () => Text(
              controller.detailAddress.value,
              style: TextStyle(
                  color: controller.detailAddress.value != '지번, 도로명, 건물명 검색'
                      ? Colors.black
                      : HexColor("#909090"),
                  fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  // bottomnavigation 버튼
  Widget myaddressBtn(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              bottomsheetOpen(context);
            },
            child: Container(
              width: 150,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: HexColor("#fd9a03"),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FontStyle(
                      text: "내 주소",
                      fontcolor: HexColor("#fd9a03"),
                      fontsize: "",
                      fontbold: "",
                      textdirectionright: false),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(CupertinoIcons.chevron_up,
                      color: HexColor("#fd9a03"), size: 15),
                ],
              ),
            ),
          ),

          // 수거 희망일 페이지로이동
          GestureDetector(
            onTap: () {
              if (controller.addressEditingController.value.text.length > 0) {
                controller.setAddress.value =
                    '${controller.detailAddress.value} ${controller.addressEditingController.value.text}';
              }
              Get.to(TakeFixDate());
            },
            child: Obx(
              () => Container(
                height: 63,
                alignment: Alignment.bottomCenter,
                child: controller.addressEditingController.value.text.length > 0
                    ? Image.asset(
                        "assets/icons/selectFloatingIcon.png",
                        width: 54,
                        height: 54,
                      )
                    : SvgPicture.asset(
                        "assets/icons/floatingNext.svg",
                        color: HexColor("#d5d5d5"),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
