import 'package:get/get.dart';
import 'package:needlecrew/screens/main/myPage/announce_content.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AnnouncementInfo extends StatefulWidget {
  const AnnouncementInfo({Key? key}) : super(key: key);

  @override
  State<AnnouncementInfo> createState() => _AnnouncementInfoState();
}

class _AnnouncementInfoState extends State<AnnouncementInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: '공지사항',
        leadingWidget: BackBtn(),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            announcementList(),
          ],
        ),
      ),
    );
  }

  Widget announcementList() {
    return GestureDetector(
      onTap: () {
        // announceId 값 전달해서 해당하는 공지사항 뿌려주기
        Get.to(AnnounceContent());
      },
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(CupertinoIcons.speaker_1, size: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(
                        text: "12월 15일, 니들크루 수선 요금이 변경됩니다!",
                        fontsize: "",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    FontStyle(
                        text: "2021-12-01",
                        fontsize: "",
                        fontbold: "",
                        fontcolor: HexColor("#909090"),
                        textdirectionright: false),
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Icon(
                      CupertinoIcons.forward,
                      size: 20,
                      color: HexColor("#909090"),
                    ))
              ],
            ),
            SizedBox(
              height: 15,
            ),
            ListLine(
                height: 1,
                width: double.infinity,
                lineColor: HexColor("#d5d5d5"),
                opacity: 0.5)
          ],
        ),
      ),
    );
  }
}
