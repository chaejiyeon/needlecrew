import 'dart:convert';
import 'dart:io';
import 'package:flutter_woocommerce_api/models/order_payload.dart';
import 'package:image/image.dart' as img;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:http/http.dart' as http;
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/models/media_uplaod_info.dart';

class FixSelectController extends GetxController {
  static FixSelectController get to => Get.find();

  final isInitialized = false.obs;

  // 쇼핑몰에서 보낼 경우
  RxBool isshopping = false.obs;

  // late LineItems lineitem;

  // 제품 선택 갯수
  late int selectCount = 1;

  RxInt categoryid = 0.obs;

  RxInt productid = 0.obs;

  // 총 비용
  RxInt wholePrice = 0.obs;

  RxMap radioGroup = {'variation_id': 0, "추가 옵션": "", "가격": ""}.obs;

  RxInt radioId = 0.obs;

  // 수선선택 상품 image url
  RxList getImages = [].obs;

  // 등록된 수선 상품 이미지 리스트
  RxList setImages = [].obs;

  // 수선선택 상품 compress image url
  RxList compressImages = [].obs;

  // 수선 선택 > 의뢰 방법
  RxString isSelected = "원하는 총 기장 길이 입력".obs;

  // 선택한 카테고리 Id list
  RxList crumbs = [].obs;

  // 선택한 수선 항목 ( ex| '하의', '바지', '청바지', '밑통줄임')
  RxList fixClothesInfo = [].obs;

  // back버튼 클릭 여부
  RxBool backClick = false.obs;

  // 사진 등록
  RxString uploadImg = "".obs;

  // product
  late WooProduct product;

  // category
  late WooProductCategory category;

  // option list
  late RxList variation = <WooProductVariation>[].obs;

  RxMap orderInfo = {
    '의뢰 방법': '',
    '치수': '',
    '사진': '',
    '물품 가액': '',
    '추가 옵션': '',
  }.obs;

