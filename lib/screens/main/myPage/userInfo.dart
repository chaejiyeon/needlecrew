import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/screens/main/myPage/userUpdate.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/userInfoMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MypageAppBar(
          title: "회원 정보",
          icon: "updateIcon.svg",
          widget: UserUpdate(),
          appbar: AppBar()),
      body: SafeArea(
        child: Obx(() {
          if (controller.isInitialized.value) {
            return Container(
              padding: EdgeInsets.all(30),
              color: Colors.white,
              child: Column(
                children: [
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "이름",
                      info: controller.user.lastName.toString() +
                          controller.user.firstName.toString(),
                      line: true),
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "전화번호",
                      info: controller.userInfo("전화번호") != null ? controller.usersetPhone.value : "",
                      line: true),
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "주소",
                      info: controller.userInfo("주소") != null
                          ? controller.usersetAddress.value
                          : "",
                      line: true),
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "결제 수단",
                      info: controller.userInfo("결제 수단") != null
                          ? controller.usersetPay.value : "",
                      line: false),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
