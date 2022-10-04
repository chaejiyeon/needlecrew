import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

// import 'dart:math';
import 'dart:typed_data';

import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class FixSelectController extends GetxController {
  static FixSelectController get to => Get.find();

  final isInitialized = false.obs;

  // 쇼핑몰에서 보낼 경우
  RxBool isshopping = false.obs;

  late LineItems lineitem;

  // 제품 선택 갯수
  late int selectCount = 1;

  RxInt categoryid = 0.obs;

  RxInt productid = 0.obs;

  // 총 비용
  RxInt wholePrice = 0.obs;

  RxMap radioGroup = {"추가 옵션": "", "가격": ""}.obs;

  RxInt radioId = 0.obs;

  // 수선선택 상품 image url
  RxList getImages = [].obs;

  // 수선선택 상품 compress image url
  RxList compressImages = [].obs;

  // 수선 선택 > 의뢰 방법
  RxString isSelected = "원하는 총 기장 길이 입력".obs;

  // 선택한 카테고리 Id list
  RxList crumbs = [].obs;

  // back버튼 클릭 여부
  RxBool backClick = false.obs;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  @override
  void onClose() {
    isInitialized.value = false;
    super.onClose();
  }

  // 초기화
  Future<void> initialize() async {
    isInitialized.value = true;
    return;
  }

  // 쇼핑몰에서 보낼경우 확인
  void isShopping(bool isShopping) {
    isshopping.value = isShopping;
    update();
  }

  // productId 값 설정
  void isProductId(int productId) {
    productid.value = productId;
    update();
  }

  // categoryId 값 설정
  void isCategoryId(int categoryId) {
    categoryid.value = categoryId;
    update();
  }

  // 의뢰 방법 선택
  void isSelectedValue(String setValue) {
    isSelected.value = setValue;
    print("의뢰 방법: " + isSelected.value.toString());
    update();
  }

  // radio button (추가 옵션)
  void isRadioGroup(Map groupValue) {
    if (radioGroup["추가 옵션"] == groupValue["추가 옵션"]) {
      radioGroup["가격"] = groupValue["가격"];
    } else {
      radioGroup["추가 옵션"] = groupValue["추가 옵션"];
    }
    print("추가 옵션: " + radioGroup.toString());

    update();
  }

  // 총 비용 설정
  void iswholePrice(int price) {
    wholePrice.value = price;

    print("wholePrice " + wholePrice.value.toString());
    update();
  }

  // 수선접수 상품 이미지 삭제
  void deleteImage(File file) {
    for (int i = 0; i < getImages.length; i++) {
      if (getImages[i] == file) {
        getImages.remove(file);
      }
    }

    print("delImg this  " + getImages.length.toString());
    print("delImg this  " + getImages.toString());
    update();
  }

  // 이미지 compress
  Future<void> compressFile(File file) async {
    final filePath = file.absolute.path;

    var lastIndex;
    // = filePath.lastIndexOf(RegExp(r'.jp'));

    if (filePath.lastIndexOf(RegExp(r'.jp')) != -1) {
      lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    } else if (filePath.lastIndexOf(RegExp(r'.png')) != -1) {
      lastIndex = filePath.lastIndexOf(RegExp(r'.png'));
    }

    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, outPath,
        minWidth: 425,
        minHeight: 425,
        quality: 70,
        format: outPath.lastIndexOf(RegExp(r'.png')) != -1
            ? CompressFormat.png
            : CompressFormat.jpeg);

    // var result = await FlutterImageCompress.compressWithFile(
    //   file.absolute.path,
    //   minWidth: 1000,
    //   minHeight: 1000,
    //   quality: 94,
    // );
    // );

    // print(file.lengthSync());
    // print(result?.length);

    compressImages.add(result);
    print("compressImages this   " + compressImages.toString());
    for (int i = 0; i < compressImages.length; i++) {
      uploadFile(compressImages[i]);
    }
  }

  // 이미지 파일 업로드
  Future<bool> uploadFile(filePath) async {
    try {
      String? token = await wp_api.storage.read(key: 'loginToken');
      print("this auth    " + token!);
      print("uint8list this    " + filePath.toString());
      String url = "/wp-json/wp/v2/media";

      String fileName =
          (filePath.toString().split("/").last).replaceAll("'", "");

      // String fileName = String.fromCharCode(fileBytes);
      String storeImage = fileName.replaceAll('jpg', 'png');

      print("filenme this    " + storeImage);

      // Map<String, String> requestHeaders = {
      //   'Authorization': 'Bearer ${wp_api.token}',
      //   'Content-Disposition': 'attachment; filename=$storeImage',
      //   'Content-Type': 'image/png'
      // };

      // List<int> imageBytes = File(filePath.path).readAsBytesSync();

      // Image image = decodeImage()

      //TODO image compress and convert to png mime





      var request = await wp_api.wooCommerceApi.post(url, {
        'file': storeImage,
      });


      // var request = await http.post(
      //   Uri.https('needlecrew.com', url),
      //   headers: {
      //     'Authorization': '${token}',
      //     'Content-Disposition': 'attachment; filename=$storeImage',
      //     'Content-Type': 'image/png'
      //   },
      //   body: jsonEncode({
      //     'media_details': {
      //       'file': storeImage,
      //     }
      //   }),
      // );
      //
      print("updalad Image body this" + request.body.toString());
      // var request = http.Request('POST', Uri.parse(url));
      // request.headers.addAll(requestHeaders);
      // request.bodyBytes = imageBytes;
      // var res = await request.send();

      // return res.statusCode == 200 ? true : false;
      if (request.statusCode == 200) {
        print("등록 성공!!!!!!");
        return true;
      } else {
        log("등록 실패!!!!!! ${request.statusCode}");
        return false;
      }
    } catch (e) {
      print("isError $e");
      return false;
    }
  }

  // 이미지 업로드 시작
  void uploadImage() async {
    // print("getImages this   " + getImages.toString());
    try {
      for (int i = 0; i < getImages.length; i++) {
        compressFile(getImages[i]);
      }
    } catch (e) {
      print("isError $e");
    }
  }
}
