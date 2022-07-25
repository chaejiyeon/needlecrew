library wp_api;

import 'dart:async';
import 'dart:ffi';

import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/main.dart';
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


// 회원가입
Future<void> joinUs(
    String name, String email, String password, String phoneNum) async {
  final int index = email.indexOf('@');
  final String userName = email.substring(0, index);



  // 회원가입 후 로그인 (email이 없을 경우 - 비회원) / 바로 로그인 (email이 있을 경우 - 회원)
  try {

    user = WooCustomer(
        username: userName,
        password: password,
        email: email,
        lastName: name.substring(0, 1),
        firstName: name.substring(1, name.length),
        );

    final result = wooCommerceApi.createCustomer(user);

    await result;


    final update = wooCommerceApi.updateCustomer(id: user.id!, data: {'phoneNum' : phoneNum});

    await update;


    if (user.username != null) {
      print(user.username.toString() + "회원가입 성공");
    } else {
      print("error");
    }
  } catch (error) {
    if (error.toString().indexOf('registration-error-email-exists') != -1) {
      print("로그인");
    } else {
      print("isError $error");
    }
  }
}


Future<bool> Login(String email, String password) async {
  try{
    String userName = "";
    user = await wooCommerceApi.loginCustomer(username: email, password: password);

    if(user != null){
      token = await wooCommerceApi.authenticateViaJWT(username: user.email, password: password);
      userName = user.lastName! + user.firstName!;
      print("login 성공!!!!!!!!" + user.toString());

      Get.toNamed('/mainHome');
    }else{
      print("login 실패!!!!!!!");
      // joinUs(name, email, password, phoneNum);
      // token = await wooCommerceApi.authenticateViaJWT(username: user.email, password: password);
    }

    await storage.write(key: 'loginToken', value: token);
    await storage.write(key: 'username', value: userName);

    // String? thistoken = await storage.read(key: 'loginToken');
    print("login token " + token);
    print("login username " + userName);
    // print("storage token " + thistoken.toString());
  }catch(e){

    print("login errer $e");

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
    print("iserror" + e.toString());
    return user;
  }
}