import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/modal/alert_loading.dart';
import 'package:needlecrew/screens/main/fixClothes/fixRegisterInfo.dart';
import 'package:needlecrew/screens/main/myPage/mysizeShirtUpdate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircleBlackBtn extends GetView<HomeController> {
  final String btnText;
  final String pageName;
  final String widgetName;
  final String updateName;
  final dynamic argument;

  const CircleBlackBtn(
      {Key? key,
      required this.btnText,
      required this.pageName,
      this.widgetName = "",
      this.updateName = "",
      this.argument})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    controller.getCardAll();
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      child: TextButton(
        onPressed: () {
          if (pageName == "payTypeAdd") {
            print("cardsInfo " + controller.cardsBillkey.toString());
            if (controller.cardsInfo.length >= 1) {
              Get.to(FixRegisterInfo());
            } else {
              Get.toNamed("/" + pageName);
            }
          } else if (pageName == "addressUpdate" || pageName == "payType") {
            controller.updateUser(updateName);
          } else {
            if (btnText == "결제하기") {
              Get.dialog(AlertLoading(titleText: "결제 중입니다."));
            } else if (btnText == "변경 완료") {
              controller.updateUser(updateName);
            } else if (btnText == "치수 측정 가이드 및 수정") {
              Get.to(MysizeShirtUpdate());
            } else {
              pageName != "back" ? Get.toNamed('/' + pageName) : Get.back();
            }
          }
        },
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
