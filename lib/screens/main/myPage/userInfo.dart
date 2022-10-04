import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
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

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  @override
  void initState() {
    controller.getUserInfo();
    super.initState();
  }

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
        child: Container(
          padding: EdgeInsets.all(30),
          color: Colors.white,
          child: StreamBuilder(
            stream: controller.getUserInfo(),
            builder: (context, snapshot){
              return  Column(
                children: [
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "이름",
                      info:
                      controller.userInfo['username'] != null ? controller.userInfo['username'] : '',
                      line: true),
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "전화번호",
                      info:
                      controller.userInfo['phoneNum'] != null ? controller.userInfo['phoneNum'] : '',
                      line: true),
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "주소",
                      info: controller.userInfo['default_address'] != null
                          ? controller.userInfo['default_address']
                          : '',
                      line: true),
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "결제 수단",
                      info: controller.userInfo['default_card'] != null
                          ? controller.userInfo['default_card']
                          : '',
                      line: false),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
