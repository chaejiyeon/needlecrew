import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AlertDialogYesNo extends StatelessWidget {
  final String titleText;
  final String contentText;
  final String icon;
  final String iconPath;
  final String btntext1;
  final String btntext2;

  const AlertDialogYesNo(
      {Key? key,
      required this.titleText,
      required this.contentText,
      required this.icon,
      required this.iconPath,
      required this.btntext1,
      required this.btntext2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10,
            ),
            icon != "" ? SvgPicture.asset("assets/" + (iconPath != "" ? iconPath +"/" +icon: icon),) : Container(),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FontStyle(
                      text: titleText,
                      fontsize: "md",
                      fontbold: "bold",
                      fontcolor: Colors.black,textdirectionright: false),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child:
                  Text(contentText, style: TextStyle(color: HexColor("#909090")),textAlign: TextAlign.center,),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(color: HexColor("#d5d5d5")),
                        right: BorderSide(color: HexColor("#d5d5d5")),
                      )),
                      child: Center(
                        child: TextButton(
                            child: Text(
                              btntext1,
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Get.back();
                            }),
                      ),
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
                              Text(btntext2, style: TextStyle(color: Colors.black)),
                          onPressed: () {}),
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
