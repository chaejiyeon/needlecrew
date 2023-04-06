import 'package:needlecrew/screens/main/myPage/address_list.dart';
import 'package:needlecrew/screens/main/myPage/pay_type.dart';
import 'package:needlecrew/screens/main/myPage/phone_num_update.dart';
import 'package:needlecrew/screens/main/myPage/user_join_out.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/myPage/mypage_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserUpdate extends StatelessWidget {
  const UserUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: '회원 정보 변경',
        leadingWidget: BackBtn(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 40, left: 24, right: 24),
        child: Column(
          children: [
            MypageMenu(listTitle: "주소 관리", widget: AddressList()),
            MypageMenu(listTitle: "전화번호 변경", widget: PhoneNumUpdate()),
            MypageMenu(listTitle: "결제 수단", widget: PayType()),
            MypageMenu(listTitle: "회원 탈퇴", widget: UserJoinOut()),
          ],
        ),
      ),
    );
  }
}
