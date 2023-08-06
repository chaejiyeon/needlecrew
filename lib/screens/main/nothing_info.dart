import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/fix_clothes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';

class NothingInfo extends StatefulWidget {
  final String title;
  final String subtitle;

  const NothingInfo({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  @override
  State<NothingInfo> createState() => _NothingInfoState();
}

class _NothingInfoState extends State<NothingInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        leadingWidget: BackBtn(),
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
      body: Container(
        padding: EdgeInsets.only(top: 17.h, left: 24.w, right: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 77,
            ),
            Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/xmarkIcon.svg",
                  color: Colors.black,
                  width: 44,
                  height: 44,
                ),
                SizedBox(
                  height: 27,
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(color: HexColor("#606060"), fontSize: 16),
                ),
                SizedBox(
                  height: 49,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(FixClothes());
                    },
                    child: Container(
                      width: 121,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: HexColor("#d5d5d5"),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "수선하기",
                            style: TextStyle(color: HexColor("#202427")),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          SvgPicture.asset(
                            "assets/icons/nextIcon.svg",
                            color: HexColor("#202427"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
