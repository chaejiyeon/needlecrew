import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/models/guide_item.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GuideItemList extends StatelessWidget {
  final GuideItem items;

  const GuideItemList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24.w, right: 24.w),
      margin: EdgeInsets.only(bottom: 25.h),
      height: 220,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              child: Image.asset(
                items.img,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              onTap: (){
                Get.to(items.widget);
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height:50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FontStyle(
                              text: items.title,
                              fontsize: "md",
                              fontbold: "bold",
                              fontcolor: Colors.white,textdirectionright: false),
                          FontStyle(
                              text: items.subTitle,
                              fontsize: "",
                              fontbold: "bold",
                              fontcolor: Colors.white,textdirectionright: false),
                        ],
                      ),
                    ),
                    SvgPicture.asset("assets/icons/floatingNext.svg", color: Colors.white,),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
