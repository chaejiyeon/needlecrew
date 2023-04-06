import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/start_address_choose.dart';
import 'package:needlecrew/widgets/fixClothes/footer_btn.dart';
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
      appBar: CustomAppbar(
        leadingWidget: BackBtn(backFt: ()=> Get.to(MainPage(pageNum: 0))),
        appbarcolor: 'white',
        appbar: AppBar(),
        actionItems: [
          AppbarItem(
            icon: 'homeIcon.svg',
            iconColor: Colors.black,
            iconFilename: 'main',
            widget: MainPage(pageNum: 0),
          ),
          AppbarItem(
            icon: 'cartIcon.svg',
            iconColor: Colors.black,
            iconFilename: 'main',
            widget: CartInfo(),
          ),
          AppbarItem(
            icon: 'alramIcon.svg',
            iconColor: Colors.black,
            iconFilename: 'main',
            widget: AlramInfo(),
          ),
        ],
      ),
      body: PageView(
        children: [
          StartAddressChoose(),
        ],
      ),
      bottomNavigationBar: FooterBtn(),
    );
  }
}
