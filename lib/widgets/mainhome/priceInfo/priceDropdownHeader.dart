import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';

class PriceDropdownHeader extends StatelessWidget {
  const PriceDropdownHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          color: Colors.white),
      height: 100,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            FontStyle(
                text: "니들크루 수선 가격표",
                fontsize: "md",
                fontbold: "bold",
                fontcolor: Colors.black,textdirectionright: false),
            FontStyle(
                text: "아래의 카테고리를 선택 후 가격을 확인해주세요!",
                fontsize: "",
                fontbold: "",
                fontcolor: Colors.black,textdirectionright: false),
          ],
        ),
      ),
    );
  }
}
