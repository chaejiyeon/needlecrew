import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:intl/intl.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/getxServices/home_init_service.dart';
import 'package:needlecrew/modal/alert_dialog_yes.dart';
import 'package:needlecrew/models/cart_item.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  static CartController get to => Get.find();

  final isInitialized = false.obs;

  RxList orders = <WooOrder>[].obs;
  RxList registerOrders = [].obs;
  late WooOrder order;
  late WooProduct product;

  RxInt categoryid = 0.obs;
  RxInt productid = 0.obs;

  // 장바구니에서 선택한 orderid list
  RxList orderid = [].obs;

  // 장바구니에서 등록한 orderid list
  RxList registerid = [].obs;

  // 옷바구니 건수
  RxInt cartCount = 0.obs;

  // 주문 건수
  RxInt orderCount = 0.obs;

  // 주소
  RxString setAddress = "".obs;

  // 총 비용
  RxInt wholePrice = 0.obs;

  // 주소 입력, 수거 희망일, 수거 가이드일 경우 false (저장 안됨) > 접수 완료시 true (저장)
  RxBool setSave = false.obs;

  // 수거 희망일
  RxString fixdate = "".obs;

  // 카테고리 전체 선택여부
  RxBool allSelectCategory = false.obs;

  // 상위 카테고리 구별
  List category = [];

  // 상위 카테고리
  RxString thisCategory = "".obs;
  RxInt categoryCount = 0.obs;

  // 옷바구니 리스트
  RxList cartItem = [].obs;
  List<List<CartItem>> cartListitem = [];

  RxList orderItem = [].obs;

  // 옷바구니에서 삭제할 orderId
  RxList deleteOrderIds = [].obs;

  // bottom visibility check
  RxBool visibility = false.obs;

  List<WooProductVariation> variation = [];

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  @override
  void onClose() {
    isInitialized.value = false;
    super.onClose();
  }

  // 초기화
  Future<void> initialize() async {
    // await getProductCategory();
    await getOrder();
    // await getCart();

    isInitialized.value = true;
    return;
  }

  // option name  변환
  String name(String optionName) {
    // 반환할 이름
    String name = "";

    // option name '-' 제거
    List nameList = optionName.split('-');

    // name 전체 표시
    for (int i = 0; i < nameList.length; i++) {
      name += nameList[i] + " ";
    }
    return name;
  }

  // productId 값 설정
  void isProductId(int productId) {
    productid.value = productId;
    update();
  }

  // 상위 카테고리 값 설정
  void isCategory(String category, int count) {
    if (thisCategory == "" || thisCategory != category) {
      thisCategory.value = category;
      categoryCount.value = count;
    }

    update();
  }

  // 주소 값 설정
  void isAddress(String address) {
    setAddress.value = address;
    print("this address " + setAddress.value.toString());
    update();
  }

  // 저장 여부 설정
  void isSaved(bool saved) {
    setSave.value = saved;
    print("Is Saved " + setSave.value.toString());
    update();
  }

  // 주소 등록 후 주문 완료 할 orderId 값 설정 (선택한 주문서 list)
  void isOrderId(bool ischecked, int orderId, Map item) {
    if (ischecked == true) {
      registerid.add(orderId);
      orderid.add(orderId);

      orderItem.add(item);
      orderCount.value++;
    } else {
      for (int i = 0; i < orderid.length; i++) {
        if (orderid[i] == orderId) {
          registerid.removeAt(i);
          orderid.removeAt(i);

          orderItem.removeAt(i);
        }
      }

      orderCount.value--;
    }

    update();
  }

  // 삭제할 옷바구니 orderid 설정
  void isDeleteOrderId() {
    for (int i = 0; i < orderid.length; i++) {
      deleteOrderIds.add(orderid[i]);
    }

    print("cartcontroller - this delete orderids " + deleteOrderIds.toString());

    update();
  }

  // 총 비용 설정
  void iswholePrice(bool ischecked, int price) {
    print("this price info !!!!!!" + price.toString());
    if (ischecked == true) {
      wholePrice.value += price;
    } else if (ischecked == false) {
      print("init ischecked false price!!!!!!!!!");
      wholePrice.value -= price;
    }

    print("wholePrice " + wholePrice.value.toString());
    update();
  }

  // 상품 체크 했을 때 표시
  void isChecked(int parentIndex, int index) {
    if (cartItem[parentIndex]['category_items'][index]["order_checked"] ==
        true) {
      cartItem[parentIndex]['category_items'][index]["order_checked"] = false;

      iswholePrice(
          cartItem[parentIndex]['category_items'][index]["order_checked"],
          int.parse(cartItem[parentIndex]['category_items'][index]
                  ["order_meta_data"]
              .productPrice));
      isOrderId(
          cartItem[parentIndex]['category_items'][index]["order_checked"],
          cartItem[parentIndex]['category_items'][index]['order_meta_data']
              .orderId,
          cartItem[parentIndex]);
    } else if (cartItem[parentIndex]['category_items'][index]
            ["order_checked"] ==
        false) {
      int count = 0;
      cartItem[parentIndex]['category_items'][index]["order_checked"] = true;

      iswholePrice(
          cartItem[parentIndex]['category_items'][index]["order_checked"],
          int.parse(cartItem[parentIndex]['category_items'][index]
                  ["order_meta_data"]
              .productPrice));
      isOrderId(
          cartItem[parentIndex]['category_items'][index]["order_checked"],
          cartItem[parentIndex]['category_items'][index]['order_meta_data']
              .orderId,
          cartItem[parentIndex]);

      for (int i = 0; i < cartItem[parentIndex]['category_items'].length; i++) {
        if (cartItem[parentIndex]['category_items'][i]["order_checked"] ==
            true) {
          count++;
        }
      }
    }

    update();
    // UI에 반영
    cartItem.refresh();
  }

  // 카테고리 선택 시
  void iscategoryChecked(int parentIndex) {
    print("this checkitem category update " +
        cartItem[parentIndex]['category_checked'].toString());

    int count = 0;

    // 카테고리 선택
    if (!cartItem[parentIndex]['category_checked']) {
      printInfo(
          info:
              'select category init============${cartItem[parentIndex]['category_checked']}');
      cartItem[parentIndex]['category_checked'] = true;

      // 카테고리 선택이 활성화 되어 있을 경우
      for (Map cartItem in cartItem) {
        if (cartItem['category_checked']) {
          count++;
        }
      }

      for (Map item in cartItem[parentIndex]['category_items']) {
        printInfo(
            info:
                'set category item init============ ${item['order_checked']}');
        item['order_checked'] = true;

        wholePrice.value += int.parse(item['order_meta_data'].productPrice);
        registerid.add(item['order_meta_data'].orderId);
        orderid.add(item['order_meta_data'].orderId);
        orderItem.add(cartItem[parentIndex]);
        orderCount.value++;
      }
    } else {
      cartItem[parentIndex]['category_checked'] = false;
      allSelectCategory.value = false;

      for (Map item in cartItem[parentIndex]['category_items']) {
        item['order_checked'] = false;

        wholePrice.value -= int.parse(item['order_meta_data'].productPrice);
        registerid.remove(item['order_meta_data'].orderId);
        orderid.remove(item['order_meta_data'].orderId);
        orderItem.remove(cartItem[parentIndex]);
        orderCount.value--;
      }
    }

    // 전체 카테고리가 활성화일 경우 전체 선택 체크박스 활성화
    if (count == cartItem.length) {
      allSelectCategory.value = true;
    } else {
      allSelectCategory.value = false;
    }

    cartItem.refresh();
    registerid.refresh();
    orderid.refresh();
    orderItem.refresh();
  }

