import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/my_use_info/useInfo_controller.dart';
import 'package:needlecrew/functions.dart';

class ImageInfoModal extends StatefulWidget {
  const ImageInfoModal({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageInfoModal> createState() => _ImageInfoModalState();
}

class _ImageInfoModalState extends State<ImageInfoModal> {
  final UseInfoController controller = Get.find();

  List images = [
    "assets/images/sample_2.jpeg",
    "assets/images/sample_2.jpeg",
    "assets/images/sample_2.jpeg",
    "assets/images/sample_2.jpeg",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.zero,
          child: Column(children: [
            Expanded(
              child: Container(
                child: CarouselSlider(
                  items: List.generate(
                      controller.orderMetaData['사진'].length,
                      (index) => Container(
                          width: 280.w,
                          height: 280.h,
                          margin: EdgeInsets.only(right: 20.w),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                Functions().setImageList(
                                    image: controller.orderMetaData['사진']
                                        [index])[1],
                                fit: BoxFit.cover,
                              )))),
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    scrollDirection: Axis.horizontal,
                    height: 280,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                // behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.back();
                },
                child: Container(
                    margin: EdgeInsets.only(bottom: 57.h, right: 24.w),
                    alignment: Alignment.center,
                    width: 117,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Colors.white,
                    ),
                    child: Text("확인")),
              ),
            ),
          ]),
        ));
  }
}
