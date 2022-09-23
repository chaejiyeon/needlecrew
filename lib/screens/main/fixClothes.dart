import 'package:needlecrew/widgets/fixClothes/startAddressChoose.dart';
import 'package:needlecrew/widgets/fixClothes/fixClothesAppbar.dart';
import 'package:needlecrew/widgets/fixClothes/footerBtn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FixClothes extends StatelessWidget {
  const FixClothes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      appBar: FixClothesAppBar(appbar: AppBar(),prev: "출발지"),
      body: PageView(
        children: [
          StartAddressChoose(),
        ],
      ),
      bottomNavigationBar:  FooterBtn(),
    );
  }
}
