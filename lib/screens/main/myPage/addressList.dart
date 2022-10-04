import 'dart:ffi';

import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/modal/addressDelModal.dart';
import 'package:needlecrew/models/addressItem.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/screens/main/myPage/addressAdd.dart';
import 'package:needlecrew/screens/main/myPage/addressUpdate.dart';
import 'package:needlecrew/widgets/circleLineBtn.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
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
    controller.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MypageAppBar(
        title: "주소 관리",
        icon: "",
        widget: MainHome(),
        appbar: AppBar(),
      ),
      body: StreamBuilder(
          stream:
              Future.delayed(Duration(seconds: 1), () => controller.getUser())
                  .asStream(),
          builder: (context, snapshot) {
            return controller.items.length == 0
                ? Container(
                    alignment: Alignment.center,
                    child:
                        Text("등록된 주소가 없습니다.", style: TextStyle(fontSize: 15)),
                  )
                : Container(
                    padding: EdgeInsets.only(top: 40),
                    color: Colors.white,
                    child: ListView(
                      children: List.generate(controller.items.length,
                          (index) => addressListItem(controller.items[index])),
                    ),
                  );
          }),
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
  Widget addressListItem(AddressItem address) {
    return Container(
      padding: EdgeInsets.only(top: 13, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                  "assets/icons/myPage/" + address.addressName == "우리집"
                      ? "mypageHome_1.svg"
                      : address.addressName == "회사"
                          ? "mypageCompany_1.svg"
                          : "mypageLocation_1.svg"),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(
                        text: address.addressName,
                        fontsize: "",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    FontStyle(
                        text: address.address,
                        fontsize: "",
                        fontbold: "",
                        fontcolor: HexColor("#aaaaaa"),
                        textdirectionright: false),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        addressBtn("수정", Colors.black, HexColor("#d5d5d5"),
                            true, AddressUpdate()),
                        SizedBox(
                          width: 10,
                        ),
                        addressBtn("삭제", HexColor("#fd9a03"),
                            HexColor("#fd9a03"), false, AddressDelModal()),
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
  Widget addressBtn(String text, Color txtColor, Color borderColor,
      bool iswidget, Widget widgetName) {
    return GestureDetector(
      onTap: () {
        if (iswidget == true) {
          Get.to(widgetName);
        } else {
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
