import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/widgets/mainhome/banner_info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/font_style.dart';

class BannerSlides extends StatefulWidget {
  const BannerSlides({Key? key}) : super(key: key);

  @override
  State<BannerSlides> createState() => _BannerSlidesState();
}

class _BannerSlidesState extends State<BannerSlides> {
  CarouselController _carouselController = CarouselController();
  late int currentpage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          if (homeInitService.banners.isNotEmpty) {
            return CarouselSlider(
              carouselController: _carouselController,
              items: List.generate(
                homeInitService.banners.length,
                (index) => BannerInfo(
                  img: homeInitService.banners[index].imgUrl,
                  title: homeInitService.banners[index].title,
                ),
              ),
              // homeInitService.banners.value.map((banners) {
              //   return BannerItem(
              //       img: banners.img,
              //       text1: banners.text1,
              //       text2: banners.text2,
              //       btnText: banners.btnText);
              // }).toList(),
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: 409,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentpage = index;
                    });
                  }),
            );
          } else {
            return Stack(
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
                    height: 409,
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset(
                        'assets/images/bannerImage.png',
                      ),
                    ),
                  ),
                ),

                // appbarItem, Image 위 텍스트 밑 버튼
                Positioned(
                  top: 125,
                  child: Container(
                    padding: EdgeInsets.only(left: 24, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FontStyle(
                            isEllipsis: false,
                            text: '일상의 작은변화,',
                            fontsize: "lg",
                            fontbold: "bold",
                            fontcolor: Colors.white,
                            textdirectionright: false),
                        FontStyle(
                            isEllipsis: false,
                            text: '니들크루와 함께 해보세요!',
                            fontsize: "lg",
                            fontbold: "bold",
                            fontcolor: Colors.white,
                            textdirectionright: false),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }),
        Positioned(
          bottom: 46,
          // heightFactor: 13,
          // alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(left: 24),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: homeInitService.banners.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _carouselController.animateToPage(entry.key),
                    child: Container(
                      width: 7.0,
                      height: 7.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: Colors.white,
                          ),
                          color: currentpage == entry.key
                              ? Colors.white.withOpacity(0.9)
                              : Colors.white.withOpacity(0.1)
                          // (Theme.of(context).brightness == Brightness.dark
                          //     ? Colors.white
                          //     : Colors.white)
                          // .withOpacity(
                          //     _carouselController == entry.key ? 0.9 : 0.1),
                          ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