// 전체 선택 시
  void isWholeChecked() {
    if (!allSelectCategory.value) {
      printInfo(info: '0.is whole checked init==========');
      allSelectCategory.value = true;

      for (Map cartItem in cartItem) {
        cartItem['category_checked'] = true;
        for (Map item in cartItem['category_items']) {
          item['order_checked'] = true;

          registerid.add(item['order_meta_data'].orderId);
          orderid.add(item['order_meta_data'].orderId);

          orderItem.add(cartItem);

          // 전체 금액
          wholePrice.value += int.parse(item['order_meta_data'].productPrice);
          orderCount.value++;

          printInfo(info: 'order count this $orderCount');
        }
      }

      print("주문 등록할 orderid " + orderid.toString());
    } else {
      allSelectCategory.value = false;

      for (Map cartItem in cartItem) {
        cartItem['category_checked'] = false;
        for (Map item in cartItem['category_items']) {
          item['order_checked'] = false;
          // 전체 금액
          wholePrice.value += int.parse(item['order_meta_data'].productPrice);
        }
      }

      registerid.clear();
      orderid.clear();
      orderItem.clear();
      orderCount.value = 0;
      wholePrice.value = 0;
    }

    update();
    cartItem.refresh();
  }

// 수거 희망일
  void fixDate(String selectMonth, String selectDay) {
    fixdate.value = selectMonth + "월" + selectDay + "일";
    update();
  }

