import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/mainhome/use_guide_detail.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/circle_line_btn.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/mainhome/priceInfo/price_info_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class UseGuide extends StatelessWidget {
  const UseGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        appbarcolor: "black",
        appbar: AppBar(),
        title: '이용 가이드',
        leadingWidget: BackBtn(iconColor: Colors.white),
        actionItems: [
          AppbarItem(
            icon: 'cartIcon.svg',
            iconColor: Colors.white,
            iconFilename: 'main',
            widget: CartInfo(),
          ),
          AppbarItem(
            icon: 'alramIcon.svg',
            iconColor: Colors.white,
            iconFilename: 'main',
            widget: AlramInfo(),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PriceInfoHeader(
              bannerImg: "guideImage_1.png",
              mainText1: "이젠 집에서도,쇼핑몰에서도!",
              mainText2: "편리하게 수선해보세요.",
              titleText: "니들크루 이용하기 ",
              subtitle: "의류를 보낼 곳을 선택하여 가이드에 따라\n진행해주세요!",
            ),
            Container(
              child: SvgPicture.asset("assets/images/locationIcon.svg"),
            ),
            Container(
              height: 150,
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CircleLineBtn(
                      btnText: "집에서 보낼경우",
                      fontboxwidth: double.infinity,
                      fontboxheight: "",
                      bordercolor: HexColor("#d5d5d5"),
                      fontcolor: Colors.black,
                      fontsize: "md",
                      btnIcon: "",
                      btnColor: Colors.transparent,
                      widgetName: UseGuideDetail(guide: "집에서 보낼 경우"),
                      iswidget: true,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleLineBtn(
                    btnText: "쇼핑몰에서 보낼경우",
                    fontboxwidth: 173,
                    fontboxheight: "",
                    bordercolor: HexColor("#d5d5d5"),
                    fontcolor: Colors.black,
                    fontsize: "md",
                    btnIcon: "",
                    btnColor: Colors.transparent,
                    widgetName: UseGuideDetail(guide: "쇼핑몰에서 보낼 경우"),
                    iswidget: true,
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
