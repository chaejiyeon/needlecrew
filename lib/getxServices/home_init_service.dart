import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/models/address_item.dart';
import 'package:needlecrew/models/banner_item.dart';
import 'package:needlecrew/models/billing_info.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/wp_models/base_url.dart';
import 'package:needlecrew/screens/login/loading_page.dart';
import '../screens/main_page.dart';
import 'package:http/http.dart' as http;

class HomeInitService extends GetxService {
  late Stream stream;

  // user id
  RxInt userId = 0.obs;

  // user 정보 -UI
  RxMap userInfo = {
    'login_token': '',
    'user_name': '',
    'phone_number': '',
    'address': '',
    'default_card': ''
  }.obs;

  // user 정보
  var user = Rxn<WooCustomer>().obs;

  // 로그인에 따른 화면 설정
  var mainHome = Rxn<Widget>().obs;

  // 주소 목록
  RxList items = [].obs;

  // 카드 목록
  RxList cardItems = [].obs;

  // 메인 진입시 메인창 설정
  RxBool mainModalcheck = false.obs;

  // banner 목록
  var banners = List<BannerItem>.empty(growable: true).obs;

  // 로딩
  RxBool isLoading = false.obs;

  // 로그인 로딩
  RxBool loginLoading = false.obs;

  @override
  void onInit() async {
    await syncUser();
    await getBanner();

    ever<bool>(
        loginLoading,
        (callback) => {
              if (callback)
                {
                  Get.dialog(Center(
                    child: CircularProgressIndicator(
                      color: SetColor().mainColor,
                    ),
                  ))
                }
            });
    super.onInit();
  }

  /// 로그인 유저 정보
  Future syncUser() async {
    printInfo(info: 'init!!!!!!!!!');

    try {
      printInfo(info: '1. init!!!!!!!!! ');

      var login = await wp_api.isLogged();

      items.clear();

      printInfo(info: '2. init!!!!!!!!! $login');
      if (login) {
        int? setUserId = await wp_api.wooCommerceApi.fetchLoggedInUserId();

        printInfo(info: 'init!!!!!!!!! ${setUserId}');
        user.value.value =
            await wp_api.wooCommerceApi.getCustomerById(id: setUserId);
        printInfo(info: 'init!!!!!!!!! ${user.value.value!.username}');
        userId.value = setUserId!;

        List<WooCustomerMetaData> metadata = user.value.value!.metaData!;

        printInfo(info: "login 성공!!!!!!!! ${user.value!.toString()}");

        FlutterNativeSplash.remove();
        homeInitService.mainHome.value.value = MainPage(pageNum: 0);

        for (int i = 0; i < metadata.length; i++) {
          printInfo(info: 'metadata key this ${metadata[i].key}');
          if (metadata[i].key == "phoneNum") {
            userInfo['phone_number'] = metadata[i].value;
          } else if (metadata[i].key == "default_address") {
            if (metadata[i].value != "") {
              printInfo(info: 'address info ${metadata[i].value}');
              var addressInfo = jsonDecode(metadata[i].value);
              addressInfo.forEach((key, value) => {
                    printInfo(info: 'key this $key value this $value'),
                    items.add(AddressItem(
                        key == 'home'
                            ? 0
                            : key == 'company'
                                ? 1
                                : 2,
                        key,
                        value)),
                  });
              printInfo(info: 'address list length this ${items.length}');
              userInfo['address'] = addressInfo['home'];
            }
          } else if (metadata[i].key == "default_card") {
            printInfo(info: 'get card info this ${metadata[i].value}');
            if (metadata[i].value != null || metadata[i].value != "") {
              CardInfo cardInfo =
                  await paymentService.getCardInfo(metadata[i].value) ??
                      CardInfo();
              if (cardInfo.card_name != null) {
                userInfo['default_card'] = cardInfo.card_name +
                    "(" +
                    cardInfo.card_number.substring(12, 16) +
                    ")";
              }
            }
          } else if (metadata[i].key == 'pay_cards') {
            printInfo(info: 'get card info this ${metadata[i].value}');

            if (metadata[i].value != null || metadata[i].value != "") {
              if (metadata[i].value.contains(',')) {
                var getCardItems = metadata[i].value.split(',');
                for (String item in getCardItems) {
                  CardInfo cardInfo =
                      await paymentService.getCardInfo(item) ?? CardInfo();
                  if (cardInfo.card_name != null) {
                    cardItems.add(cardInfo);
                  }
                }
              } else {
                CardInfo cardInfo =
                    await paymentService.getCardInfo(metadata[i].value) ??
                        CardInfo();
                if (cardInfo.card_name != null) {
                  cardItems.add(cardInfo);
                }
              }
            }
          }
        }

        items.sort((a, b) => a.sort.compareTo(b.sort));

        print("user " + user.toString());
      } else {
        printInfo(info: "login 실패!!!!!!!! ${user.value!.toString()}");
        FlutterNativeSplash.remove();
        homeInitService.mainHome.value.value = LoadingPage();
      }
      return true;
    } catch (e) {
      print("wp-api - getUser info error" + e.toString());
      if (e.toString().indexOf('jwt_auth_invalid_token') != -1) {
        wp_api.logOut();
        print("Expired token - 재로그인");
      }
      print("wp-api - getUser info error" + e.toString());
      return false;
    }
  }

  /// banner 가져오기
  Future getBanner() async {
    banners.clear();

    try {
      /// url : 'https://needlecrew.com/wp-json/wp/v2/app_banner'
      var response = await http.get(
        Uri.https(baseUrl, wpBase + '/app_banner'),
      );

      printInfo(info: 'get banner this ${response.body}');

      var getBanners = jsonDecode(response.body);
      for (Map item in getBanners) {
        printInfo(info: 'item this $item');
        var getImage = await http.get(
            Uri.https(baseUrl, wpBase + '/media/${item['featured_media']}'));
        printInfo(info: 'get image this ${getImage.body}');
        var image = jsonDecode(getImage.body);
        printInfo(info: 'get image info $image');
        if (banners.isNotEmpty) {
          if (banners.indexWhere((element) => element.id == item['id']) == -1) {
            banners.add(BannerItem(
                id: item['id'].toString(),
                imageId: image['id'].toString(),
                title: item['title']['rendered'],
                imgUrl: image['guid']['rendered']));
          }
        } else {
          banners.add(BannerItem(
              id: item['id'].toString(),
              imageId: image['id'].toString(),
              title: item['title']['rendered'],
              imgUrl: image['guid']['rendered']));
        }
      }
      banners.refresh();
      printInfo(info: 'get banner success ===========${banners.length}');

      return true;
    } catch (e) {
      printInfo(
          info: '================ get banner failed ================= \n$e');

      return false;
    }
  }
}