  // 수선 선택한 사이즈 : 내 치수 불러오기
  RxInt selectSize = 0.obs;

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
      radioGroup["variation_id"] = groupValue["variation_id"];
      radioGroup["추가 옵션"] = groupValue["추가 옵션"];
      radioGroup["가격"] = groupValue["가격"];
    }
    print("추가 옵션: " + radioGroup.toString());

    update();
  }

  // 총 비용 설정
  void iswholePrice(int productPrice) {
    wholePrice.value = 0;
    wholePrice.value = productPrice + 6000;

    print("wholePrice " + wholePrice.value.toString());
    update();
  }

  // order 정보 등록
  void setOrderInfo(String key, dynamic value) {
    orderInfo[key] = value;

    update();
  }

  /// 치수 설정
  void setGetMySize(String type) {
    String firstChoose = fixClothesInfo.first;
    String searchType = '';
    String searchItem = '';

    printInfo(info: '0. set get my size type this $type $firstChoose');
    switch (firstChoose) {
      case '하의':
        String secondChoose = fixClothesInfo[1];
        printInfo(info: '1. set get my size type this $type $secondChoose');
        switch (secondChoose) {
          case '스커트':
            searchType = 'skirt';
            break;
          case '바지':
            searchType = 'pants';
            break;
        }

        break;
      case '정장/교복':
        String secondChoose = fixClothesInfo[2];
        if (secondChoose.contains('원피스')) {
          searchType = 'one_piece';
        } else if (secondChoose.contains('재킷')) {
          searchType = 'jacket';
        } else if (secondChoose.contains('스커트')) {
          searchType = 'skirt';
        } else if (secondChoose.contains('셔츠')) {
          searchType = 'shirt';
        } else if (secondChoose.contains('바지')) {
          searchType = 'pants';
        }
        break;
      case '원피스':
        searchType = 'one_piece';
        break;
      case '아우터':
        String secondChoose = fixClothesInfo[1];
        switch (secondChoose) {
          case '코트':
            searchType = 'coat';
            break;
          case '점퍼':
            searchType = 'jumper';
            break;
          case '재킷':
            searchType = 'jacket';
            break;
        }
        break;
      case '상의':
        searchType = 'shirt';
        break;
    }
    printInfo(
        info:
            'get size search ${homeInitService.getSizeList.indexWhere((element) => element.containsKey(searchType))}');
    selectSize.value = int.parse(returnItem(type, searchType));
  }

  /// 사이즈 세부 정보 설정
  String returnItem(String type, String searchType) {
    try {
      String searchItem = '';
      switch (type) {
        /// 하의
        case '전체 통 줄임':
          searchItem = homeInitService
              .getSizeList[homeInitService.getSizeList
                      .indexWhere((element) => element.containsKey(searchType))]
                  [searchType]
              .wholeWidth;
          break;
        case '힙 줄임':
          searchItem = homeInitService
              .getSizeList[homeInitService.getSizeList
                      .indexWhere((element) => element.containsKey(searchType))]
                  [searchType]
              .heap;
          break;
        case '총 기장 줄임':
          searchItem = homeInitService
              .getSizeList[homeInitService.getSizeList
                      .indexWhere((element) => element.containsKey(searchType))]
                  [searchType]
              .length;
          break;
        case '밑위 기장 줄임':
          searchItem = homeInitService
              .getSizeList[homeInitService.getSizeList
                      .indexWhere((element) => element.containsKey(searchType))]
                  [searchType]
              .riseLength;
          break;
        case '허리 줄임':
        case '허리 늘임':
          searchItem = homeInitService
              .getSizeList[homeInitService.getSizeList
                      .indexWhere((element) => element.containsKey(searchType))]
                  [searchType]
              .riseLength;
          break;

        /// 상의
        case '전체 품 줄임':
          searchItem = homeInitService
              .getSizeList[homeInitService.getSizeList
                      .indexWhere((element) => element.containsKey(searchType))]
                  [searchType]
              .width;
          break;
        case '소매 기장 줄임':
          searchItem = homeInitService
              .getSizeList[homeInitService.getSizeList
                      .indexWhere((element) => element.containsKey(searchType))]
                  [searchType]
              .sleeveLength;
          break;
        case '소매 통 줄임':
          searchItem = homeInitService
              .getSizeList[homeInitService.getSizeList
                      .indexWhere((element) => element.containsKey(searchType))]
                  [searchType]
              .sleeveWidth;
          break;
        case '민소매 암홀 줄임':
        case '민소매 암홀 늘임':
          searchItem = homeInitService
              .getSizeList[homeInitService.getSizeList
                      .indexWhere((element) => element.containsKey(searchType))]
                  [searchType]
              .sleeveLessLength;
          break;
        case '어깨+품 줄임':
          searchItem = homeInitService
              .getSizeList[homeInitService.getSizeList
                      .indexWhere((element) => element.containsKey(searchType))]
                  [searchType]
              .shoulderLength;
          break;
        case '목둘레 줄임':
          searchItem = homeInitService
              .getSizeList[homeInitService.getSizeList
                      .indexWhere((element) => element.containsKey(searchType))]
                  [searchType]
              .neckWidth;
          break;
        default:
          searchItem = '0';
          break;
      }
      printInfo(info: 'return item successed ============ $searchItem');
      return searchItem;
    } catch (e) {
      printInfo(info: 'return item failed ============ $e');
      return '0';
    }
  }

  // 해당 제품 정보 가져오기
  Future<bool> getProduct(int id) async {
    try {
      product = await wp_api.wooCommerceApi.getProductById(id: id);
      wholePrice.value = int.parse(product.price!) + 6000;
    } catch (e) {
      print("isError" + e.toString());
      return false;
    }

    print("product description this   " + product.description!);
    print("product subdescription this   " + product.shortDescription!);

    return true;
  }

  // detail 전 카테고리 가져오기
  Future<bool> getCategory(int thiscategoryid) async {
    category = WooProductCategory();

    try {
      category = await wp_api.wooCommerceApi
          .getProductCategoryById(categoryId: thiscategoryid);
    } catch (e) {
      print("isError" + e.toString());
      return false;
    }
    return true;
  }

  // option 항목 가져오기
  Future<bool> getVariation(int id) async {
    try {
      variation.clear();
      variation.value =
          await wp_api.wooCommerceApi.getProductVariations(productId: id);

      print(variation);
      return true;
    } catch (e) {
      print("isError" + e.toString());
      return false;
    }
  }

  //--------------- image upload -------------------//

  // convert Image png
  Map convertImage(File file) {
    final filePath = file.absolute.path;

    var lastIndex;

    // png로 변환한 파일
    File convertFile;

    final splitted;

    // 저장할 파일 이름
    final outPath;

    // image가 png가 아닐 경우 png로 convert
    if (filePath.lastIndexOf(RegExp(r'.jp')) != -1) {
      lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));

      // 파일 변환
      img.Image image = img.decodeImage(file.readAsBytesSync()) as img.Image;
      convertFile = File(filePath.substring(0, (lastIndex)) + ".png")
        ..writeAsBytesSync(img.encodePng(image));

      lastIndex = convertFile.absolute.path.lastIndexOf(RegExp(r'.png'));

      splitted = convertFile.absolute.path.substring(0, (lastIndex));

      outPath =
          "${splitted}_out${convertFile.absolute.path.substring(lastIndex)}";
      return {
        "absolute_path": convertFile.absolute.path,
        "target_path": outPath
      };
    } else if (filePath.lastIndexOf(RegExp(r'.png')) != -1) {
      lastIndex = filePath.lastIndexOf(RegExp(r'.png'));
      splitted = filePath.substring(0, (lastIndex));
      outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      return {"absolute_path": filePath, "target_path": outPath};
    }
    return {};
  }

  // 이미지 compress
  Future<void> compressFile(File file) async {
    Map ImgCvt = convertImage(file);

    var result = await FlutterImageCompress.compressAndGetFile(
        ImgCvt["absolute_path"], ImgCvt["target_path"],
        minWidth: 425, minHeight: 425, quality: 70, format: CompressFormat.png);

    print("compressImages this   " + ImgCvt.toString());
    await uploadFile(result!);
  }

  // 이미지 파일 업로드
  Future<bool> uploadFile(File filePath) async {
    try {
      printInfo(info: 'upload file path this $filePath');
      String? token = await wp_api.storage.read(key: 'login_token');
      print("this auth    " + token!);
      print("uint8list this    " + filePath.toString());
      String url = "https://needlecrew.com/wp-json/wp/v2/media";

      String fileName = filePath.path.split("/").last;

      //TODO image compress and convert to png mime
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer ${token}',
        'Content-Disposition': 'attachment; filename=$fileName',
        'Content-Type': 'image/png'
      };

      List<int> imageBytes = File(filePath.path).readAsBytesSync();
      var request = http.Request('POST', Uri.parse(url));
      request.headers.addAll(requestHeaders);
      request.bodyBytes = imageBytes;
      var res = await request.send();

      http.ByteStream streamInfo = res.stream;

      String imageInfo = await streamInfo.bytesToString();

      print("이미지 등록 " + imageInfo);

      var guid = MediaUploadInfo.fromJson(json.decode(imageInfo));

      print("이미지 등록 decode $guid");

      GuidInfo guidInfo;

      guidInfo = GuidInfo(rendered: guid.guid["rendered"]);

      if (guidInfo.rendered != "") {
        uploadImg.value +=
            guid.imageId.toString() + "|" + guidInfo.rendered + ",";
      }

      if (res.statusCode == 201)
        print("이미지 등록 완료");
      else
        print("이미지 등록 실패");

      print("등록 성공!!!!!!");
      return true;
    } catch (e) {
      print("FixselectController - uploadFile error $e");
      return false;
    }
  }

  // 이미지 업로드 시작
  Future<bool> uploadImage() async {
    compressImages.clear();

    try {
      printInfo(info: 'get images this $getImages');
      for (int i = 0; i < getImages.length; i++) {
        await compressFile(getImages[i]);
      }
      getImages.clear();
      return true;
    } catch (e) {
      print("isError $e");
      return false;
    }
  }

  /// 등록된 이미지 삭제
  Future delImage(List images) async {
    String query = Uri(queryParameters: {
      'consumer_key': '${wp_api.wooCommerceApi.consumerKey}',
      'consumer_secret': '${wp_api.wooCommerceApi.consumerSecret}',
    }).query;

    print("cartController - deleteImage init!!!!");

    try {
      for (int i = 0; i < images.length; i++) {
        List imageInfo = images[i].split('|');

        http.Response response = await http.post(
          Uri.parse("https://needlecrew.com/wp-json/wp/v2/media/" +
              imageInfo[0] +
              "?${query}"),
          headers: {
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
            // ''
            // 'Content-Type': 'multipart/form-data'
          },
        );

        print("CartController - deleteImage response " +
            response.body.toString());
      }
      print("CartController - deleteImage 성공!!!!");
      return true;
    } catch (e) {
      print("cartController - deleteImage error $e");
      return false;
    }
  }
}
