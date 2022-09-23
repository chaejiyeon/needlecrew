import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/userInfoMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PayTypeAddConfirm extends StatefulWidget {
  final bool isFirst;

  const PayTypeAddConfirm({Key? key, required this.isFirst}) : super(key: key);

  @override
  State<PayTypeAddConfirm> createState() => _PayTypeAddConfirmState();
}

class _PayTypeAddConfirmState extends State<PayTypeAddConfirm> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MypageAppBar(
          title: "결제 수단 등록", icon: "", widget: MainHome(), appbar: AppBar()),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    CupertinoIcons.checkmark_alt_circle,
                    size: 50,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FontStyle(
                      text: "결제 카드가 추가 등록되었습니다.",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  UserInfoMenu(
                      appTitle: "결제 수단 등록",
                      title: "이름",
                      info: controller.cardInfo['name'],
                      line: true),
                  UserInfoMenu(
                      appTitle: "결제 수단 등록",
                      title: "이메일",
                      info: controller.cardInfo['email'],
                      line: true),
                  UserInfoMenu(
                      appTitle: "결제 수단 등록",
                      title: "카드번호",
                      info: controller.cardInfo['card_number'].substring(0,15) + "****",
                      line: true),
                  UserInfoMenu(
                      appTitle: "결제 수단 등록",
                      title: "유효기간",
                      info: controller.cardInfo['expiry'].substring(5,7) + "/" + controller.cardInfo['expiry'].substring(2,4),
                      line: true),
                  UserInfoMenu(
                      appTitle: "결제 수단 등록",
                      title: "비밀번호",
                      info: controller.cardInfo['pwd_2digit'] + "**",
                      line: true),
                  UserInfoMenu(
                      appTitle: "결제 수단 등록",
                      title: "생년월일",
                      info: controller.cardInfo['birth'],
                      line: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: widget.isFirst == true
              ? CircleBlackBtn(btnText: "접수 완료하기", pageName: "fixRegisterInfo")
              : CircleBlackBtn(btnText: "확인", pageName: "payType")),
    );
  }
}
