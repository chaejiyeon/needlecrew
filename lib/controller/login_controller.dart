import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:needlecrew/db/wp-api.dart' as wp_api;

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  RxList ischecked = [].obs;

  // 인증번호
  RxString verificationCode = ''.obs;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 초기화
  Future<void> initialize() async {
    return;
  }

  // 약관 동의
  void setChecked() {
    for (int i = 0; i < 4; i++) {
      ischecked.add(false);
    }
    update();
  }

  // 동의 여부
  void isChecked(int index) {
    if (ischecked[index] == true) {
      ischecked[index] = false;
    } else {
      ischecked[index] = true;
    }

    update();
  }

  // 전체 동의
  void wholeChecked(bool wholecheck) {
    if (wholecheck == true) {
      for (int i = 0; i < 4; i++) {
        ischecked[i] = true;
      }
    } else {
      for (int i = 0; i < 4; i++) {
        ischecked[i] = false;
      }
    }

    update();
  }

  //  문자 인증 - naver | signature key 얻기
  String getSignatureKey(
      String serviceId, String timeStamp, String accessKey, String secretKey) {
    var space = " "; // one space
    var newLine = "\n"; // new line
    var method = "POST"; // method
    var url = "/sms/v2/services/$serviceId/messages";

    var buffer = new StringBuffer();
    buffer.write(method);
    buffer.write(space);
    buffer.write(url);
    buffer.write(newLine);
    buffer.write(timeStamp);
    buffer.write(newLine);
    buffer.write(accessKey);
    print('buffer : ${buffer.toString()}');

    /// signing key
    var key = utf8.encode(secretKey);
    var signingKey = new Hmac(sha256, key);

    var bytes = utf8.encode(buffer.toString());
    var digest = signingKey.convert(bytes);
    String signatureKey = base64.encode(digest.bytes);
    return signatureKey;
  }

  // 문자 보내기
  void sendSMS(String phoneNumber) async {
    try {
      var chars = '0123456789';
      Random rnd = Random();

      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

      var authInteger = getRandomString(6);
      verificationCode.value = authInteger;

      Map data = {
        "type": "SMS",
        "contentType": "COMM",
        "countryCode": "82",
        "from": "01072390804",
        "content": "authCode",
        "messages": [
          {"to": phoneNumber, "content": "[니들크루 회원가입 인증번호]\n$authInteger"}
        ],
      };
      var dateTime = DateTime.now().millisecondsSinceEpoch.toString();

      var getKey = getSignatureKey(
          Uri.encodeComponent('ncp:sms:kr:302829398998:needlecrew'),
          dateTime,
          'oH0VO3w8DuQO7TH94KeB',
          '7BBK3gBZaigwQKMfJ2WlyO3pj6XyEizqnCTzDV6S');

      printInfo(info: 'get signature key this $getKey');
      printInfo(
          info:
              'get signature key this ${Uri.encodeComponent('ncp:sms:kr:302829398998:needlecrew')}');

      var result = await http.post(
          Uri.parse(
              "https://sens.apigw.ntruss.com/sms/v2/services/${Uri.encodeComponent('ncp:sms:kr:302829398998:needlecrew')}/messages"),
          headers: <String, String>{
            "accept": "application/json",
            'content-Type': 'application/json; charset=UTF-8',
            'x-ncp-apigw-timestamp': dateTime,
            'x-ncp-iam-access-key': 'oH0VO3w8DuQO7TH94KeB',
            'x-ncp-apigw-signature-v2': getKey
          },
          body: json.encode(data));
      print('result : ${result.body}');
    } catch (e) {
      print('sms send error =============\n $e');
    }
  }
}
