import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';

class AnnounceContent extends StatelessWidget {
  const AnnounceContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: '공지사항',
        leadingWidget: BackBtn(),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "12월 15일, 니들크루 수선 요금이 변경됩니다!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "2021-12-01",
              style: TextStyle(color: HexColor("#707070")),
            ),
            SizedBox(
              height: 11,
            ),
            ListLine(
                height: 1,
                width: double.infinity,
                lineColor: HexColor("#ededed"),
                opacity: 1),
            SizedBox(
              height: 23,
            ),
            Text(
                "안녕하세요, 니들크루 입니다. \n니들크루 수선 요금이 12월 15일 부로 인상됩니다.\n인상되는 수선품목은 아래와 같으며 확인해주시고 주문에 차질이 없도록 부탁드리겠습니다.\n\n-짜집기 3,000원 > 4,000원\n기장수선 3,000원 > 4,000원\n\n감사합니다. 니들크루 드림")
          ],
        ),
      ),
    );
  }
}
