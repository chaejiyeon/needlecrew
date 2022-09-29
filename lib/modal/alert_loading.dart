import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/getxController/useInfo/useInfoController.dart';
import 'package:needlecrew/modal/alertDialogYes.dart';
import 'package:needlecrew/screens/main/cartInfo.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/screens/main/myPage/userUpdate.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AlertLoading extends StatelessWidget {
  final String titleText;

  const AlertLoading({Key? key, required this.titleText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final UseInfoController useInfoController = Get.put(UseInfoController());

    return Dialog(
        insetPadding: EdgeInsets.all(10),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: FutureBuilder(
            future: homeController.payMent(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print("payment snapshot " + snapshot.data.toString());
                String text = "";
                String alertLoading = "";
                if (snapshot.data == true) {
                  text = "결제가 완료되었습니다.";
                  alertLoading = "resultY";

                } else {
                  text = "결제에 실패하였습니다.";
                  alertLoading = "resultN";
                }
                return AlertDialogYes(titleText: text, widgetname: alertLoading,);
              } else {
                return Container(
                  height: 174,
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(children: [
                      CircularProgressIndicator(
                        color: HexColor("#fd9a03"),
                      ),
                      Text(titleText, style: TextStyle(color: Colors.white),)
                    ],),
                  ),
                );
              }
            }),
    );
  }
}