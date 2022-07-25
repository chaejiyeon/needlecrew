import 'package:needlecrew/screens/main/fixClothes.dart';
import 'package:needlecrew/widgets/fixClothes/fixClothesAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

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
      appBar: FixClothesAppBar(
        appbar: AppBar(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 17, left: 24, right: 24),
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
                SizedBox(height: 27,),
                Text(
                  widget.subtitle,
                  style: TextStyle(color: HexColor("#606060"), fontSize: 16),
                ),
                SizedBox(height: 49,),
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
                          SizedBox(width: 8,),
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
