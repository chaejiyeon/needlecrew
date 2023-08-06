import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/models/address_item.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/myPage/address_update.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';

class UpdateAddressList extends GetView<HomeController> {
  const UpdateAddressList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeInitService.items.length == 0
        ? Container(
            alignment: Alignment.center,
            child: Text("등록된 주소가 없습니다.", style: TextStyle(fontSize: 15)),
          )
        : Container(
            height: MediaQuery.of(context).size.height - 200.h,
            padding: EdgeInsets.only(top: 40),
            color: Colors.white,
            child: Obx(
              () => ListView(
                children: List.generate(
                    homeInitService.items.length,
                    (index) =>
                        addressListItem(index, homeInitService.items[index])),
              ),
            ),
          ));
  }

  // 주소 리스트
  Widget addressListItem(int index, AddressItem address) {
    List addressInfo = address.address.split(",");
    String addressText = "";

    for (int i = 0; i < addressInfo.length; i++) {
      addressText += addressInfo[i] + " ";
    }

    return Container(
      padding: EdgeInsets.only(top: 13, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              address.sort == "우리집" || address.addressType == "company"
                  ? SvgPicture.asset(address.addressType == "home"
                      ? "assets/icons/myPage/mypageHome_1.svg"
                      : "assets/icons/myPage/mypageCompany_1.svg")
                  : Image.asset(
                      "assets/icons/myPage/mypageLocation_1.png",
                      width: 40,
                      height: 40,
                    ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: address.addressType == 'home'
                          ? '우리집'
                          : address.addressType == 'company'
                              ? '회사'
                              : '기타',
                      fontSize: FontSize().fs4,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      text: addressText,
                      fontSize: FontSize().fs4,
                      fontColor: SetColor().colorAa,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        addressBtn(
                            index,
                            "수정",
                            address.addressType == 'home'
                                ? '우리집'
                                : address.addressType == 'company'
                                    ? '회사'
                                    : '기타',
                            Colors.black,
                            SetColor().colorD5,
                            true,
                            AddressUpdate(
                              index: index,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        addressBtn(
                          index,
                          "삭제",
                          address.addressType == 'home'
                              ? '우리집'
                              : address.addressType == 'company'
                                  ? '회사'
                                  : '기타',
                          SetColor().mainColor,
                          SetColor().mainColor,
                          false,
                          CustomDialog(
                            header: DialogHeader(title: '해당 주소를 삭제하시겠습니까?'),
                            bottom: DialogBottom(isExpanded: true, btn: [
                              BtnModel(callback: () => Get.back(), text: '취소'),
                              BtnModel(
                                  callback: () {
                                    controller.deleteAddress(index);
                                  },
                                  text: '삭제')
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 13,
          ),
          ListLine(
              height: 1,
              width: double.infinity,
              lineColor: SetColor().colorEd,
              opacity: 0.5),
        ],
      ),
    );
  }

  // 수정/삭제 버튼
  Widget addressBtn(int index, String text, String addressType, Color txtColor,
      Color borderColor, bool iswidget, Widget widgetName) {
    return GestureDetector(
      onTap: () {
        if (iswidget == true) {
          Get.to(widgetName, arguments: index);
        } else {
          if (text == "삭제") {
            controller.updateText.value = "";
            if (addressType == "우리집") {
              controller.updateUserInfo("default_address");
            } else if (addressType == "회사") {
              controller.updateUserInfo("company");
            } else if (index == 3) {
              controller.updateUserInfo("address_1");
            } else {
              controller.updateUserInfo("address_2");
            }
          }
          Get.dialog(barrierDismissible: false, widgetName);
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 55,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor)),
        child: Text(
          text,
          style: TextStyle(color: txtColor, fontSize: 13),
        ),
      ),
    );
  }
}
