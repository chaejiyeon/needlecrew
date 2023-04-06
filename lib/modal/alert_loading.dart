import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/controller/useInfo/useInfoController.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/modal/alert_dialog_yes.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/main_home.dart';
import 'package:needlecrew/screens/main/myPage/user_update.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AlertLoading extends StatelessWidget {
  final dynamic customerUid;
  final String titleText;

  const AlertLoading(
      {Key? key, required this.customerUid, required this.titleText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final UseInfoController useInfoController = Get.put(UseInfoController());

    return Dialog(
      insetPadding: EdgeInsets.all(10),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: FutureBuilder(
          future: paymentService.payMent(customerUid),
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
              return AlertDialogYes(
                titleText: text,
                widgetname: alertLoading,
              );
            } else {
              return Container(
                height: 174,
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: HexColor("#fd9a03"),
                      ),
                      Text(
                        titleText,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
