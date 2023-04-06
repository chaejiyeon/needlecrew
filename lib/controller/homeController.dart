import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/modal/alert_dialog_yes.dart';

import 'package:http/http.dart' as http;
import 'package:needlecrew/models/address_item.dart';
import 'package:needlecrew/models/billing_info.dart';
import 'package:needlecrew/models/get_token.dart';
import 'package:needlecrew/models/get_user.dart';
import 'package:needlecrew/models/wp_models/wp_size_model.dart';
import 'package:needlecrew/screens/main/myPage/user_info.dart';

import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final isInitialized = false.obs;

  // user update 내용
  late TextEditingController textController = TextEditingController();

  // 업데이트 필드이름
  RxString updateName = "".obs;

  // 업데이트 내용
  RxString updateText = "".obs;

  // user 정보
  late WooCustomer user = WooCustomer();

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
  List getsizeInfo = [];

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  @override
  void onClose() {
    isInitialized.value = false;
    homeInitService.mainModalcheck.value = false;
    super.onClose();
  }

  /// 초기화
  Future<void> initialize() async {
    // await getCardAll();
    isInitialized.value = true;
    return;
  }

  /// 닫기 버튼 눌렸을 때
  void isMainmodal(bool isClose) {
    homeInitService.mainModalcheck.value = isClose;
    print(
        "mainmodalcheck this!!!!" + homeInitService.mainModalcheck.toString());
    update();
  }

  /// 회원정보 업데이트
  void updateUserInfo(String fieldName) {
    updateName.value = fieldName;

    update();
  }

  /// 회원 가입 정보 저장
  void setUserInfo(String key, String value) {
    userInputInfo[key] = value;
    print("joinUserInfo added !" + userInputInfo.toString());
    update();
  }

  /// login
  void loginUser(String email, String password) {
    userEmail.value = email;
    userPassword.value = password;

    update();
  }

  /// 단위 변환
  String setPrice(int price) {
    String setPrice = NumberFormat('###,###,###').format(price);
    update();
    return setPrice;
  }

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
        String authToken = await wp_api.wooCommerceApi.authenticateViaJWT(
            username: userInputInfo['email'].toString(),
            password: userInputInfo['password'].toString());

        int? userId = await wp_api.wooCommerceApi.fetchLoggedInUserId();
        homeInitService.user.value.value =
            await wp_api.wooCommerceApi.getCustomerById(id: userId);

        for (int i = 0;
            i < homeInitService.user.value.value!.metaData!.length;
            i++) {
          printInfo(
              info:
                  'metadata key this ${homeInitService.user.value.value!.metaData![i].key}');
          if (homeInitService.user.value.value!.metaData![i].key ==
              "phoneNum") {
            homeInitService.userInfo['phone_number'] =
                homeInitService.user.value.value!.metaData![i].value;
          } else if (homeInitService.user.value.value!.metaData![i].key ==
              "default_address") {
            if (homeInitService.user.value.value!.metaData![i].value != "") {
              printInfo(
                  info:
                      'address info ${homeInitService.user.value.value!.metaData![i].value}');
              var addressInfo = jsonDecode(
                  homeInitService.user.value.value!.metaData![i].value);
              addressInfo.forEach((key, value) => {
                    printInfo(info: 'key this $key value this $value'),
                    homeInitService.items.add(AddressItem(
                        key == 'home'
                            ? 0
                            : key == 'company'
                                ? 1
                                : 2,
                        key,
                        value)),
                  });
              printInfo(
                  info:
                      'address list length this ${homeInitService.items.length}');
              homeInitService.userInfo['address'] = addressInfo['home'];
            }
          } else if (homeInitService.user.value.value!.metaData![i].key ==
              "default_card") {
            printInfo(
                info:
                    'get card info this ${homeInitService.user.value.value!.metaData![i].value}');
            if (homeInitService.user.value.value!.metaData![i].value != null ||
                homeInitService.user.value.value!.metaData![i].value != "") {
              CardInfo cardInfo = await paymentService.getCardInfo(
                      homeInitService.user.value.value!.metaData![i].value) ??
                  CardInfo();
              if (cardInfo.card_name != null) {
                homeInitService.userInfo['default_card'] = cardInfo.card_name +
                    "(" +
                    cardInfo.card_number.substring(12, 16) +
                    ")";
              }
            }
          } else if (homeInitService.user.value.value!.metaData![i].key ==
              "pay_cards") {
            if (homeInitService.user.value.value!.metaData![i].value != null ||
                homeInitService.user.value.value!.metaData![i].value != "") {
              if (homeInitService.user.value.value!.metaData![i].value
                  .contains(',')) {
                var getCardItems = homeInitService
                    .user.value.value!.metaData![i].value
                    .split(',');
                for (String item in getCardItems) {
                  CardInfo cardInfo =
                      await paymentService.getCardInfo(item) ?? CardInfo();
                  if (cardInfo.card_name != null) {
                    homeInitService.cardItems.add(cardInfo);
                  }
                }
              } else {
                CardInfo cardInfo = await paymentService.getCardInfo(
                        homeInitService.user.value.value!.metaData![i].value) ??
                    CardInfo();
                if (cardInfo.card_name != null) {
                  homeInitService.cardItems.add(cardInfo);
                }
              }
            }
          }
        }

        print("login storage username this  " +
            user.lastName.toString() +
            user.firstName.toString());
        print("login storage loginToken this  " + authToken);

        wp_api.storage.write(
            key: 'user_name',
            value: user.firstName.toString() + user.lastName.toString());
        wp_api.storage.write(key: 'login_token', value: authToken);
        loginCheck.value = "";

        Get.offAllNamed("/mainHome");
      }
    } catch (e) {
      print("login Error!!!!!!!!!! $e");
    }

    return true;
  }

  /// user join (회원가입)
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
      } else {
        print("가입 실패");
      }

      Get.offAllNamed("/mainHome");
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

  /// user 회원탈퇴
  Future JoinOut() async {
    try {
      String query = Uri(queryParameters: {
        'consumer_key': '${wp_api.wooCommerceApi.consumerKey}',
        'consumer_secret': '${wp_api.wooCommerceApi.consumerSecret}',
      }).query;

      http.Response response = await http.delete(
        Uri.parse("https://needlecrew.com/wc-api/v2/customers/" +
            homeInitService.user.value.value!.id!.toString() +
            "?${query}"),
        headers: {
          'Accept-Encoding': 'gzip, deflate, br',
          'Connection': 'keep-alive',
          'Content-Type': 'multipart/form-data'
        },
      );
      print("HomeController - JoinOut " + response.body.toString());

      await wp_api.storage.deleteAll();

      Get.offAndToNamed('/startPage');

      print("HomeController - JoinOut 회원탈퇴 완료");
    } catch (e) {
      print("HomeController - JoinOut 회원탈퇴 실패 " + e.toString());
    }
  }

  // ***mypage controller***

  /// 주소 업데이트
  Future<bool> updateAddress(String type) async {
    try {
      printInfo(info: 'address update this ${homeInitService.items.length}');
      var setMetaData = '{';

      if (homeInitService.items.isNotEmpty) {
        if (homeInitService.items.indexWhere(
                (element) => element.addressType == updateName.value) ==
            -1) {
          printInfo(
              info: '1. address update this ${homeInitService.items.length}');
          if (homeInitService.items.indexWhere((element) =>
                  element.addressType.contains(updateName.value)) ==
              -1) {
            // home || company
            homeInitService.items.add(AddressItem(
                updateName.value == 'home' ? 0 : 1,
                updateName.value,
                updateText.value + ',' + textController.text));
          } else {
            // add_address 가 포함 되어 있을경우
            var addressTypeSet = updateName.value.split('_');
            if (addressTypeSet.length == 5) {
              homeInitService.items.add(AddressItem(
                2,
                '${updateName.value}_${int.parse(addressTypeSet[addressTypeSet.length]) + 1}',
                updateText.value + ',' + textController.text,
              ));
            } else {
              homeInitService.items.add(AddressItem(
                2,
                '${updateName.value}_1',
                updateText.value + ',' + textController.text,
              ));
            }
          }
        } else {
          if (updateName.value == 'home' || updateName.value == 'company') {
            homeInitService.items.removeAt(homeInitService.items.indexWhere(
                (element) => element.addressType == updateName.value));

            homeInitService.items.add(AddressItem(
              updateName.value == 'home' ? 0 : 1,
              updateName.value,
              updateText.value + ',' + textController.text,
            ));
          } else {
            var addressType = homeInitService
                .items[homeInitService.items.indexWhere(
                    (element) => element.addressType == updateName.value)]
                .addressType;
            homeInitService.items.removeAt(homeInitService.items.indexWhere(
                (element) => element.addressType == updateName.value));
            homeInitService.items.add(AddressItem(
              2,
              addressType,
              updateText.value + ',' + textController.text,
            ));
          }
        }
        printInfo(info: '3. address update this $setMetaData');
        homeInitService.items.refresh();

        printInfo(info: '6. address update this $setMetaData');
      } else {
        if (updateName.value.contains('add_address')) {
          homeInitService.items.add(AddressItem(2, '${updateName.value}_1',
              updateText.value + ',' + textController.text));
        } else {
          homeInitService.items.add(AddressItem(
              updateName.value == 'home' ? 0 : 1,
              updateName.value,
              updateText.value + ',' + textController.text));
        }

        homeInitService.items.refresh();
      }

      for (int i = 0; i < homeInitService.items.length; i++) {
        setMetaData +=
            '"${homeInitService.items[i].addressType}":"${homeInitService.items[i].address}"';
        if (i != homeInitService.items.length - 1) {
          setMetaData += ',';
        }
      }

      setMetaData += '}';
      await wp_api.wooCommerceApi
          .updateCustomer(id: homeInitService.user.value.value!.id!, data: {
        'meta_data': [
          WooCustomerMetaData(null, 'default_address', setMetaData)
        ],
      });

      printInfo(info: 'address update this ${textController.text}');

      if (textController.text != '') {
        Get.dialog(
            barrierDismissible: false,
            AlertDialogYes(
              titleText: "주소가 ${type == 'update' ? '변경' : '등록'}되었습니다!",
              widgetname: "updateUserInfo",
              function: () => Get.close(2),
            ));
      } else {
        Get.dialog(
          barrierDismissible: false,
          AlertDialogYes(titleText: "주소를 입력해주세요."),
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 치수 가져오기
  Future getSize(String keyName) async {
    getsizeInfo.clear();

    List<WooCustomerMetaData>? metaData =
        homeInitService.user.value.value!.metaData;

    print("keyname this " + keyName);
    print("metadata length " + metaData!.toString());
    for (int i = 0; i < metaData!.length; i++) {
      print("get size for init!!!!!!");
      if (keyName == "상의") {
        print("getsize keyname  " + keyName);
        printInfo(info: 'shirt size this ${metaData[i].key}');
        switch (metaData[i].key!) {
          case "shirt_size":
            printInfo(info: 'shirt size this ${metaData[i].value}');
            if (metaData[i].value != "") {
              Map metaInfo = jsonDecode(metaData[i].value);
              ShirtModel shirtModel = ShirtModel.fromJson(metaInfo);
              getsizeInfo.add(shirtModel);
            } else {
              getsizeInfo.add(ShirtModel());
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
              print("add pants");
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
            // case "onepiece_width":
            // case "onepiece_sleeve_length":
            // case "onepiece_sleeve_width":
            // case "onepiece_":
            if (metaData[i].value != "") {
              getsizeInfo.add(metaData[i].value);
            } else {
              getsizeInfo.add("0");
            }
            break;
        }
      } else {
        if (keyName == "점퍼") {
          print("getsize keyname  " + keyName);
          switch (metaData[i].key!) {
            case "outer_jk_width":
            case "outer_jk_necksize":
            case "outer_jk_sleeve_length":
            case "outer_jk_sleeveless_length":
            case "outer_jk_shoulder_length":
              if (metaData[i].value != "") {
                getsizeInfo.add(metaData[i].value);
              } else {
                getsizeInfo.add("0");
              }
              break;
          }
        } else if (keyName == "재킷") {
          print("getsize keyname  " + keyName);
          switch (metaData[i].key!) {
            case "outer_jb_width":
            case "outer_jb_necksize":
            case "outer_jb_sleeve_length":
            case "outer_jb_sleeveless_length":
            case "outer_jb_shoulder_length":
              if (metaData[i].value != "") {
                getsizeInfo.add(metaData[i].value);
              } else {
                getsizeInfo.add("0");
              }
              break;
          }
        } else {
          print("getsize keyname  " + keyName);
          switch (metaData[i].key!) {
            case "outer_ct_width":
            case "outer_ct_necksize":
            case "outer_ct_sleeve_length":
            case "outer_ct_sleeveless_length":
            case "outer_ct_shoulder_length":
              if (metaData[i].value != "") {
                getsizeInfo.add(metaData[i].value);
              } else {
                getsizeInfo.add("0");
              }
              break;
          }
        }
      }
    }
    print("get size map " + getsizeInfo.toString());
  }

  /// 기본 카드 설정 || 카드 등록
  void registerCard(String type) async {
    try {
      switch (type) {
        case 'select_default':
          updateUserService.updateUser(
              'default_card', paymentService.selectCard, '기본 카드 정보가 변경되었습니다!');
          break;
      }
    } catch (e) {
      printInfo(info: '============= register card failed ============= \n $e');
    }
  }

  /// 주소 삭제
  void deleteAddress(int index) async {
    try {
      homeInitService.items.removeAt(index);
      homeInitService.items.refresh();
      var setMetaData = '';

      setMetaData += '{';

      for (int i = 0; i < homeInitService.items.length; i++) {
        setMetaData +=
            '"${homeInitService.items[i].addressType}":"${homeInitService.items[i].address}"';
        if (i != homeInitService.items.length - 1) {
          setMetaData += ',';
        }
      }

      setMetaData += '}';

      await wp_api.wooCommerceApi
          .updateCustomer(id: homeInitService.user.value.value!.id!, data: {
        'meta_data': [
          WooCustomerMetaData(null, 'default_address', setMetaData)
        ],
      });
    } catch (e) {
      printInfo(
          info: '============ delete address failed =============== \n$e');
    }
  }
}
