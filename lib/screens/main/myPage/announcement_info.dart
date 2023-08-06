import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/wp_models/annoucement_item.dart';
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
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: '공지사항',
        leadingWidget: BackBtn(),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 62, left: 24, right: 24),
        child: Obx(
          () => homeInitService.announcements.isNotEmpty
              ? ListView(
                  children: List.generate(
                      homeInitService.announcements.length,
                      (index) => announcementList(
                          homeInitService.announcements[index])))
              : Center(
                  child: CustomText(
                      text: '등록된 공지사항이 없습니다.', fontSize: FontSize().fs4),
                ),
        ),
      ),
    );
  }

  // 공지사항 list item UI
  Widget announcementList(AnnouncementItem announcementItem) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // announceId 값 전달해서 해당하는 공지사항 뿌려주기
        Get.to(AnnounceContent(
          announcementItem: announcementItem,
        ));
      },
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 14),
                  child: SvgPicture.asset(
                    'assets/icons/speakerIcon.svg',
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              textMaxLines: 1,
                              text: announcementItem.title,
                              fontSize: FontSize().fs4,
                              fontWeight: FontWeight.bold,
                              formMargin: EdgeInsets.only(bottom: 5),
                            ),
                            CustomText(
                              text: FormatMethod().convertDate(
                                  announcementItem
                                      .createdAt.millisecondsSinceEpoch,
                                  'yyyy-MM-dd'),
                              fontSize: FontSize().fs4,
                              fontColor: SetColor().color70,
                            )
                          ],
                        ),
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
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            ListLine(
                height: 1,
                width: double.infinity,
                lineColor: SetColor().colorEd,
                opacity: 0.5)
          ],
        ),
      ),
    );
  }
}
