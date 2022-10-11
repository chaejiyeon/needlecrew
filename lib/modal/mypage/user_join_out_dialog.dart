import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class UserJoinOutDialog extends StatelessWidget {
  final String titleText;

  const UserJoinOutDialog({
    Key? key,
    required this.titleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        width: 250,
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
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(color: HexColor("#d5d5d5")),
                        right: BorderSide(color: HexColor("#d5d5d5")),
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
                        top: BorderSide(color: HexColor("#d5d5d5")),
                      )),
                      child: TextButton(
                          child:
                              Text("탈퇴", style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            controller.JoinOut();
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
