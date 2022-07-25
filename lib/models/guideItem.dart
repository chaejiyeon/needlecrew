import 'package:needlecrew/screens/main/mainhome/priceInfo.dart';
import 'package:needlecrew/screens/main/mainhome/sizeCheckGuide.dart';
import 'package:needlecrew/screens/main/mainhome/useguide.dart';
import 'package:flutter/cupertino.dart';

class GuideItem {
  final String img;
  final String title;
  final String subTitle;
  final Widget widget;

  GuideItem(this.img, this.title, this.subTitle, this.widget);
}

List<GuideItem> guides = [
  GuideItem("assets/images/guideImage_1.png", "니들크루가 처음이신가요?", "차근차근 알려드릴께요!", UseGuide()),
  GuideItem("assets/images/guideImage_2.png", "수선가격이 궁금하신가요?", "합리적인 가격,완벽한 디테일", PriceInfo()),
  GuideItem("assets/images/guideImage_3.png", "의류 측정은 이렇게!", "측정 가이드를 참고해 의뢰해주세요!", SizeCheckGuide()),
];