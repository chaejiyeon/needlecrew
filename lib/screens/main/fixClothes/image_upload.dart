import 'package:needlecrew/controller/my_use_info/useInfo_controller.dart';
import 'package:needlecrew/functions.dart';
import 'package:needlecrew/modal/alert_dialog_yes.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/widgets/font_style.dart';

import '../../../controller/fix_clothes/fixselect_controller.dart';

class ImageUpload extends StatelessWidget {
  final String icon;
  final bool isShopping;

  const ImageUpload({Key? key, required this.icon, required this.isShopping})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FixSelectController controller = Get.find();
    final UseInfoController useInfoController = Get.find();

    List<GetImageBtn> getBtn = [
      GetImageBtn("assets/icons/fixClothes/pictureIcon.svg", "갤러리에서 선택"),
      GetImageBtn("assets/icons/fixClothes/cameraIcon.svg", "사진 촬영")
    ];

    // bottomsheet open
    void bottomsheetOpen(BuildContext context) {
      showStickyFlexibleBottomSheet(
        minHeight: 0,
        initHeight: isShopping == true ? 0.55 : 0.7,
        maxHeight: isShopping == true ? 0.55 : 0.7,
        context: context,
        bottomSheetColor: HexColor("#909090").withOpacity(0.2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        headerHeight: 65,
        headerBuilder: (context, offset) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                        color: HexColor("#707070"),
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 29, top: 14),
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      CupertinoIcons.xmark,
                      size: 20,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          );
        },
        bodyBuilder: (context, offset) {
          return SliverChildListDelegate([
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 24),
                    child: FontStyle(
                      text: "이런 사진이면 좋아요.",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      fontsize: "md",
                      textdirectionright: false,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 24, top: 10, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        sampleImage(
                            "assets/images/useguide/sampleImage.png", "전체 사진"),
                        SizedBox(
                          width: 11,
                        ),
                        sampleImage("assets/images/useguide/sampleImage2.png",
                            "수선부위 사진"),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 24, right: 24, top: isShopping == true ? 20 : 48),
                    child: Column(
                      children: List.generate(
                          isShopping == true
                              ? getBtn.length - 1
                              : getBtn.length,
                          (index) => getImageBtn(getBtn[index], index)),
                    ),
                  ),
                ],
              ),
            ),
          ]);
        },
      );
    }

    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (controller.getImages.length + controller.setImages.length <
                  10) {
                bottomsheetOpen(context);
              } else {
                Get.dialog(AlertDialogYes(titleText: "이미지는 10개까지 등록가능합니다."));
              }
            },
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(10),
              dashPattern: [5, 5],
              color: HexColor("#d5d5d5"),
              padding:
                  EdgeInsets.only(left: 35, right: 35, bottom: 25, top: 25),
              child: Column(
                children: [
                  SvgPicture.asset("assets/icons/fixClothes/$icon"),
                  Obx(
                    () => Text(
                      "${controller.getImages.length + controller.setImages.length}/10",
                      style: TextStyle(
                        color: HexColor("#909090"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Obx(() => isExist(controller.getImages, 'file')),
                  Obx(() => isExist(controller.setImages, 'list')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget isExist(List images, String type) {
    return images.isNotEmpty
        ? Row(
            children: List.generate(
                images.length, (index) => ImageCustom(type, images[index])),
          )
        : Container();
  }

  // bottomsheet Image
  Widget sampleImage(String img, String text) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 158,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              img,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(text),
      ],
    );
  }

  // button custom
  Widget getImageBtn(GetImageBtn getBtn, int index) {
    return GestureDetector(
      onTap: () {
        if (getBtn.text == "갤러리에서 선택") {
          Functions().getGallaryImage();
        } else if (getBtn.text == "사진 촬영") {
          Functions().getCameraImage();
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 37),
        margin: isShopping == false ? EdgeInsets.only(bottom: 15) : null,
        height: 54,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: HexColor("#d5d5d5"))),
        child: Row(
          children: [
            Container(
                width: 21, height: 19, child: SvgPicture.asset(getBtn.img)),
            SizedBox(
              width: 10,
            ),
            Text(getBtn.text),
          ],
        ),
      ),
    );
  }

  // getImage custom
  Widget ImageCustom(String imageType, dynamic f) {
    printInfo(info: 'image type $imageType image this $f');
    return Container(
      width: 110,
      height: 120,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: imageType == 'file'
                ? Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(f!),
                          fit: BoxFit.cover,
                        )),
                  )
                : Functions()
                        .setImageList(imageType: 'single', image: f)
                        .isNotEmpty
                    ? Container(
                        width: 110,
                        height: 120,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                      Functions().setImageList(
                                          imageType: 'single', image: f)[1],
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
          ),
          Positioned(
            top: 0,
            right: 5,
            child: imageType != 'file' &&
                    Functions()
                        .setImageList(imageType: 'single', image: f)
                        .isEmpty
                ? Container()
                : IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      FixSelectController controller = Get.find();
                      UseInfoController useInfoController = Get.find();

                      if (imageType == 'file') {
                        controller.getImages.remove(f);
                      } else {
                        controller.setImages.remove(f);

                        useInfoController.delImgs.add(f);
                      }
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/xmarkIcon_full_upload.svg",
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// 버튼 model
class GetImageBtn {
  final String img;
  final String text;

  GetImageBtn(
    this.img,
    this.text,
  );
}
