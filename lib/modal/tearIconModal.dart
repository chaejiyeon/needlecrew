import 'package:needlecrew/getxController/fixClothes/cartController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/screens/main/cartInfo.dart';
import 'package:needlecrew/widgets/fontStyle.dart';

class TearIconModal extends StatelessWidget {
  final String title;
  final String btnText1;
  final String btnText2;
  final int orderId;

  const TearIconModal(
      {Key? key,
      required this.title,
      required this.btnText1,
      required this.btnText2,
      this.orderId = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());
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
            SvgPicture.asset("assets/icons/tearIcon.svg"),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FontStyle(
                      text: title,
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
                            btnText1,
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
                          child: Text(btnText2,
                              style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            controller.deleteCart("choose",orderId);
                            Get.back();
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