// 단위 변환
  String setPrice() {
    String setPrice = NumberFormat('###,###,###')
        .format(wholePrice.value > 0 ? wholePrice.value + 6000 : 0);
    update();
    return setPrice;
  }

// 해당 유저에 대한 주문 정보 (옷바구니)
  Future<bool> getCart() async {
    try {
      orderid.clear();
      cartItem.clear();
      cartListitem.clear();
      orders.clear();

      printInfo(
          info:
              'get card init info this ${await wp_api.wooCommerceApi.getOrders(customer: homeInitService.user.value.value!.id, status: [
            'pending'
          ])}');
      orders.value = await wp_api.wooCommerceApi.getOrders(
          customer: homeInitService.user.value.value!.id, status: ['pending']);

      printInfo(info: 'get orders $orders');

      WooProduct product;
      List<WooProductCategory> lastCategrory = [];
      String slug = "";

      print("orders length this     " + orders.length.toString());

      for (WooOrder item in orders) {
        printInfo(info: 'order item $item');

        String cartCategory = '';

        List slugItem = [];

        product = await wp_api.wooCommerceApi
            .getProductById(id: item.lineItems![0].productId!);
        slug = Uri.decodeComponent(product.categories[0].slug.toString());

        slugItem = slug.split('-');

        Map orderMeta = {
          '물품 가액': '',
          '사진': '',
          '의뢰 방법': '',
          '치수': '',
          '추가 옵션': '',
          '추가 설명': ''
        };

        // 옷바구니의 추가 수선하기 카테고리 id값 가져오기
        lastCategrory = await wp_api.wooCommerceApi
            .getProductCategories(product: item.lineItems![0].productId);

        for (int i = 0; i < slugItem.length; i++) {
          if (slugItem[i] != "줄임" &&
              slugItem[i] != "늘임" &&
              slugItem[i] != "기타") {
            cartCategory += slugItem[i];
          }
        }

        printInfo(info: '0. get cart error ');
        for (int j = 0; j < item.metaData!.length; j++) {
          if (item.metaData![j].key!.indexOf('물품 가액') != -1) {
            orderMeta['물품 가액'] = item.metaData![j].value;
          } else if (item.metaData![j].key!.indexOf('사진') != -1) {
            orderMeta['사진'] = item.metaData![j].value.split(',');
          } else if (item.metaData![j].key!.indexOf('의뢰 방법') != -1) {
            orderMeta['의뢰 방법'] = item.metaData![j].value;
          } else if (item.metaData![j].key!.indexOf('추가 옵션') != -1) {
            orderMeta['추가 옵션'] = item.metaData![j].value;
          } else if (item.metaData![j].key!.indexOf('치수') != -1) {
            orderMeta['치수'] = item.metaData![j].value;
          }
        }

        orderMeta['추가 설명'] = item.customerNote!;

        printInfo(info: '1. get cart error');
        if (cartItem.isNotEmpty) {
          if (cartItem.indexWhere(
                  (element) => element['category_name'] == cartCategory) ==
              -1) {
            cartItem.add({
              'category_id': lastCategrory[0].parent!,
              'category_name': cartCategory,
              'category_checked': true,
              'category_items': [
                {
                  'order_checked': true,
                  'order_meta_data': OrderMetaData(
                      item.id!,
                      product.id!,
                      item.lineItems![0].name!,
                      item.lineItems![0].quantity!,
                      orderMeta['사진'],
                      orderMeta['의뢰 방법'],
                      orderMeta['치수'],
                      orderMeta['추가 설명'],
                      orderMeta['물품 가액'],
                      item.lineItems![0].price!)
                },
              ],
            });
          } else {
            printInfo(info: '2. get cart error');
            cartItem[cartItem.indexWhere(
                        (element) => element['category_name'] == cartCategory)]
                    ['category_items']
                .add(
              {
                'order_checked': true,
                'order_meta_data': OrderMetaData(
                    item.id!,
                    product.id!,
                    item.lineItems![0].name!,
                    item.lineItems![0].quantity!,
                    orderMeta['사진'],
                    orderMeta['의뢰 방법'],
                    orderMeta['치수'],
                    orderMeta['추가 설명'],
                    orderMeta['물품 가액'],
                    item.lineItems![0].price!)
              },
            );
          }
        } else {
          var orderItem = OrderMetaData(
              item.id!,
              product.id!,
              item.lineItems![0].name!,
              item.lineItems![0].quantity!,
              orderMeta['사진'],
              orderMeta['의뢰 방법'],
              orderMeta['치수'],
              orderMeta['추가 설명'],
              orderMeta['물품 가액'],
              item.lineItems![0].price!);
          printInfo(
              info:
                  '3. get cart error ${item.id!} $orderMeta${orderItem.cartProductName}');
          cartItem.add({
            'category_id': lastCategrory[0].parent!,
            'category_name': cartCategory,
            'category_checked': true,
            'category_items': [
              {
                'order_checked': true,
                'order_meta_data': OrderMetaData(
                    item.id!,
                    product.id!,
                    item.lineItems![0].name!,
                    item.lineItems![0].quantity!,
                    orderMeta['사진'],
                    orderMeta['의뢰 방법'],
                    orderMeta['치수'],
                    orderMeta['추가 설명'],
                    orderMeta['물품 가액'],
                    item.lineItems![0].price!)
              },
            ],
          });
          printInfo(info: '4. get cart error $cartItem');
        }
      }

      // list 오름차순 정렬
      cartItem.sort((a, b) => a['category_name'].compareTo(b['category_name']));

      isWholeChecked();

      cartItem.refresh();
    } catch (e) {
      print("is getCart Error " + e.toString());
      return false;
    }
    return true;
  }

