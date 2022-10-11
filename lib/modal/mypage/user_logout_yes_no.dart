import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;

class UserLogoutYesNo extends StatelessWidget {
  final String titleText;

  const UserLogoutYesNo({
    Key? key,
    required this.titleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        height: 151,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10,),
            Container(
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
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(color: HexColor("#ededed")),
                        right: BorderSide(color: HexColor("#ededed")),
                      )),
                      child: TextButton(
                          child: Text(
                            "취소",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Get.back();
                          }),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(color: HexColor("#ededed")),
                      )),
                      child: TextButton(
                          child: Text("로그아웃",
                              style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            wp_api.logOut();
                            controller.mainModalcheck.value = false;
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
