import 'dart:io';

import 'package:needlecrew/getxController/fixClothes/fixselectController.dart';
import 'package:needlecrew/modal/alertDialogYes.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  final String icon;
  final bool isShopping;

  const ImageUpload({Key? key, required this.icon, required this.isShopping})
      : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final FixSelectController controller = Get.put(FixSelectController());

  List<GetImageBtn> getBtn = [
    GetImageBtn("assets/icons/fixClothes/pictureIcon.svg", "갤러리에서 선택"),
    GetImageBtn("assets/icons/fixClothes/cameraIcon.svg", "사진 촬영")
  ];

  List<File> files = [];

  // gallary 사진 가져오기
  void getGallaryImage() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    File dummyFile = File(file!.path);
    setState(() {
      if (files.length < 10) {
        print("files " + files.toString());
        files.add(dummyFile);
        controller.getImages.add(dummyFile);
      } else {
        return;
      }
    });

    Get.back();
  }

  // camera 사진 가져오기
  void getCameraImage() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
    File dummyFile = File(file!.path);
    setState(() {
      if (files.length < 10) {
        files.add(dummyFile);
        controller.getImages.add(dummyFile);
      } else {
        return;
      }
    });
    Get.back();
  }

  // bottomsheet open
  void bottomsheetOpen(BuildContext context) {
    showStickyFlexibleBottomSheet(
      minHeight: 0,
      initHeight: widget.isShopping == true ? 0.55 : 0.7,
      maxHeight: widget.isShopping == true ? 0.55 : 0.7,
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
                      sampleImage(
                          "assets/images/useguide/sampleImage2.png", "수선부위 사진"),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: widget.isShopping == true ? 20 : 48),
                  child: Column(
                    children: List.generate(
                        widget.isShopping == true
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

  @override
  void initState() {
    print("ffff" + files.toString());
    super.initState();
  }

  @override
  void dispose() {
    print("ffff" + files.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (files.length < 10) {
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
                  SvgPicture.asset("assets/icons/fixClothes/" + widget.icon),
                  Text(
                    files.length.toString() + "/10",
                    style: TextStyle(
                      color: HexColor("#909090"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          files.length <= 0
              ? Container()
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          files.length, (index) => ImageCustom(files[index])),
                    ),
                  ),
                ),
        ],
      ),
    );
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
          getGallaryImage();
        } else if (getBtn.text == "사진 촬영") {
          getCameraImage();
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 37),
        margin: widget.isShopping == false ? EdgeInsets.only(bottom: 15) : null,
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
  Widget ImageCustom(File f) {
    return Container(
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
                  image: DecorationImage(
                    image: FileImage(f),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Positioned(
            top: 0,
            right: 5,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () {
                setState(() {
                  files.remove(f);
                });
                controller.deleteImage(f);
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