// 해당 유저에 대한 주문 정보 (옷바구니)
  Future<bool> deleteCart(String type, int orderId) async {
    print("cartController - deleteCart init deleteorderid");
    print("CartController - deleteCart delteorderIds " +
        orderid.toString() +
        orderid.length.toString());

    String query = Uri(queryParameters: {
      'consumer_key': '${wp_api.wooCommerceApi.consumerKey}',
      'consumer_secret': '${wp_api.wooCommerceApi.consumerSecret}',
    }).query;

    try {
      if (type == "choose") {
        for (int i = 0; i < orderid.length; i++) {
          print("CartController - deleteCart init!!!!");
          http.Response response = await http.delete(
              Uri.parse("https://needlecrew.com/wp-json/wc/v3/orders/" +
                  orderid[i].toString() +
                  "?${query}"),
              headers: {
                'Accept-Encoding': 'gzip, deflate, br',
                'Connection': 'keep-alive',
              });
          print("CartController - deleteCart deleteOrder this!!!!" +
              response.body.toString());

          print("CartController - deleteCart 주문 삭제 성공");
        }
        Get.dialog(
          AlertDialogYes(
            titleText: "선택한 상품이 삭제되었습니다!",
            widgetname: "cart",
          ),
        );
      }

      // print("this order deleted " + orders.toString());
    } catch (e) {
      print("CartController - deleteCart 주문 삭제 실패 $e");
      return false;
    }
    return true;
  }

