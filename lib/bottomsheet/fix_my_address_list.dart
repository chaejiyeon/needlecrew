import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/models/address_item.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/fixClothes/take_fix_date.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class FixMyAddressList extends StatefulWidget {
  final bool addressExist;
  final List items;

  const FixMyAddressList(
      {Key? key, required this.addressExist, required this.items})
      : super(key: key);

  @override
  State<FixMyAddressList> createState() => _FixMyAddressListState();
}

class _FixMyAddressListState extends State<FixMyAddressList> {
  final CartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.setAddressList(widget.items);

    return Obx(
      () => homeInitService.items.length != 0
          ? Container(
              padding: EdgeInsets.zero,
              child: Column(
                children: List.generate(
                    homeInitService.items.length,
                    (index) =>
                        myaddressList(homeInitService.items[index], index)),
              ),
            )
          : Align(
              alignment: Alignment.topCenter,
              child: Text("등록된 주소가 없습니다."),
            ),
    );
  }

  // 주소가 있을 경우 주소 리스트 표시
  Widget myaddressList(AddressItem addressitem, int index) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      margin: EdgeInsets.only(top: index == 0 ? 0 : 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10.w),
                child: addressitem.addressType == "home" ||
                        addressitem.addressType == "company"
                    ? SvgPicture.asset(
                        "assets/icons/myPage/${addressitem.addressType == "home" ? "mypageHome_1.svg" : "mypageCompany_1.svg"}")
                    : Image.asset('assets/icons/myPage/mypageLocation_1.png'),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FontStyle(
                            text: addressitem.addressType == 'home'
                                ? '우리집'
                                : addressitem.addressType == 'company'
                                    ? '회사'
                                    : '기타',
                            fontsize: "",
                            fontbold: "bold",
                            fontcolor: Colors.black,
                            textdirectionright: false),
                        FontStyle(
                            text: addressitem.address,
                            fontsize: "",
                            fontbold: "",
                            fontcolor: HexColor("#909090"),
                            textdirectionright: false),
                      ],
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          if (!controller.addressList[controller.addressList
                              .indexWhere((element) =>
                                  element['address_type'] ==
                                  addressitem.addressType)]['is_checked']) {
                            controller.addressList[controller.addressList
                                    .indexWhere((element) =>
                                        element['address_type'] ==
                                        addressitem.addressType)]
                                ['is_checked'] = true;
                            for (Map item in controller.addressList) {
                              if (item['address_type'] !=
                                  addressitem.addressType) {
                                item['is_checked'] = false;
                              }
                            }

                            var splitAddress = [];

                            splitAddress =
                                addressitem.address.trim().split(',');

                            for (String item in splitAddress) {
                              controller.setAddress.value += item;
                            }

                            Get.dialog(
                                barrierDismissible: false,
                                CustomDialog(
                                  header: DialogHeader(
                                    headerPadding: EdgeInsets.only(
                                        left: 33.w, right: 33.w),
                                    title: '해당 주소로\n수거지를 설정 하시겠습니까?',
                                  ),
                                  bottom: DialogBottom(isExpanded: true, btn: [
                                    BtnModel(
                                        callback: () {
                                          Get.back();
                                        },
                                        text: '취소'),
                                    BtnModel(
                                        callback: () {
                                          Get.close(4);
                                          Get.to(TakeFixDate());
                                        },
                                        text: '확인'),
                                  ]),
                                ));
                            controller.detailAddress.value = splitAddress.first;
                            controller.addressEditingController.value.text =
                                splitAddress.last;
                            controller.update();
                          } else {
                            controller.addressList[controller.addressList
                                    .indexWhere((element) =>
                                        element['address_type'] ==
                                        addressitem.addressType)]
                                ['is_checked'] = false;
                            controller.detailAddress.value = '지번, 도로명, 건물명 검색';
                            controller.addressEditingController.value.text = '';
                          }
                        });
                      },
                      child: Obx(
                        () => SizedBox(
                          width: 22,
                          height: 22,
                          child: Image.asset(
                              'assets/icons/${controller.addressList[controller.addressList.indexWhere((element) => element['address_type'] == addressitem.addressType)]['is_checked'] ? 'selectCheckIcon.png' : 'checkBtnIcon.png'}'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10.h),
            height: 1,
            width: double.infinity,
            decoration:
                BoxDecoration(color: HexColor("#d5d5d5").withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
