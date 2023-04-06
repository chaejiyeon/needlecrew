import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/screens/main/myPage/user_update.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/myPage/user_info_menu.dart';
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
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: '회원 정보',
        leadingWidget: BackBtn(),
        actionItems: [
          AppbarItem(
              icon: "updateIcon.svg",
              iconColor: Colors.black,
              iconFilename: '',
              widget: UserUpdate())
        ],
      ),
      body: SafeArea(
          child: FutureBuilder(
              future: homeInitService.syncUser(),
              builder: (context, snapshot) {
                printInfo(
                    info:
                        'address length this ${homeInitService.items.length}');
                return Container(
                  padding: EdgeInsets.all(30),
                  color: Colors.white,
                  child: Column(
                    children: [
                      UserInfoMenu(
                          appTitle: "회원 정보",
                          title: "이름",
                          info: homeInitService.user.value.value!.username !=
                                  null
                              ? '${homeInitService.user.value.value!.lastName}${homeInitService.user.value.value!.firstName}'
                              : '',
                          line: true),
                      Obx(
                        () => UserInfoMenu(
                            appTitle: "회원 정보",
                            title: "전화번호",
                            info: homeInitService.userInfo['phone_number'] != ''
                                ? homeInitService.userInfo['phone_number']
                                : '',
                            line: true),
                      ),
                      Obx(
                        () => UserInfoMenu(
                            appTitle: "회원 정보",
                            title: "주소",
                            info: homeInitService.userInfo['address'] != ''
                                ? homeInitService.userInfo['address']
                                : '',
                            line: true),
                      ),
                      Obx(
                        () => UserInfoMenu(
                            appTitle: "회원 정보",
                            title: "결제 수단",
                            info:
                                homeInitService.userInfo['default_card'] != null
                                    ? homeInitService.userInfo['default_card']
                                    : '',
                            line: false),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
