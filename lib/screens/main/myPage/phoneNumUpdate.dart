import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/myPage/updateForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumUpdate extends GetView<HomeController> {
  const PhoneNumUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.updateUserInfo('phoneNum');
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: UpdateForm(
          appbarName: "전화번호 변경",
          updateType: "전화번호",
          hintText: controller.userInfo("전화번호") != null ? controller.userInfo("전화번호") : "",
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(20),
          child: CircleBlackBtn(btnText: "변경 완료", pageName: "back", updateName: "전화번호"),
        ),
      ),
    );
  }
}
