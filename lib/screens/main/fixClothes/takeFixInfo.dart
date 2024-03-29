import 'package:needlecrew/bottomsheet/take_fix_info_bottom_sheet.dart';
import 'package:needlecrew/screens/main/fixClothes/fixRegister.dart';
import 'package:needlecrew/widgets/fixClothes/fixClothesAppbar.dart';
import 'package:needlecrew/widgets/fixClothes/progressbar.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../getxController/fixClothes/cartController.dart';

class TakeFixInfo extends StatefulWidget {
  const TakeFixInfo({Key? key}) : super(key: key);

  @override
  State<TakeFixInfo> createState() => _TakeFixInfoState();
}

class _TakeFixInfoState extends State<TakeFixInfo> {
  final CartController controller = Get.put(CartController());

  @override
  void initState() {
    super.initState();
  }

  // 수거 가이드 bottomsheet
  void bottomsheetOpen(BuildContext context) {
    showFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 0.93,
        maxHeight: 0.93,
        bottomSheetColor: Colors.transparent,
        decoration: BoxDecoration(
          color: HexColor("#f5f5f5"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context, controller, offset) =>
            TakeFixInfoBottomSheet(controller: controller),
        isExpand: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FixClothesAppBar(appbar: AppBar()),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: ProgressBar(progressImg: "fixProgressbar_5.svg")),
            Container(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontStyle(
                    text: "수거 후 니들크루 도착까지\n2~3일 정도 소요됩니다.",
                    fontsize: "lg",
                    fontbold: "bold",
                    fontcolor: Colors.black,
                    textdirectionright: false,
                    isEllipsis: false,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Image.asset(
                  "assets/images/takeFix/takeFixtruck.png",
                  width: 278,
                  height: 210,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.centerRight,
        height: 63,
        padding: EdgeInsets.only(left: 24, right: 24),
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        child: GestureDetector(
          // next btn
          onTap: () {
            bottomsheetOpen(context);
          },

          child: Image.asset(
            "assets/icons/selectFloatingIcon.png",
            width: 54,
            height: 54,
          ),
        ),
      ),
    );
  }
}
