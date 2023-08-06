import 'package:needlecrew/screens/main/main_home.dart';
import 'package:needlecrew/screens/main/myPage/direct_question.dart';
import 'package:needlecrew/widgets/channeltalk.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/widgets/phone_call_btn.dart';

class ServiceCenterInfo extends StatefulWidget {
  const ServiceCenterInfo({Key? key}) : super(key: key);

  @override
  State<ServiceCenterInfo> createState() => _ServiceCenterInfoState();
}

class _ServiceCenterInfoState extends State<ServiceCenterInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          appbarcolor: 'white',
          appbar: AppBar(),
          title: '고객센터',
          leadingWidget: BackBtn(),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    listMenu("1:1 문의하기", true, Channeltalk()),
                    // listMenu("자주하는 질문", false, DirectQuestion()),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: PhoneCallBtn());
  }

  // list menu
  Widget listMenu(String listTitle, bool isLine, Widget widget) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.to(widget);
      },
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      listTitle,
                    )),
                Icon(
                  CupertinoIcons.forward,
                  size: 20,
                  color: HexColor("#909090"),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            isLine == true
                ? ListLine(
                    height: 1,
                    width: double.infinity,
                    lineColor: HexColor("#d5d5d5"),
                    opacity: 1.0)
                : Container(),
          ],
        ),
      ),
    );
  }
}
