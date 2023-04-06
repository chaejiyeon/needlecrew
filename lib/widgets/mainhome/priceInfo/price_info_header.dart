import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';

class PriceInfoHeader extends StatelessWidget {
  final String bannerImg;
  final String mainText1;
  final String mainText2;

  // header
  final String titleText;
  final String subtitle;

  const PriceInfoHeader({
    Key? key,
    required this.bannerImg,
    required this.mainText1,
    required this.mainText2,
    required this.titleText,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Stack(
        children: [
          // image banner
          Stack(
            children: [
              Container(
                height: 350,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/" + bannerImg,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              Container(
                height: 350,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/overlayImage.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),


          Positioned(
            bottom: 120,
            child: Container(
              padding: EdgeInsets.only(left: 24),
              alignment: Alignment.topLeft,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontStyle(
                      text: mainText1 + "\n" + mainText2,
                      fontsize: "lg",
                      fontbold: "bold",
                      fontcolor: Colors.white,
                      textdirectionright: false),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(left: 24, right: 24, top: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white),
              height: 100,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontStyle(
                      text: titleText,
                      fontsize: "md",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: FontStyle(
                        text: subtitle,
                        fontsize: "",
                        fontbold: "",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
