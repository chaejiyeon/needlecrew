import 'package:needlecrew/screens/main/alramInfo.dart';
import 'package:needlecrew/screens/main/cartInfo.dart';
import 'package:needlecrew/screens/main/fixClothes.dart';
import 'package:needlecrew/screens/main/fixClothes/chooseClothes.dart';
import 'package:needlecrew/widgets/fixClothes/startAddressChoose.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/screens/main/mainhome/priceInfo.dart';
import 'package:needlecrew/widgets/circleLineBtn.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BannerItem extends StatelessWidget {
  final String img;
  final String text1;
  final String text2;
  final String btnText;

  const BannerItem(
      {Key? key,
      required this.img,
      required this.text1,
      required this.text2,
      required this.btnText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          // banner slide 이미지
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset(
                  img,
                ),
              ),
            ),
          ),

          // appbarItem, Image 위 텍스트 밑 버튼
          Positioned(
            bottom: 100,
            child: Container(
              padding: EdgeInsets.only(left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontStyle(
                      text: text1 + "\n" + text2,
                      fontsize: "lg",
                      fontbold: "bold",
                      fontcolor: Colors.white,textdirectionright: false),
                  SizedBox(
                    height: 50,
                  ),
                  CircleLineBtn(
                    btnText: btnText,
                    fontboxwidth: 120,
                    bordercolor: Colors.white,
                    fontcolor: Colors.white,
                    fontsize: "",
                    btnIcon: "nextIcon.svg",
                    btnColor: Colors.transparent,
                    widgetName: FixClothes(),
                    fontboxheight: "",
                    iswidget: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // appbarIcon
  Widget appbarItem(String icon, Widget getTo) {
    return GestureDetector(
      onTap: () {
        Get.to(getTo);
      },
      child: Container(
        padding: EdgeInsets.only(right: 10, top: 30),
        child: SvgPicture.asset(
          "assets/icons/main/" + icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
