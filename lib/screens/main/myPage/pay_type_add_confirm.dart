import 'package:get/get.dart';
import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_register.dart';
import 'package:needlecrew/screens/main/main_home.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:needlecrew/widgets/myPage/user_info_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'user_info.dart';

class PayTypeAddConfirm extends StatefulWidget {
  final bool isFirst;

  const PayTypeAddConfirm({Key? key, required this.isFirst}) : super(key: key);

  @override
  State<PayTypeAddConfirm> createState() => _PayTypeAddConfirmState();
}

class _PayTypeAddConfirmState extends State<PayTypeAddConfirm> {
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: '결제 수단 등록',
        leadingWidget: BackBtn(),
      ),
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
                      info: paymentService.setCardInfo['name'],
                      line: true),
                  UserInfoMenu(
                      appTitle: "결제 수단 등록",
                      title: "이메일",
                      info: paymentService.setCardInfo['email'],
                      line: true),
                  UserInfoMenu(
                      appTitle: "결제 수단 등록",
                      title: "카드번호",
                      info: paymentService.setCardInfo['card_number']
                              .substring(0, 15) +
                          "****",
                      line: true),
                  UserInfoMenu(
                      appTitle: "결제 수단 등록",
                      title: "유효기간",
                      info: paymentService.setCardInfo['expiry']
                              .substring(5, 7) +
                          "/" +
                          paymentService.setCardInfo['expiry'].substring(2, 4),
                      line: true),
                  UserInfoMenu(
                      appTitle: "결제 수단 등록",
                      title: "비밀번호",
                      info: paymentService.setCardInfo['pwd_2digit'] + "**",
                      line: true),
                  UserInfoMenu(
                      appTitle: "결제 수단 등록",
                      title: "생년월일",
                      info: paymentService.setCardInfo['birth'],
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
              ? CircleBlackBtn(
                  function: () => Get.to(FixRegister(),arguments: widget.isFirst ? true : false,),
                  btnText: "접수 완료하기",
                )
              : CircleBlackBtn(
                  function: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => UserInfo()),
                      (route) => false),
                  btnText: "확인",
                )),
    );
  }
}