// 주문에 대한 등록된 이미지 삭제
  Future deleteImage() async {
    String query = Uri(queryParameters: {
      'consumer_key': '${wp_api.wooCommerceApi.consumerKey}',
      'consumer_secret': '${wp_api.wooCommerceApi.consumerSecret}',
    }).query;

    print("cartController - deleteImage init!!!!");

    try {
      for (int i = 0; i < orderItem.length; i++) {
        for (int j = 0; j < orderid.length; j++) {
          if (orderItem[i].cartId == orderid[j]) {
            for (int k = 0; k < orderItem[i].cartImages.length; k++) {
              List imageInfo = orderItem[i].cartImages[k].split('|');

              http.Response response = await http.post(
                Uri.parse("https://needlecrew.com/wp-json/wp/v2/media/" +
                    imageInfo[0] +
                    "?${query}"),
                headers: {
                  'Accept-Encoding': 'gzip, deflate, br',
                  'Connection': 'keep-alive',
                  // ''
                  // 'Content-Type': 'multipart/form-data'
                },
              );

              print("CartController - deleteImage response " +
                  response.body.toString());
            }
          }
        }
      }
      print("CartController - deleteImage 성공!!!!");
    } catch (e) {
      print("cartController - deleteImage error $e");
    }
  }

/// 접수 확인 list
  Future<void> getOrder() async {
    registerOrders.clear();
    try {
      for (int i = 0; i < orderid.length; i++) {
        var lastCategory;
        String slug = "";
        String cartCategory = '';

        List slugItem = [];

        var order = await wp_api.wooCommerceApi.getOrderById(orderid[i]);

        product = await wp_api.wooCommerceApi
            .getProductById(id: order.lineItems![0].productId!);
        slug = Uri.decodeComponent(product.categories[0].slug.toString());

        slugItem = slug.split('-');

        // 옷바구니의 추가 수선하기 카테고리 id값 가져오기
        lastCategory = await wp_api.wooCommerceApi
            .getProductCategories(product: order.lineItems![0].productId);

        for (int i = 0; i < slugItem.length; i++) {
          if (slugItem[i] != "줄임" &&
              slugItem[i] != "늘임" &&
              slugItem[i] != "기타") {
            cartCategory += slugItem[i];
          }
        }

        registerOrders.add({
          'category_id': lastCategory[0].parent!,
          'category_name': cartCategory,
          'category_items': [
            await wp_api.wooCommerceApi.getOrderById(orderid[i])
          ]
        });
      }

      print("cartcontroller - getOrder orderItem info    " +
          orderItem.toString());
    } catch (e) {
      print("isError " + e.toString());
    }
  }

/// 선택한 주문에 대한 주소 입력
  Future<bool> registerAddress() async {
    Map order_map = {
      'first_name': homeInitService.user.value.value!.firstName,
      'last_name': homeInitService.user.value.value!.lastName,
      'addresss_1': setAddress.value,
    };
    List metadata = [
      {'key': '수거 희망일', 'value': fixdate.value},
      {'key': '진행 상황', 'value': '주문 완료'}
    ];

    try {
      for (int i = 0; i < orderid.length; i++) {
        order =
            await wp_api.wooCommerceApi.updateOrder(id: orderid[i], orderMap: {
          'status': 'fix-register',
          'billing': order_map,
          'shipping': order_map,
          'meta_data': metadata
        });
        print(orderid[i].toString() + "주소 등록이 완료되었습니다.");
      }

      orderCount.value = 0;
      wholePrice.value = 0;
    } catch (e) {
      print("isError " + e.toString());
      return false;
    }
    return true;
  }

// option 항목 가져오기
  Future<bool> getVariation(int productId) async {
    try {
      variation = await wp_api.wooCommerceApi
          .getProductVariations(productId: productId);

      print("this variation info " + variation.toString());
    } catch (e) {
      print("isError" + e.toString());
      return false;
    }

    return true;
  }

// 주문서 업데이트
  Future updateOrder() async {
    try {} catch (e) {}
  }
}
