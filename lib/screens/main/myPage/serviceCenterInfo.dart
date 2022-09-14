import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/screens/main/myPage/directQuestion.dart';
import 'package:needlecrew/widgets/channeltalk.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/mypageMenu.dart';
import 'package:needlecrew/widgets/myPage/userInfoMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ServiceCenterInfo extends StatefulWidget {
  const ServiceCenterInfo({Key? key}) : super(key: key);

  @override
  State<ServiceCenterInfo> createState() => _ServiceCenterInfoState();
}

class _ServiceCenterInfoState extends State<ServiceCenterInfo> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MypageAppBar(title: "고객센터", icon: "", widget: MainHome(),appbar: AppBar()),
      body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    listMenu("1:1 문의하기", true, Channeltalk()),
                    listMenu("자주하는 질문", false, DirectQuestion()),
                  ],
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 150,
        child: Column(
          children: [
            GestureDetector(child: Container(
              width: 130,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: HexColor("#d5d5d5").withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(3, 1),
                  )
                ]
              ),
              child: Row(children: [
                Icon(CupertinoIcons.phone_fill),
                SizedBox(width: 10,),
                FontStyle(text: "1600-1234", fontsize: "", fontbold: "bold", fontcolor: Colors.black, textdirectionright: false),
              ],),
            )),
            SizedBox(height: 20,),
            Text("평일 오전 9시 ~ 오후 6시까지 상담하며\n주말 및 공휴일은 휴무입니다.", textAlign: TextAlign.center ,),
          ],
        ),
      ),
    );
  }



  // list menu
  Widget listMenu(String listTitle, bool isLine, Widget widget){
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
                Icon(CupertinoIcons.forward, size: 20, color: HexColor("#909090"),),
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

