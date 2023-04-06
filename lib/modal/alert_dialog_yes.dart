import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/controller/useInfo/useInfoController.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/main_home.dart';
import 'package:needlecrew/screens/main/myPage/user_info.dart';
import 'package:needlecrew/screens/main/myPage/user_update.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AlertDialogYes extends StatelessWidget {
  final String titleText;
  final String widgetname;
  final dynamic function;

  const AlertDialogYes(
      {Key? key, required this.titleText, this.widgetname = "", this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homecontroller = Get.put(HomeController());
    final UseInfoController useInfoController = Get.put(UseInfoController());

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        width: 297,
        height: 174,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FontStyle(
                      text: titleText,
                      fontsize: "md",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(color: HexColor("#d5d5d5")),
              )),
              child: TextButton(
                  child: Text(
                    "확인",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    if (function != null) {
                      function();
                    } else {
                      if (widgetname == "updateUserInfo") {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => UserInfo()),
                            (route) => false);
                        // Get.close(2);
                      } else if (widgetname == "cart") {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => CartInfo()),
                            (route) => false);
                      } else if (widgetname == "alert") {
                        Get.close(2);
                      } else if (widgetname == "resultY") {
                        useInfoController.updateState();
                        Get.offAndToNamed("/useInfoProgress");
                      } else {
                        if (widgetname == "biilling") {
                          paymentService.cardInfo.clear();
                        }
                        Get.back();
                      }
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
