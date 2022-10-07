library wp_api;

import 'dart:async';
import 'dart:ffi';

import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/main.dart';
import 'package:needlecrew/models/billing_info.dart';
import 'package:needlecrew/screens/login/startPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:flutter_woocommerce_api/models/order_payload.dart';
import 'package:get/get.dart';

late FlutterWooCommerceApi wooCommerceApi;

late WooCustomer user;
var customer = "";

final baseUrl = "http://needlecrew.com";
var token = "";

var storage = FlutterSecureStorage();

final HomeController homecontroller = Get.put(HomeController());

// 회원가입
Future<void> joinUs(
    String name, String email, String password, String loginApp) async {
  print("wpapi joinUs email this        " + email);
  print("wpapi joinUs username this        " + name);
  print("wpapi joinUs password this        " + password);

  final int index = email.indexOf('@');
  final String userName = email.substring(0, index);

  // 회원가입 후 로그인 (email이 없을 경우 - 비회원) / 바로 로그인 (email이 있을 경우 - 회원)
  try {
    print("join user register init!!!!!!!");
    user = WooCustomer(
      username: userName,
      password: password,
      email: email,
      lastName: name.substring(0, 1),
      firstName: name.substring(1, name.length),
    );

    final result = wooCommerceApi.createCustomer(user);

    await result;

    // print("joinus this user " + result.toString());

    // final update = wooCommerceApi.updateCustomer(id: user.id!, data: {'phoneNum' : phoneNum});

    // await update;

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
  try {
    String userName = "";

    Map userInfo = {
      'phoneNum': '',
      'default_address': '',
      'company_address': '',
      'add_address1': '',
      'add_address2': '',
      'test_address': '',
      'default_card': '',
    };

    user =
        await wooCommerceApi.loginCustomer(username: email, password: password);

    List<WooCustomerMetaData> metadata = user.metaData!;

    if (user != null) {
      token = await wooCommerceApi.authenticateViaJWT(
          username: user.email, password: password);
      userName = user.lastName! + user.firstName!;
      print("login 성공!!!!!!!!" + user.toString());

      for (int i = 0; i < metadata.length; i++) {
        if (metadata[i].key == "phoneNum") {
          userInfo['phoneNum'] = metadata[i].value;
        } else if (metadata[i].key == "default_address") {
          userInfo['default_address'] = metadata[i].value;
        } else if (metadata[i].key == "default_card") {
          CardInfo cardInfo =
              await homecontroller.getCardInfo(metadata[i].value);
          userInfo['default_card'] = cardInfo.card_name +
              "(" +
              cardInfo.card_number.substring(12, 16) +
              ")";
        }
      }
      print(
          "wp-api add address init2!!!!!!" + user.billing!.address2.toString());
      if (user.billing!.company != "") {
        userInfo['company_address'] = user.billing!.company.toString();
      }
      if (user.billing!.address1 != "") {
        print("wp-api add address init!!!!!!");
        userInfo['test_address'] = user.billing!.address1.toString();
        userInfo['add_address1'] = user.billing!.address1.toString();
      }
      if (user.billing!.address2 != "") {
        userInfo['test_address'] += "," + user.billing!.address2.toString();
        userInfo['add_address2'] = user.billing!.address2.toString();
      }

      Get.toNamed('/mainHome');
    } else {
      print("login 실패!!!!!!!");
    }

    await storage.write(key: 'loginToken', value: token);
    await storage.write(key: 'username', value: userName);
    await storage.write(key: 'phoneNum', value: userInfo['phoneNum']);
    await storage.write(
        key: 'default_address', value: userInfo['default_address']);
    await storage.write(
        key: 'company_address', value: userInfo['company_address']);
    await storage.write(key: 'add_address1', value: userInfo['add_address1']);
    await storage.write(key: 'add_address2', value: userInfo['add_address2']);
    await storage.write(key: 'test_address', value: userInfo['test_address']);
    await storage.write(key: 'default_card', value: userInfo['default_card']);

    // String? thistoken = await storage.read(key: 'loginToken');
    print("login token " + token);
    print("login username " + userName);
    // print("storage token " + thistoken.toString());
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

// 로그인 유저 정보
Future<WooCustomer> getUser() async {
  user = WooCustomer();
  // token = "";
  try {
    int? userId = await wooCommerceApi.fetchLoggedInUserId();
    user = await wooCommerceApi.getCustomerById(id: userId);

    print("user " + user.toString());
    print("token " + token);
    return user;
  } catch (e) {
    if (e.toString().indexOf('jwt_auth_invalid_token') != -1) {
      logOut();
      print("Expired token - 재로그인");
    }
    print("wp-api - getUser info error" + e.toString());

    return user;
  }
}
