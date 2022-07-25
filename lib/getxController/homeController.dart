import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final isInitialized = false.obs;

  // // login storage
  // var storage = FlutterSecureStorage();

  // user update 내용
  final textController = TextEditingController();

  RxBool mainModalcheck = false.obs;

  // user 정보
  late WooCustomer user;

  // user update 항목
  RxString updateName = "".obs;

  Map<String, String> userInputInfo = {
    "gender": "F",
    "user_name": "이름",
    "email": "이메일 주소",
    "password": "비밀번호",
    "phoneNum": "010123123123",
  }.obs; // userJoin[0] : 성별 / userJoin[1] : 이름 / userJoin[2] : email / userJoin[3] : password / userJoin[4] : phoneNumber

  // user login - email
  RxString userEmail = "".obs;

  //
  // // user join - 이메일 주소
  // RxString userEmail = "".obs;
  //
  // user login - 비밀번호
  RxString userPassword = "".obs;

  RxString loginCheck = "".obs;

  RxString token = "".obs;

  RxString joinError = "".obs;

  // user meta 정보
  RxString usersetPhone = "".obs;
  RxString usersetAddress = "".obs;
  RxString usersetPay = "".obs;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  @override
  void onClose() {
    isInitialized.value = false;
    mainModalcheck.value = false;
    super.onClose();
  }

  // 닫기 버튼 눌렸을 때
  void isMainmodal(bool isClose) {
    mainModalcheck.value = isClose;

    update();
  }

  // 회원정보 업데이트
  void updateUserInfo(String fieldName) {
    updateName.value = fieldName;

    update();
  }

  // 회원 가입 정보 저장
  void setUserInfo(String key, String value) {
    userInputInfo[key] = value;
    print("joinUserInfo added !" + userInputInfo.toString());
    update();
  }

  // login
  void loginUser(String email, String password) {
    userEmail.value = email;
    userPassword.value = password;

    update();
  }

  String userInfo(String userinfo) {
    List<WooCustomerMetaData>? metaData = user.metaData;

    for (int i = 0; i < metaData!.length; i++) {
      if (userinfo == "전화번호") {
        if (metaData[i].key == "phoneNum") {
          usersetPhone.value = metaData[i].value;
          return usersetPhone.value;
        }
      } else if (userinfo == "주소") {
        if (metaData[i].key == "default_address") {
          usersetAddress.value = metaData[i].value;
          return usersetAddress.value;
        }
      } else if (userinfo == "결제 수단") {
        if (metaData[i].key == "default_card") {
          usersetPay.value = metaData[i].value;
          return usersetPay.value;
        }
      }
    }
    return "";
  }

  // 초기화
  Future<void> initialize() async {
    await getUser();
    isInitialized.value = true;
    return;
  }

  // 해당 유저에 정보
  Future<bool> getUser() async {
    try {
      user = await wp_api.getUser();
      token = await wp_api.wooCommerceApi
          .authenticateViaJWT(username: user.email, password: user.password);
      print("user info " + user.toString());
    } catch (e) {
      print("isError " + e.toString());
      return false;
    }
    return true;
  }

  // 유저 정보 업데이트
  Future<bool> updateUser() async {
    print("textcontorller text " + textController.text + "update success!");
    try {
      await wp_api.wooCommerceApi.updateCustomer(
          id: user.id!, data: {updateName.value: textController.text});

      print("user " + updateName.value + "update success!");
    } catch (e) {
      print("isError " + e.toString());
      return false;
    }
    return true;
  }

  // user login
  Future<bool> LoginUs(String email, String password) async {
    final customer = await wp_api.wooCommerceApi.loginCustomer(
        username: userInputInfo['email'].toString(),
        password: userInputInfo['password'].toString());

    try {
      print("this login " + customer.toString());
      try {
        await wp_api.Login(userInputInfo['email'].toString(),
            userInputInfo['password'].toString());
        user = await wp_api.getUser();

        loginCheck.value = "";
        print("로그인 성공!!!!");
        Get.toNamed("/mainHome");
      } catch (e) {
        print("Homecontorller loginus error   $e");
      }
    } catch (e) {
      if (customer.toString().indexOf('invalid_email') != -1 ||
          customer.toString().indexOf('invalid_username') != -1) {
        loginCheck.value = '이메일 주소를 확인해주세요.';
        print("로그인 실패! - 이메일 오류");
        update();
        return false;
      } else if (customer.toString().indexOf('incorrect_password') != -1) {
        loginCheck.value = '비밀번호가 일치하지 않습니다.';
        print("로그인 실패! - 비밀번호 오류 ${loginCheck.value}");
        return false;
      }
    }

    return true;
  }

  // user join (회원가입)
  Future<bool> JoinUs() async {
    try {
      WooCustomer user = WooCustomer(
          username: Uuid().v1(),
          password: userInputInfo['password'],
          email: userInputInfo['email'],
          lastName: userInputInfo['user_name'].toString().substring(0, 1),
          firstName: userInputInfo['user_name'].toString().substring(1),
          metaData: [
            WooCustomerMetaData(
                null, 'phoneNum', userInputInfo['phoneNum'].toString()),
            WooCustomerMetaData(
                null, 'gender', userInputInfo['gender'].toString())
          ]);

      final result = await wp_api.wooCommerceApi.createCustomer(user);
      if (result) {
        print("complete logged user " + result.toString());
        await wp_api.Login(userInputInfo['email'].toString(),
            userInputInfo['password'].toString());
        user = await wp_api.getUser();
      } else {
        print("가입 실패");
      }

      Get.toNamed("/mainHome");
    } catch (e) {
      print("JoinUs Error $e");

      if (e.toString().indexOf('registration-error-email-exists') != -1) {
        joinError.value = "회원님의 이메일 주소로 이미 계정이 등록되어 있습니다.";
      }
      Get.snackbar("회원가입 오류", joinError.value);
      return false;
    }
    return true;
  }
}
