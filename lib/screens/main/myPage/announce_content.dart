import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/wp_models/annoucement_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';

class AnnounceContent extends StatelessWidget {
  final AnnouncementItem announcementItem;

  const AnnounceContent({Key? key, required this.announcementItem})
      : super(key: key);

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
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 공지사항 제목
            CustomText(
              text: announcementItem.title,
              fontSize: FontSize().fs4,
              fontWeight: FontWeight.bold,
            ),
            // 공지사항 생성일자
            CustomText(
                text: FormatMethod().convertDate(
                    announcementItem.createdAt.millisecondsSinceEpoch,
                    'yyyy-MM-dd'),
                fontSize: FontSize().fs4,
                fontColor: SetColor().color70,
                formMargin: EdgeInsets.only(bottom: 12)),
            ListLine(
                height: 1,
                width: double.infinity,
                lineColor: SetColor().colorEd,
                opacity: 1,
                margin: EdgeInsets.only(bottom: 24)),
            // 공지사항 내용
            Expanded(
              child: SingleChildScrollView(
                child: HtmlWidget(
                  announcementItem.content,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
