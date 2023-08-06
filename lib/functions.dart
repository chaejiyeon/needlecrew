import 'dart:developer';
import 'dart:io';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:needlecrew/controller/fix_clothes/fixselect_controller.dart';
import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_register_info.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/font_style.dart';

import 'bottomsheet/fix_size_guide_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class Functions {
  void payTypeAdd() {
    HomeController controller = Get.find();
    // if (paymentService.cardsInfo.length >= 1) {
    Get.to(FixRegisterInfo());
    // } else {
    //   Get.toNamed("/payTypeAdd");
    // }
  }

  /// bottom sheet open
  showBottomSheet(BuildContext context,
      {Color bottomSheetColor = Colors.white,
      double bottomSheetHeight = 500,
      double bottomSheetBorderRadius = 24,
      bool scrollBar = true,
      Widget? header,
      Widget? bottom}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(bottomSheetBorderRadius))),
        backgroundColor: bottomSheetColor,
        builder: (context) {
          return Container(
            height: bottomSheetHeight.h,
            child: Column(
              children: [
                scrollBar
                    ? Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(39),
                              topRight: Radius.circular(39)),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: 10.h),
                          height: 5.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50)),
                        ))
                    : Container(),
                header ?? Container(),
                Expanded(
                  child: SingleChildScrollView(child: bottom ?? Container()),
                )
              ],
            ),
          );
        });
  }

  /// size guide bottom sheet
  void showSizeGuideBottomSheet(BuildContext context) {
    showStickyFlexibleBottomSheet(
      minHeight: 0,
      initHeight: Platform.isAndroid ? 1 : 0.95,
      maxHeight: Platform.isAndroid ? 1 : 0.95,
      context: context,
      bottomSheetColor: Colors.transparent,
      isSafeArea: Platform.isAndroid ? true : false,
      headerHeight: 120.h,
      headerBuilder: (context, offset) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                ),
                padding: EdgeInsets.only(top: 10.h),
                alignment: Alignment.topCenter,
                height: 59,
                child: Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 24.w, right: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(
                        text: "치수 측정 가이드",
                        fontsize: "md",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    FontStyle(
                        text: "정확한 치수를 위해 바닥에 펴놓고 측정해주세요.",
                        fontsize: "",
                        fontbold: "",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                  ],
                ),
              )
            ],
          ),
        );
      },
      bodyBuilder: (context, offset) {
        return SliverChildListDelegate([
          // Container()
          FixSizeQuideSheet(),
        ]);
      },
    );
  }

  /// 이미지 리스트 셋팅
  setImageList({String imageType = '', image}) {
    List imageInfo = [];
    if (image.runtimeType != String) {
      for (String img in image) {
        if (img.contains('|')) {
          var splitImg = img.trim().split('|');
          if (splitImg[1] != '') {
            imageInfo.add(splitImg[1]);
          }
        }
      }
    } else {
      switch (imageType) {
        case 'list':
          var splitImages = image.split(',');
          for (String cvtImage in splitImages) {
            if (cvtImage.contains('|')) {
              var splitImg = cvtImage.trim().split('|');
              if (splitImg[1] != '') {
                imageInfo.add(splitImg[1]);
              }
            } else {
              if (image.length != 0) {
                imageInfo.add(image);
              }
            }
          }
          break;
        default:
          if (image.contains('|')) {
            imageInfo = image != "" ? image.trim().split('|') : [""];
          } else {
            if (image.length != 0) {
              imageInfo.add('image');
              imageInfo.add(image);
            }
          }
          break;
      }
    }

    imageInfo.remove('');

    log('88image list this ${imageInfo.length} $imageInfo');
    return imageInfo;
  }

  /// gallary 사진 가져오기
  void getGallaryImage() async {
    final FixSelectController controller = Get.find();
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    File dummyFile = File(file!.path);
    if (controller.getImages.length + controller.setImages.length < 10) {
      controller.getImages.add(dummyFile);
    } else {
      return;
    }

    Get.back();
  }

  /// camera 사진 가져오기
  void getCameraImage() async {
    final FixSelectController controller = Get.find();
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    File dummyFile = File(file!.path);
    if (controller.getImages.length + controller.setImages.length < 10) {
      controller.getImages.add(dummyFile);
    } else {
      return;
    }
    Get.back();
  }

  /// 고객센터 전화걸기
  makePhoneCall() async {
    var telUrl = '';
    if (GetPlatform.isIOS) {
      telUrl = '07080954668';
    } else {
      telUrl = '070-8095-4668';
    }
    try {
      printInfo(
          info: 'tel num this $telUrl ${Uri(
        scheme: 'tel',
        path: telUrl,
      )}');
      if (await canLaunchUrl(Uri(
        scheme: 'tel',
        path: telUrl,
      ))) {
        await launchUrl(Uri(scheme: 'tel', path: telUrl));
      }
      printInfo(info: 'call service center success ===========');
    } catch (e) {
      printInfo(info: 'call service center failed ===========\n $e');
    }
  }

  /// 옵션명 설정
  cvtOptionName(WooProductVariation? variation) {
    String optionName = "";

    if (variation != null) {
      if (variation!.attributes[0].option.toString().indexOf('%') != -1) {
        optionName =
            Uri.decodeComponent(variation.attributes[0].option.toString());
      } else {
        optionName = variation.attributes[0].option.toString();
      }
    }
    return optionName;
  }
}
