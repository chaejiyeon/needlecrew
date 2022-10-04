import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/myPage/updateForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumUpdate extends StatefulWidget {
  const PhoneNumUpdate({Key? key}) : super(key: key);

  @override
  State<PhoneNumUpdate> createState() => _PhoneNumUpdateState();
}

class _PhoneNumUpdateState extends State<PhoneNumUpdate> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    controller.updateUserInfo('phoneNum');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: controller.getUserInfo(),
          builder: (context, snapshot) {
            return UpdateForm(
              appbarName: "전화번호 변경",
              updateType: "전화번호",
              hintText: controller.userInfo['phoneNum'] != null
                  ? controller.userInfo['phoneNum']
                  : "",
            );
          },
          // child: UpdateForm(
          //   appbarName: "전화번호 변경",
          //   updateType: "전화번호",
          //   hintText: controller.userInfo['phoneNum'] != null ? controller.userInfo['phoneNum'] : "",
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(20),
          child: CircleBlackBtn(
              btnText: "변경 완료", pageName: "back", updateName: "전화번호"),
        ),
      ),
    );
  }
}
