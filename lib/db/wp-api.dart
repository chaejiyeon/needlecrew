library wp_api;

import 'dart:async';
import 'dart:convert';

import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/getx_services/home_init_service.dart';
import 'package:needlecrew/getx_services/order_services.dart';
import 'package:needlecrew/getx_services/payment_service.dart';
import 'package:needlecrew/getx_services/product_services.dart';
import 'package:needlecrew/getx_services/update_user_service.dart';
import 'package:needlecrew/getx_services/utils_service.dart';
import 'package:needlecrew/models/address_item.dart';
import 'package:needlecrew/models/billing_info.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:get/get.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';

late FlutterWooCommerceApi wooCommerceApi;

var customer = "";

var token = "";

var storage = FlutterSecureStorage();

// final HomeController homecontroller = Get.put(HomeController());
final HomeInitService homeInitService = Get.put(HomeInitService());
final ProductServices productServices = Get.put(ProductServices());
final OrderServices orderServices = Get.put(OrderServices());
final PaymentService paymentService = Get.put(PaymentService());
final UtilsService utilsService = Get.put(UtilsService());
final UpdateUserService updateUserService = Get.put(UpdateUserService());

// 회원가입
Future<void> joinUs(
    String name, String email, String password, String loginApp) async {
  final int index = email.indexOf('@');
  final String userName = email.substring(0, index);

  homeInitService.loginLoading.value = true;
  // 회원가입 후 로그인 (email이 없을 경우 - 비회원) / 바로 로그인 (email이 있을 경우 - 회원)
  try {
    print("join user register init!!!!!!!");
    var user = WooCustomer();
    user = WooCustomer(
        username: userName,
        password: password,
        email: email,
        lastName: name.substring(0, 1),
        firstName: name.substring(1, name.length),
        metaData: [WooCustomerMetaData(null, 'gender', 'N')]);

    final result = wooCommerceApi.createCustomer(user);

    await result;

    if (user.username != null) {
      print(user.username.toString() + "회원가입 성공");
      if (loginApp == "apple" ||
          loginApp == "kakao" ||
          loginApp == "google" ||
          loginApp == "naver") {
        print("social login init");
        Login(email, password);
      }
    } else {
      print("error");
    }
  } catch (error) {
    if (error.toString().indexOf('registration-error-email-exists') != -1) {
      if (loginApp == "apple" ||
          loginApp == "kakao" ||
          loginApp == "google" ||
          loginApp == "naver") {
        print("social login init");
        Login(email, password);
      }
      print("로그인");
    } else {
      print("wp_api joinUs : $error");
    }
  }
}

// 로그인
Future<bool> Login(String email, String password) async {
  var user;
  try {
    String userName = "";

    Map userInfo = {
      'phone_number': '',
      'default_address': '',
      'company_address': '',
      'add_address1': '',
      'add_address2': '',
      'test_address': '',
      'default_card': '',
    };
    user =
        await wooCommerceApi.loginCustomer(username: email, password: password);
    print("1. login init !!!!!");

    if (user.runtimeType == WooCustomer && user.id != null) {
      List<WooCustomerMetaData> metadata = user.metaData!;
      print("2. login init !!!!!");
      token = await wooCommerceApi.authenticateViaJWT(
          username: user.email, password: password);
      userName = user.lastName! + user.firstName!;
      print("login 성공!!!!!!!!" + user.toString());

      int? setUserId = await wooCommerceApi.fetchLoggedInUserId();

      homeInitService.user.value.value =
          await wooCommerceApi.getCustomerById(id: setUserId);

      homeInitService.loginLoading.value = false;
      Get.offAllNamed('/mainHome');

      for (int i = 0; i < metadata.length; i++) {
        if (metadata[i].key == "phoneNum") {
          userInfo['phone_number'] = metadata[i].value;
        } else if (metadata[i].key == "default_address") {
          if (metadata[i].value != "") {
            var addressInfo = jsonDecode(metadata[i].value);
            addressInfo.forEach((key, value) => {
                  homeInitService.items.add(AddressItem(
                      key == 'home'
                          ? 0
                          : key == 'company'
                              ? 1
                              : 2,
                      key,
                      value))
                });

            userInfo['address'] = addressInfo['home'];
          }
        } else if (metadata[i].key == "default_card") {
          if (metadata[i].value != null || metadata[i].value != "") {
            CardInfo cardInfo =
                await paymentService.getCardInfo(metadata[i].value) ??
                    CardInfo();
            if (cardInfo.card_name != null)
              userInfo['default_card'] = cardInfo.card_name +
                  "(" +
                  cardInfo.card_number.substring(12, 16) +
                  ")";
          }
        }
      }
    } else {
      if (user.contains('오류')) {
        if (user.contains('비밀번호')) {
          homeInitService.loginLoading.value = false;
          Get.off(() => Get.dialog(
              barrierDismissible: false,
              CustomDialog(
                header: DialogHeader(
                  title: '로그인 실패',
                  content: '로그인 정보를 확인해주세요!',
                ),
                bottom: DialogBottom(isExpanded: true, btn: [
                  BtnModel(callback: () => Get.back(), text: '확인'),
                ]),
              )));
        }
      }
      print("login 실패!!!!!!! $user");
    }

    await storage.write(key: 'login_token', value: token);
    await storage.write(key: 'user_name', value: userName);

    print("login token " + token);
    print("login username " + userName);
  } catch (e) {
    print("login error $e");

    return false;
  }
  return true;
}

// 로그인 여부
Future<bool> isLogged() async {
  bool isLoggedIn = false;
  try {
    isLoggedIn = await wooCommerceApi.isCustomerLoggedIn();

    print("isLoggedIn " + isLoggedIn.toString());
  } catch (e) {
    print("isLogin Error " + e.toString());
    return false;
  }
  return isLoggedIn;
}

// 로그아웃
Future<void> logOut() async {
  FlutterNaverLogin.logOut();
  await wooCommerceApi.logUserOut();
  await storage.deleteAll();
  print("로그아웃");

  Get.offAndToNamed('/startPage');
}
