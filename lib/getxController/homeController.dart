import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/modal/alertDialogYes.dart';

import 'package:http/http.dart' as http;
import 'package:needlecrew/models/addressItem.dart';
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
    'name': '',
    'email': '',
    'card_name': '',
    'card_number': '',
    'expiry': '',
    'birth': '',
    'pwd_2digit': '',
    'customer_uid': '',
  };

  // billing key 발급 된 사용가능 카드 목록
  RxList cardsBillkey = [].obs;
  List<CardInfo> cardsInfo = [];

  // getOrder
  Map orderMap = {
    'order_no': '',
    'order_item': '',
    'order_price': '',
    'shipp_cost': '6000',
    'total_price': 0,
  };

  // 결제 요청 정보
  RxMap payment = {
    'customer_uid': '',
    'merchant_uid': '',
    'amount': 0,
    'name': '',
  }.obs;


  // 마이페이지 정보
  Map userInfo = {
    'username': '',
    'phoneNum': '',
    'default_address' : '',
    'default_card': '',
  };


  // 주소 목록
  List<AddressItem> items = [];

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

  // 초기화
  Future<void> initialize() async {
    await getUser();
    isInitialized.value = true;
    return;
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


  // 단위 변환
  String setPrice(int price) {
    String setPrice = NumberFormat('###,###,###').format(price);
    update();
    return setPrice;
  }


  // 회원 정보 storage에서 가져오기
  Stream getUserInfo() async* {
    userInfo['username'] = await wp_api.storage.read(key: 'username');
    userInfo['phoneNum'] = await wp_api.storage.read(key: 'phoneNum');
    userInfo['default_address'] =
        await wp_api.storage.read(key: 'default_address');
    userInfo['default_card'] = await wp_api.storage.read(key: 'default_card');

    print("HomeController - getUserInfo " + userInfo.toString());

    yield userInfo;
  }


  // 해당 유저에 정보
  Future getUser() async{
    items.clear();

    try {
      user = await wp_api.getUser();
      token = await wp_api.wooCommerceApi
          .authenticateViaJWT(username: user.email, password: user.password);

      List<WooCustomerMetaData> metadata = user.metaData!;

      print("user metadata this " + metadata.toString());

      for(int i=0; i<metadata.length; i++){
        if(metadata[i].key == "default_address") {
          items.add(AddressItem("우리집", metadata[i].value));
        }else if(metadata[i].key == "billing_company"){
          items.add(AddressItem("회사", metadata[i].value));
        }else if(metadata[i].key == "billing_address_1" || metadata[i].key == "billing_address_2"){
          items.add(AddressItem("기타", metadata[i].value));
        }
      }

      print("user info " + user.toString());
      return user;
    } catch (e) {
      print("isError " + e.toString());
      // return false;
    }
    // return true;
  }

  // getOrder
  Future orderInfo(int orderid) async {
    WooOrder order = await wp_api.wooCommerceApi.getOrderById(orderid);
    try {
      orderMap['order_no'] = order.number;
      orderMap['order_item'] = order.lineItems!.first.name;
      orderMap['order_price'] = order.lineItems!.first.price;
      orderMap['total_price'] =
          int.parse(order.lineItems!.first.price.toString()) +
              int.parse(orderMap['shipp_cost']);

      print(orderMap);
    } catch (e) {
      print("HomeController - orderInfo Error" + e.toString());
    }
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

  // ***mypage controller***

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

        await wp_api.storage.delete(key: 'phoneNum');
        await wp_api.storage.write(key: 'phoneNum', value: textController.text);

        String? phonenum = await wp_api.storage.read(key: 'phoneNum');

        print("user " + updateName.value + "update success!");
        print("user " + updateName.value + phonenum.toString());
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
    cardInfo['name'] = registerCard['name'];
    cardInfo['email'] = registerCard['email'];
    cardInfo['card_number'] = registerCard['card_number'];
    cardInfo['expiry'] = registerCard['expiry'];
    cardInfo['birth'] = registerCard['birth'];
    cardInfo['pwd_2digit'] = registerCard['pwd_2digit'];
    cardInfo['customer_uid'] = registerCard['customer_uid'];

    update();
  }

  // *** useinfo controller ***

  //  api 요청에 필요한 token 발급
  Future<GetToken> getToken() async {
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

    return access_token;
  }

  // 비인증 결제 카드빌키 요청
  Future<bool> getData() async {
    GetToken tokenInfo = await getToken();

    print("getData   " + cardInfo.toString());

    // 빌링키 발급 요청
    http.Response billingKey = await http.post(
      Uri.https(
          "api.iamport.kr", "subscribe/customers/${cardInfo["customer_uid"]}"),
      headers: {
        "Authorization": "${tokenInfo.access_token}",
      },
      body: {
        "customer_name": cardInfo["name"],
        "customer_email": cardInfo["email"],
        "card_number": cardInfo["card_number"],
        "expiry": cardInfo["expiry"],
        "birth": cardInfo["birth"],
        "pwd_2digit": cardInfo["pwd_2digit"],
        "pg": "nice.nictest04m" // 나이스페이먼츠
      },
    );

    print("iamport billingKey this   " + billingKey.body.toString());

    // billing 정보 가져오기
    var getBilling = BillingInfo.fromJson(json.decode(billingKey.body));

    if (getBilling.code == 0) {
      await wp_api.wooCommerceApi.updateCustomer(id: user.id!, data: {
        'meta_data': [
          WooCustomerMetaData(null, 'default_card', cardInfo['customer_uid'])
        ]
      });
      print("Homecontroller - billingKey 발급 성공!!!");
      return true;
    } else {
      Get.dialog(
          AlertDialogYes(titleText: "입력된 정보를 확인해 주세요!", widgetname: "billing"));
      return false;
    }
  }

  // 특정 카드 정보 가져오기
  Future getCardInfo(String billingKey) async {
    try {
      GetToken tokenInfo = await getToken();

      // billing 정보 요청
      http.Response response = await http.get(
        Uri.https("api.iamport.kr", "/subscribe/customers/${billingKey}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "${tokenInfo.access_token}",
        },
      );

      print("response" + response.body);
      // billing 정보 가져오기
      var getBilling = BillingInfo.fromJson(json.decode(response.body));

      // card 정보 가져오기
      var getCard = CardInfo.fromJson(getBilling.response);

      // if (getBilling.code == 0) {
      // cardsInfo.add(CardInfo(
      //   customer_uid: getCard.customer_uid,
      //   customer_name: getCard.customer_name,
      //   customer_email: getCard.customer_email,
      //   card_name: getCard.card_name,
      //   card_number: getCard.card_number,
      // ));

      return CardInfo(
        customer_uid: getCard.customer_uid,
        customer_name: getCard.customer_name,
        customer_email: getCard.customer_email,
        card_name: getCard.card_name,
        card_number: getCard.card_number,
      );


    } catch (e) {
      print("HomeController - getCardInfo error" + e.toString());
    }
  }

  // 전체 카드 정보 가져오기
  Future getCardAll() async {
    cardsBillkey.clear();
    cardsInfo.clear();
    getUser();

    List<WooCustomerMetaData> metaData = user.metaData!;

    try {
      GetToken token = await getToken();

      for (int i = 0; i < metaData.length!; i++) {
        if (metaData[i].key == "default_card" && metaData[i].key!.isNotEmpty) {
          cardsBillkey.add(metaData[i].value);
        } else if (metaData[i].key == "pay_cards" &&
            metaData[i].key!.isNotEmpty) {
          List dataSplit = metaData[i].value.split(' ');
          for (int j = 0; j < dataSplit.length; j++) {
            cardsBillkey.add(dataSplit[j]);
          }
        }
      }

      Map<String, dynamic> parameter = {"customer_uid[]": cardsBillkey};

      http.Response response = await http.get(
        Uri.https("api.iamport.kr", "subscribe/customers", parameter),
        headers: {
          "Authorization": "${token.access_token}",
        },
      );

      var body = BillingInfo.fromJson(json.decode(response.body));

      print(body.response.toString());

      for (int i = 0; i < body.response.length; i++) {
        CardInfo cardInfo = CardInfo(
            card_name: body.response[i]['card_name'],
            card_number: body.response[i]['card_number'],
            customer_name: body.response[i]['customer_name'],
            customer_email: body.response[i]['customer_email'],
            customer_uid: body.response[i]['customer_uid']);

        cardsInfo.add(cardInfo);
      }

      print("cardsInfo " + cardsInfo.toString());

      update();
      cardsBillkey.refresh();

      print("HomeController - getCardAll" + cardsBillkey.toString());
    } catch (e) {
      print("HomeController - getCardAll Error " + e.toString());
    }

    // print(response.body);
  }

  // 결제 요청
  Future<bool> payMent() async {
    try {
      GetToken token = await getToken();

      print(payment['customer_uid']);
      http.Response response = await http.post(
          Uri.https("api.iamport.kr", "subscribe/payments/again"),
          headers: {
            "Authorization": "${token.access_token}"
          },
          body: {
            'customer_uid': payment['customer_uid'],
            'merchant_uid': payment['merchant_uid'],
            'amount': payment['amount'].toString(),
            'name': payment['name'],
          });
      print("response this" + response.toString());

      var paymentResult = BillingInfo.fromJson(json.decode(response.body));

      print("paymentResult" + response.body.toString());
      print("paymentResult code" + paymentResult.code.toString());

      if (paymentResult.code == 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("HomeController - payMent Error " + e.toString());
      return false;
    }
  }
}
