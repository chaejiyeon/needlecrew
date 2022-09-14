import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/screens/main/myPage/mysizeShirtUpdate.dart';
import 'package:needlecrew/widgets/iamportForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CircleBlackBtn extends GetView<HomeController> {
  final String btnText;
  final String pageName;
  final String widgetName;
  final String updateName;

  const CircleBlackBtn({Key? key, required this.btnText, required this.pageName, this.widgetName = "", this.updateName = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
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

          if(btnText == "결제하기"){
            Get.to(IamportForm());
          }else if(btnText == "변경 완료"){
            controller.updateUser(updateName);
          }else if(btnText == "치수 측정 가이드 및 수정"){
            Get.to(MysizeShirtUpdate());
          }else{
            pageName != "back" ? Get.toNamed('/' + pageName)  : Get.back() ;
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
