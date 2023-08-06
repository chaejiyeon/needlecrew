import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BannerInfo extends StatelessWidget {
  final String img;
  final String title;

  const BannerInfo({
    Key? key,
    required this.img,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var setTitle;
    if (title.contains('|')) {
      printInfo(info: 'title ddddd');
      setTitle = title.split('|');
    } else {
      setTitle.add(title);
    }
    return Container(
      child: Stack(
        children: [
          // banner slide 이미지
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(
                  img,
                ),
              ),
            ),
          ),

          // appbarItem, Image 위 텍스트 밑 버튼
          Positioned(
            top: 125,
            child: Container(
              padding: EdgeInsets.only(left: 24.w, right: 12.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      setTitle.length,
                      (index) => FontStyle(
                          isEllipsis: false,
                          text: setTitle[index],
                          fontsize: "lg",
                          fontbold: "bold",
                          fontcolor: Colors.white,
                          textdirectionright: false))),
            ),
          ),
        ],
      ),
    );
  }

  // appbarIcon
  Widget appbarItem(String icon, Widget getTo) {
    return GestureDetector(
      onTap: () {
        Get.to(getTo);
      },
      child: Container(
        padding: EdgeInsets.only(right: 10.w, top: 30.h),
        child: SvgPicture.asset(
          "assets/icons/main/" + icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
