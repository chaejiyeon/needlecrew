import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/getxServices/home_init_service.dart';
import 'package:needlecrew/modal/address_del_modal.dart';
import 'package:needlecrew/models/address_item.dart';
import 'package:needlecrew/screens/main/myPage/address_add.dart';
import 'package:needlecrew/screens/main/myPage/address_update.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AddressList extends StatefulWidget {
  const AddressList({Key? key}) : super(key: key);

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printInfo(info: 'address list this ${homeInitService.items.length}');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        leadingWidget: BackBtn(),
        appbarcolor: 'white',
        appbar: AppBar(),
        title: '주소 관리',
      ),
      body: Obx(
        () => homeInitService.items.length == 0
            ? Container(
                alignment: Alignment.center,
                child: Text("등록된 주소가 없습니다.", style: TextStyle(fontSize: 15)),
              )
            : Container(
                padding: EdgeInsets.only(top: 40),
                color: Colors.white,
                child: Obx(
                  () => ListView(
                    children: List.generate(
                        homeInitService.items.length,
                        (index) => addressListItem(
                            index, homeInitService.items[index])),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#fd9a03"),
        onPressed: () {
          Get.to(AddressAdd());
        },
        child: Icon(CupertinoIcons.plus),
      ),
    );
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
                    FontStyle(
                        text: address.addressType == 'home'
                            ? '우리집'
                            : address.addressType == 'company'
                                ? '회사'
                                : '기타',
                        fontsize: "",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    FontStyle(
                        text: addressText,
                        fontsize: "",
                        fontbold: "",
                        fontcolor: HexColor("#aaaaaa"),
                        textdirectionright: false),
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
                            HexColor("#d5d5d5"),
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
                            HexColor("#fd9a03"),
                            HexColor("#fd9a03"),
                            false,
                            AddressDelModal()),
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
              lineColor: HexColor("#ededed"),
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
          Get.dialog(widgetName);
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
