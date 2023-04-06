import 'dart:convert';

import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:http/http.dart' as http;
import 'package:needlecrew/modal/alert_dialog_yes.dart';
import 'package:needlecrew/models/billing_info.dart';
import 'package:needlecrew/models/get_token.dart';

import '../db/wp-api.dart';

class PaymentService extends GetxService {
  // 주문서 정보
  Map orderMap = {
    'order_no': '',
    'order_item': '',
    'order_price': '',
    'shipp_cost': '6000',
    'total_price': 0,
  };

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
  var selectCard;

  @override
  void onInit() async {
    super.onInit();
  }

  /// 주문서 가져오기
  Future orderInfo(int orderid) async {
    WooOrder order = await wp_api.wooCommerceApi.getOrderById(orderid);
    try {
      orderMap['order_no'] = order.number;
      orderMap['order_item'] = order.lineItems!.first.name;
      orderMap['order_price'] = order.lineItems!.first.price;
      orderMap['total_price'] =
          int.parse(order.lineItems!.first.price.toString()) +
              int.parse(orderMap['shipp_cost']);

      print('order map this $orderMap');
    } catch (e) {
      print("HomeController - orderInfo Error" + e.toString());
    }
  }

  ///  api 요청에 필요한 iamport token 발급
  Future<GetToken> getToken() async {
    // iamport 인증 토큰 발급
    http.Response getToken = await http.post(
      Uri.http('api.iamport.kr', 'users/getToken'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "imp_key": "7841512646424267",
        "imp_secret":
            "a626431af1d1499136faad65c738dcfb60f8ef5be928c19b03b21b94b9d6d3f2a252f3c656859d19"
      }),
    );

    // 토큰 가져오기
    var token = Token.fromJson(json.decode(getToken.body));
    // 토큰 분리
    var access_token = GetToken.fromJson(token.response);

    return access_token;
  }

  /// 비인증 결제 카드 빌키 요청
  Future registerPaymentCard(Map cardInfo) async {
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
      if (homeInitService.userInfo['default_card'] == '') {
        await wp_api.wooCommerceApi
            .updateCustomer(id: homeInitService.user.value.value!.id!, data: {
          'meta_data': [
            WooCustomerMetaData(null, 'default_card', cardInfo['customer_uid'])
          ]
        });
      } else {
        var addCards = '';
        if (homeInitService.cardItems.isNotEmpty) {
          if (homeInitService.cardItems.indexWhere(
                  (element) => element == cardInfo['customer_uid']) ==
              -1) {
            homeInitService.cardItems.add(cardInfo['customer_uid']);
            homeInitService.cardItems.refresh();
          }
          for (int i = 0; i < homeInitService.cardItems.length; i++) {
            if (i != homeInitService.cardItems.length - 1) {
              addCards += '${homeInitService.cardItems[i]},';
            } else {
              addCards += '${homeInitService.cardItems[i]}';
            }
          }
        } else {
          addCards = cardInfo['customer_uid'];
        }
        await wp_api.wooCommerceApi
            .updateCustomer(id: homeInitService.user.value.value!.id!, data: {
          'meta_data': [WooCustomerMetaData(null, 'pay_cards', addCards)]
        });
      }
      print("Homecontroller - billingKey 발급 성공!!!");
      return true;
    } else {
      Get.dialog(
          AlertDialogYes(titleText: "입력된 정보를 확인해 주세요!", widgetname: "billing"));
      return false;
    }
  }

  /// 특정 카드 정보 가져오기
  Future getCardInfo(String billingKey) async {
    try {
      GetToken tokenInfo = await getToken();

      Map<String, dynamic> parameter = {"customer_uid[]": billingKey};

      // billing 정보 요청
      http.Response response = await http.get(
        Uri.https("api.iamport.kr", "/subscribe/customers", parameter),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "${tokenInfo.access_token}",
        },
      );

      print("response" + response.body);
      // billing 정보 가져오기
      var getBilling = BillingInfo.fromJson(json.decode(response.body));

      // card 정보 가져오기
      if (getBilling.response != null) {
        var getCard = CardInfo.fromJson(getBilling.response.first);

        return CardInfo(
          customer_uid: getCard.customer_uid,
          customer_name: getCard.customer_name,
          customer_email: getCard.customer_email,
          card_name: getCard.card_name,
          card_number: getCard.card_number,
        );
      }
    } catch (e) {
      print("HomeController - getCardInfo error" + e.toString());
    }
  }

  /// 전체 카드 정보 가져오기
  Future getCardAll() async {
    cardsBillkey.clear();
    cardsInfo.clear();

    try {
      List<WooCustomerMetaData> metaData =
          homeInitService.user.value.value!.metaData!;
      GetToken token = await getToken();

      for (int i = 0; i < metaData.length!; i++) {
        if (metaData[i].key == "default_card" && metaData[i].key != null) {
          cardsBillkey.add(metaData[i].value);
        } else if (metaData[i].key == "pay_cards" && metaData[i].key != null) {
          List dataSplit = metaData[i].value.split(',');
          for (int j = 0; j < dataSplit.length; j++) {
            cardsBillkey.add(dataSplit[j]);
          }
        }
      }

      if (cardsBillkey.length != 0) {
        Map<String, dynamic> parameter = {"customer_uid[]": cardsBillkey};

        http.Response response = await http.get(
          Uri.https("api.iamport.kr", "subscribe/customers", parameter),
          headers: {
            "Authorization": "${token.access_token}",
          },
        );

        var body = BillingInfo.fromJson(json.decode(response.body));

        print(body.response.toString());

        print("cardsInfo before" + cardsInfo.length.toString());
        for (int i = 0; i < body.response.length; i++) {
          CardInfo cardInfo = CardInfo(
              card_name: body.response[i]['card_name'],
              card_number: body.response[i]['card_number'],
              customer_name: body.response[i]['customer_name'],
              customer_email: body.response[i]['customer_email'],
              customer_uid: body.response[i]['customer_uid']);

          cardsInfo.add(cardInfo);

          print("get card this ${body.response.length}");
        }

        print("cardsInfo after" + cardsInfo.length.toString());

        cardsBillkey.refresh();

        print("HomeController - getCardAll" + cardsBillkey.toString());
      }
    } catch (e) {
      print("HomeController - getCardAll Error " + e.toString());
    }
  }

  /// 결제 요청
  Future<bool> payMent(dynamic customerUid) async {
    try {
      GetToken token = await getToken();

      print(customerUid);
      http.Response response = await http.post(
          Uri.https("api.iamport.kr", "subscribe/payments/again"),
          headers: {
            "Authorization": "${token.access_token}"
          },
          body: {
            'customer_uid': customerUid,
            'merchant_uid': orderMap['order_no'],
            'amount': orderMap['total_price'].toString(),
            'name': orderMap['order_item'],
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
