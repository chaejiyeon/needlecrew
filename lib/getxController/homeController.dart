import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/modal/alertDialogYes.dart';

import 'package:http/http.dart' as http;
import 'package:needlecrew/models/billing_info.dart';
import 'package:needlecrew/models/get_token.dart';

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
  // Map<String, String> updateName = {};
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

  // user login - 비밀번호
  RxString userPassword = "".obs;

  RxString loginCheck = "".obs;

  RxString token = "".obs;

  RxString joinError = "".obs;

  // user meta 정보
  RxString usersetPhone = "".obs;
  RxString usersetAddress = "".obs;
  RxString usersetPay = "".obs;

  // 치수
  RxList getsizeInfo = [].obs;

  // 카드 정보 등록
  Map cardInfo = {
    'card_number': '',
    'expiry': '',
    'birth': '',
    'pwd_2digit': '',
    'customer_uid': '',
  };

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
    print("mainmodalcheck this!!!!" + mainModalcheck.toString());
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

  // mypage user 정보 표시
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

  // user login
  Future<bool> LoginUs() async {
    final customer;

    print(
        'userinputinfo emaili this      ' + userInputInfo['email'].toString());
    print('userinputinfo emaili this      ' +
        userInputInfo['password'].toString());
    try {
      customer = await wp_api.wooCommerceApi.loginCustomer(
          username: userInputInfo['email'].toString(),
          password: userInputInfo['password'].toString());

      print("hhhhhhhhhhh  hhhh   hhh      " + customer.toString());

      if (customer.toString().indexOf('invalid_email') != -1 ||
          customer.toString().indexOf('invalid_username') != -1) {
        loginCheck.value = '이메일 주소를 확인해주세요.';
        print("로그인 실패! - 이메일 오류");
        Get.snackbar('로그인', '이메일 주소와 비밀번호를 입력해주세요');
        // update();
        return false;
      } else if (customer.toString().indexOf('incorrect_password') != -1) {
        loginCheck.value = '비밀번호가 일치하지 않습니다.';
        print("로그인 실패! - 비밀번호 오류 ${loginCheck.value}");
        Get.snackbar('로그인', '이메일 주소와 비밀번호를 입력해주세요');
        return false;
      } else {
        user = customer;
        String authToken = await wp_api.wooCommerceApi.authenticateViaJWT(
            username: userInputInfo['email'].toString(),
            password: userInputInfo['password'].toString());

        print("login storage username this  " +
            user.lastName.toString() +
            user.firstName.toString());
        print("login storage loginToken this  " + authToken);

        wp_api.storage.write(
            key: 'username',
            value: user.lastName.toString() + user.firstName.toString());
        wp_api.storage.write(key: 'loginToken', value: authToken);
        loginCheck.value = "";
        print("로그인 성공!!!!");
        Get.toNamed("/mainHome");
      }
    } catch (e) {
      print("login Error!!!!!!!!!!");
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

  // mypage controller

  // 유저 정보 업데이트
  Future<bool> updateUser(String updatename) async {
    print("textcontorller text " + textController.text + "update success!");
    try {
      if (textController.text != "") {
        await wp_api.wooCommerceApi.updateCustomer(id: user.id!, data: {
          'meta_data': [
            WooCustomerMetaData(null, updateName.value, textController.text)
          ]
        });
        Get.dialog(AlertDialogYes(
          titleText: updatename + "가 변경되었습니다!",
          widgetname: "updatePhoneNum",
        ));

        print("user " + updateName.value + "update success!");
      } else {
        Get.dialog(AlertDialogYes(titleText: updatename + "를 입력해주세요."));
      }
    } catch (e) {
      print("isError " + e.toString());
      return false;
    }
    return true;
  }

  // 치수 가져오기
  List getSize(String keyName) {
    getsizeInfo.clear();
    List<WooCustomerMetaData>? metaData = user.metaData;

    print("keyname this " + keyName);
    for (int i = 0; i < metaData!.length; i++) {
      print("get size for init!!!!!!");
      if (keyName == "상의") {
        print("getsize keyname  " + keyName);
        switch (metaData[i].key!) {
          case "shirt_width":
          case "shirt_necksize":
          case "shirt_sleeve_length":
          case "shirt_sleeve_width":
          case "shirt_sleeveless_length":
          case "shirt_shoulder_length":
            if (metaData[i].value != "") {
              getsizeInfo.add(metaData[i].value);
            } else {
              getsizeInfo.add("0");
            }
            break;
        }
      } else if (keyName == "바지") {
        print("getsize keyname  " + keyName);
        switch (metaData[i].key!) {
          case "pants_length":
          case "pants_rise_length":
          case "pants_waist":
          case "pants_wholebarrel":
          case "pants_heep":
            if (metaData[i].value != "") {
              getsizeInfo.add(metaData[i].value);
            } else {
              getsizeInfo.add("0");
            }
            break;
        }
      } else if (keyName == "스커트") {
        print("getsize keyname  " + keyName);
        switch (metaData[i].key!) {
          case "skirt_length":
          case "skirt_wholebarrel":
          case "skirt_heep":
            if (metaData[i].value != "") {
              getsizeInfo.add(metaData[i].value);
            } else {
              getsizeInfo.add("0");
            }
            break;
        }
      } else if (keyName == "원피스") {
        print("getsize keyname  " + keyName);
        switch (metaData[i].key!) {
          case "onepiece_length":
            if (metaData[i].value != "") {
              getsizeInfo.add(metaData[i].value);
            } else {
              getsizeInfo.add("0");
            }
            break;
        }
      }
    }
    print("get size map " + getsizeInfo.toString());
    return getsizeInfo;
  }

  // 주소
  void setCardInfo(Map registerCard) {
    cardInfo['card_number'] = registerCard['card_number'];
    cardInfo['expiry'] = registerCard['expiry'];
    cardInfo['birth'] = registerCard['birth'];
    cardInfo['pwd_2digit'] = registerCard['pwd_2digit'];
    cardInfo['customer_uid'] = registerCard['customer_uid'];

    update();
  }



  // 비인증 결제 카드빌키 요청
  Future getData() async {


    // iamport 인증 토큰 발급
    http.Response getToken = await http.post(
      Uri.http('api.iamport.kr', 'users/getToken'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "imp_key": "4893080572187074",
        "imp_secret":
            "3L0NLXEdPAyTpCtbPF1AILZYFwuHWviZgjN2hrg62OZrrtCh9DRRpRP4okMkP4k5o78FzoLBdL2FfFWo"
      }),
    );

    // 토큰 가져오기
    var token = Token.fromJson(json.decode(getToken.body));
    // 토큰 분리
    var access_token = GetToken.fromJson(token.response);

    // token 생성
    var postToken = "Bearer " + access_token.access_token;

    print(
        "iamport access_token this   " + access_token.access_token.toString());
    print("iamport access_token this   " + getToken.body.toString());
    print("customer_uid this   " + cardInfo['customer_uid'].toString());
    print("access_token this   " + postToken.toString());

    // 빌링키 발급 요청
    http.Response billingKey = await http.post(
      Uri.http(
          "api.iamport.kr", "subscribe/customers/${cardInfo["customer_uid"]}"),
      headers: {
        "Authorization": "Bearer ${access_token.access_token}"
      },
      body: jsonEncode({
        // "customer_uid" : cardInfo["customer_uid"],
        "card_number": cardInfo["card_number"],
        "expiry": cardInfo["expiry"],
        "birth": cardInfo["birth"],
        "pwd_2digit": cardInfo["pwd_2digit"],
        "pg_id" : "nice.nictest04m"
      }),
    );

    print("iamport billingKey this   " + billingKey.body.toString());

    // billing 정보 가져오기
    var getBilling = BillingInfo.fromJson(json.decode(billingKey.body));

    // billing에서 response 분리
    var billingInfo = CardInfo.fromJson(json.decode(getBilling.response));

    if (getBilling.code == 0) {
      // await wp_api.wooCommerceApi.updateCustomer(id: user.id!, data: {
      //   'meta_data': [
      //     WooCustomerMetaData(null, 'default_card', )
      //   ]
      // });
      print("Homecontroller - billingKey 발급 성공!!!" +
          json.decode(billingKey.body).toString());
    } else {
      if (getBilling.code == -1) {
        Get.dialog(AlertDialogYes(
            titleText: "입력된 정보를 확인해 주세요!", widgetname: "billing"));
      }
      return Exception("Homecontroller - billinKey 발급 Error!!!");
    }
  }

}
