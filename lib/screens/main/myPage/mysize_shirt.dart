import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/screens/main/myPage/mysize_shirt_update.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/myPage/size_form.dart';
import 'package:flutter/material.dart';

class MysizeShirt extends StatelessWidget {
  final String sizeType;

  const MysizeShirt({Key? key, required this.sizeType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    var sizeInfo = [];
    if (homeInitService.getSizeList.isNotEmpty) {
      switch (sizeType) {
        case 'shirt':
          sizeInfo = [
            {
              'key_name': 'length',
              'title': '총 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .length
            },
            {
              'key_name': 'width',
              'title': '품',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .width
            },
            {
              'key_name': 'neck_width',
              'title': '목둘레',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .neckWidth
            },
            {
              'key_name': 'sleeve_length',
              'title': '소매 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .sleeveLength
            },
            {
              'key_name': 'sleeve_width',
              'title': '소매 통',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .sleeveWidth,
            },
            {
              'key_name': 'sleeve_less_length',
              'title': '민소매 암홀 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .sleeveLessLength
            },
            {
              'key_name': 'shoulder_length',
              'title': '어깨 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .shoulderLength
            },
          ];
          break;
        case 'pants':
          sizeInfo = [
            {
              'key_name': 'length',
              'title': '총 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .length
            },
            {
              'key_name': 'rise_length',
              'title': '밑위 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .riseLength
            },
            {
              'key_name': 'waist',
              'title': '허리',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .waist
            },
            {
              'key_name': 'whole_width',
              'title': '전체 통(밑단)',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .wholeWidth,
            },
            {
              'key_name': 'heap',
              'title': '힙',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .heap
            },
          ];
          break;
        case 'skirt':
          sizeInfo = [
            {
              'key_name': 'length',
              'title': '총 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .length
            },
            {
              'key_name': 'waist',
              'title': '허리',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .waist
            },
            {
              'key_name': 'whole_width',
              'title': '전체 통(밑단)',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .wholeWidth,
            },
            {
              'key_name': 'heap',
              'title': '힙',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .heap
            },
          ];
          break;
        case 'one_piece':
          sizeInfo = [
            {
              'key_name': 'length',
              'title': '총 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .length
            },
            {
              'key_name': 'width',
              'title': '품',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .width
            },
            {
              'key_name': 'sleeve_length',
              'title': '소매 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .sleeveLength
            },
            {
              'key_name': 'sleeve_width',
              'title': '소매 통',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .sleeveWidth,
            },
            {
              'key_name': 'sleeve_less_length',
              'title': '민소매 암홀 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .sleeveLessLength
            },
            {
              'key_name': 'shoulder_length',
              'title': '어깨 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .shoulderLength
            },
          ];
          break;
        default:
          sizeInfo = [
            {
              'key_name': 'length',
              'title': '총 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .length
            },
            {
              'key_name': 'width',
              'title': '품',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .width
            },
            {
              'key_name': 'sleeve_length',
              'title': '소매 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .sleeveLength
            },
            {
              'key_name': 'sleeve_width',
              'title': '소매 통',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .sleeveWidth,
            },
            {
              'key_name': 'sleeve_less_length',
              'title': '민소매 암홀 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .sleeveLessLength
            },
            {
              'key_name': 'shoulder_length',
              'title': '어깨 길이',
              'content': homeInitService
                  .getSizeList[homeInitService.getSizeList.indexWhere(
                      (element) => element.containsKey(sizeType))][sizeType]
                  .shoulderLength
            },
          ];
          break;
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: sizeType == 'shirt'
            ? '상의'
            : sizeType == 'pants'
                ? '하의'
                : sizeType == 'one_piece'
                    ? '원피스'
                    : '스커트',
        leadingWidget: BackBtn(),
        actionItems: [
          AppbarItem(
              icon: "updateIcon.svg",
              iconColor: Colors.black,
              iconFilename: '',
              widget: MysizeShirtUpdate(
                sizeInfo: sizeInfo,
                type: sizeType,
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        child: StreamBuilder(
            stream: Stream.periodic(
              Duration(seconds: 1),
            ).asyncMap((event) => homeInitService.getSize()),
            builder: (context, snapshot) {
              return Container(
                margin: EdgeInsets.only(top: 40.h),
                child: ListView(
                  children: List.generate(
                    sizeInfo.length,
                    (index) => SizeForm(
                        title: sizeInfo[index]['title'],
                        hintTxt: sizeInfo[index]['content'],
                        isTextfield: false),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
