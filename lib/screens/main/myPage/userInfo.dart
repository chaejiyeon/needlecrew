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
  final HomeController homeController = Get.find();


  @override
  void initState() {
    super.initState();
  }


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
            stream: Stream.periodic(
              Duration(seconds: 1),
            ).asyncMap((event) => wp_api.getUser()),
            builder: (context, AsyncSnapshot<WooCustomer> snapshot) {
              bool dataExist = snapshot.connectionState == ConnectionState.done;

              if (snapshot.hasData) {
                homeController.getUserInfo(snapshot.data!);
              }
              return Column(
                children: [
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "이름",
                      info: dataExist == false &&
                          homeController.userInfo['username'] != null
                          ? homeController.userInfo['username']
                          : '',
                      line: true),
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "전화번호",
                      info: dataExist == false &&
                          homeController.userInfo['phoneNum'] != null
                          ? homeController.userInfo['phoneNum']
                          : '',
                      line: true),
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "주소",
                      info: dataExist == false &&
                          homeController.userInfo['default_address'] != null
                          ? homeController.userInfo['default_address']
                          : '',
                      line: true),
                  UserInfoMenu(
                      appTitle: "회원 정보",
                      title: "결제 수단",
                      info: homeController.userInfo['default_card'] != null
                          ? homeController.userInfo['default_card']
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
