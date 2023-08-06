import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/order_payload.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:intl/intl.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/modal/alert_dialog_yes.dart';
import 'package:needlecrew/models/address_item.dart';
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

  // 옷바구니에서 삭제할 orderId
  RxList deleteOrderIds = [].obs;

  // bottom visibility check
  RxBool visibility = false.obs;

  RxList variation = <WooProductVariation>[].obs;

  // check address item list (주소 선택 리스트)
  RxList addressList = [].obs;

  // address insert editing controllersxxxsxszszsxzsdxz
  Rx<TextEditingController> addressEditingController =
      TextEditingController().obs;

  // detail address insert
  RxString detailAddress = '지번, 도로명, 건물명 검색'.obs;

  RxBool isLoading = false.obs;

  // 버튼 클릭 여부
  RxBool isClicked = false.obs;

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
  void initialize() async {
    // await getProductCategory();
    // await getOrder();
    isLoading.value = false;
    // var result =
    await getCart();

    // if (result) {
    //   log('loading true');
    //   isLoading.value = true;
    // } else {
    //   log('loading false');
    //   isLoading.value = false;
    // }

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

  // 저장 여부 설정
  void isSaved(bool saved) {
    setSave.value = saved;
    print("Is Saved " + setSave.value.toString());
    update();
  }

  // 상품 체크 했을 때 표시
  void isChecked(int parentIndex, int index) {
    if (cartItem[parentIndex]['category_items'][index]["order_checked"] ==
        true) {
      log('0. register order item delete ${registerOrders.length} ${cartItem.length}');
      cartItem[parentIndex]['category_items'][index]["order_checked"] = false;
      cartItem[parentIndex]['category_checked'] = false;
      allSelectCategory.value = false;
    } else if (cartItem[parentIndex]['category_items'][index]
            ["order_checked"] ==
        false) {
      log('0. register order item select');
      int allCategoryCount = 0;
      int count = 0;
      cartItem[parentIndex]['category_items'][index]["order_checked"] = true;

      for (int i = 0; i < cartItem[parentIndex]['category_items'].length; i++) {
        if (cartItem[parentIndex]['category_items'][i]["order_checked"] ==
            true) {
          count++;
        }
      }
      if (count == cartItem[parentIndex]['category_items'].length) {
        cartItem[parentIndex]['category_checked'] = true;
      }

      for (Map item in cartItem) {
        if (item['category_checked']) {
          allCategoryCount++;
        }
      }

      if (allCategoryCount == cartItem.length) {
        isWholeChecked();
      }
    }

    setWholePriceAndCount();
    update();
    // UI에 반영
    cartItem.refresh();

    log('1. register order item delete ${registerOrders.length} ${cartItem.length}');
  }

  // 카테고리 선택 시
  void iscategoryChecked(int parentIndex) {
    print("this checkitem category update " +
        cartItem[parentIndex]['category_checked'].toString());

    int count = 0;
    var setWholePrice = 0;

    // 카테고리 선택
    if (!cartItem[parentIndex]['category_checked']) {
      log('1. register order item delete');
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
      }
    } else {
      log('1. register order item select');
      cartItem[parentIndex]['category_checked'] = false;
      allSelectCategory.value = false;

      for (Map item in cartItem[parentIndex]['category_items']) {
        item['order_checked'] = false;
      }
    }

    setWholePriceAndCount();
    // 전체 카테고리가 활성화일 경우 전체 선택 체크박스 활성화
    if (count == cartItem.length) {
      allSelectCategory.value = true;
    } else {
      allSelectCategory.value = false;
    }

    cartItem.refresh();
  }

// 전체 선택 시
  void isWholeChecked() {
    if (!allSelectCategory.value) {
      printInfo(info: '0.is whole checked init==========');
      allSelectCategory.value = true;
      wholePrice.value = 0;
      orderCount.value = 0;
      // registerOrders.clear();
      for (Map cartItem in cartItem) {
        cartItem['category_checked'] = true;

        /// 수선할 항목에 저장
        // registerOrders.add(cartItem);
        for (Map item in cartItem['category_items']) {
          item['order_checked'] = true;
          printInfo(info: 'order count this $orderCount');
        }
      }

      setWholePriceAndCount();
      print("주문 등록할 orderid  register order length ${registerOrders.length}");
    } else {
      printInfo(info: '0. register order all else init&&&&&&&&');
      allSelectCategory.value = false;

      for (Map cartItem in cartItem) {
        cartItem['category_checked'] = false;

        for (Map item in cartItem['category_items']) {
          item['order_checked'] = false;
        }
      }

      orderCount.value = 0;
      wholePrice.value = 0;
    }

    update();
    cartItem.refresh();
  }

  // 전체 의뢰 예상 비용 설정
  setWholePriceAndCount() {
    orderCount.value = 0;
    wholePrice.value = 0;
    for (Map cartItem in cartItem) {
      for (Map item in cartItem['category_items']) {
        if (item['order_checked']) {
          // 전체 금액
          wholePrice.value += int.parse(item['order_meta_data'].productPrice);
          orderCount.value++;
        }
      }
    }
  }

  /// 수선등록할 목록
  void setRegisterOrder() {
    for (Map item in cartItem) {
      if (item['category_checked']) {
        registerOrders.add(item);
      } else {
        for (Map orderItem in item['category_items']) {
          if (orderItem['order_checked']) {
            if (registerOrders.isEmpty) {
              registerOrders.add({
                'category_checked': item['category_checked'],
                'category_name': item['category_name'],
                'category_id': item['category_id'],
                'category_items': [orderItem]
              });
            } else {
              if (registerOrders.indexWhere((element) =>
                      element['category_id'] == item['category_id']) ==
                  -1) {
                registerOrders.add({
                  'category_checked': item['category_checked'],
                  'category_name': item['category_name'],
                  'category_id': item['category_id'],
                  'category_items': [orderItem]
                });
              } else {
                if (registerOrders[registerOrders.indexWhere((element) =>
                                element['category_id'] == item['category_id'])]
                            ['category_items']
                        .indexWhere((e) =>
                            e['order_meta_data'].orderId ==
                            orderItem['order_meta_data'].orderId) ==
                    -1) {
                  registerOrders[registerOrders.indexWhere((element) =>
                              element['category_id'] == item['category_id'])]
                          ['category_items']
                      .add(orderItem);
                }
              }
            }
          }
        }
      }
    }
    log('register order length this ${registerOrders.length}');
  }

// 수거 희망일
  void fixDate(String selectYear, String selectMonth, String selectDay) {
    fixdate.value = '$selectYear년 $selectMonth월 $selectDay일';
    update();
  }

// 해당 유저에 대한 주문 정보 (옷바구니)
  Future<bool> getCart() async {
    try {
      cartItem.clear();
      cartListitem.clear();
      orders.clear();
      registerOrders.clear();

      allSelectCategory.value = true;
      wholePrice.value = 0;
      orderCount.value = 0;

      var setWholePrice = 0;
      var setOrderCount = 0;

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

        var orderMetaData;

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
          var getMetaData =
              OrderMetaData.fromJson(jsonDecode(item.metaData![j].value));
          orderMetaData = OrderMetaData(
            orderId: item.id,
            cartId: getMetaData.cartId,
            variationId: getMetaData.variationId,
            cartProductName: getMetaData.cartProductName,
            cartCategoryName: cartCategory,
            cartCount: getMetaData.cartCount,
            cartContent: getMetaData.cartContent,
            addOption: getMetaData.addOption,
            guaranteePrice: getMetaData.guaranteePrice,
            cartImages: getMetaData.cartImages,
            cartSize: getMetaData.cartSize,
            cartWay: getMetaData.cartWay,
            productPrice: getMetaData.productPrice,
            productId: getMetaData.productId,
            changeInfo: getMetaData.changeInfo,
          );
          log('order meta data this ${orderMetaData.cartProductName}');
        }

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
                {'order_checked': true, 'order_meta_data': orderMetaData},
              ],
            });
            setWholePrice += int.parse(item.lineItems![0].price!);
            setOrderCount++;
          } else {
            printInfo(info: '2. get cart error');
            if (cartItem[cartItem.indexWhere((element) =>
                            element['category_name'] == cartCategory)]
                        ['category_items']
                    .indexWhere(
                        (e) => e['order_meta_data'].orderId == item.id) ==
                -1) {
              cartItem[cartItem.indexWhere((element) =>
                          element['category_name'] == cartCategory)]
                      ['category_items']
                  .add(
                {'order_checked': true, 'order_meta_data': orderMetaData},
              );
              setWholePrice += int.parse(item.lineItems![0].price!);
              setOrderCount++;
            }
          }
        } else {
          var orderItem = orderMetaData;
          printInfo(
              info:
                  '3. get cart error ${item.id!} $orderMeta${orderItem.cartProductName}');
          cartItem.add({
            'category_id': lastCategrory[0].parent!,
            'category_name': cartCategory,
            'category_checked': true,
            'category_items': [
              {'order_checked': true, 'order_meta_data': orderMetaData},
            ],
          });
          setWholePrice += int.parse(item.lineItems![0].price!);
          setOrderCount++;
          printInfo(info: '4. get cart error $cartItem');
        }
      }

      wholePrice.value = setWholePrice;
      orderCount.value = setOrderCount;

      // list 오름차순 정렬
      cartItem.sort((a, b) => a['category_name'].compareTo(b['category_name']));
      cartItem.refresh();

      isLoading.value = true;
      return true;
    } catch (e) {
      print("is getCart Error " + e.toString());
      isLoading.value = false;
      return false;
    }
  }

  // 선택한 주문
  checkedOrderId() {
    var orderIds = [];
    for (Map item in cartItem) {
      for (Map orderItem in item['category_items']) {
        if (orderItem['order_checked']) {
          orderIds.add(orderItem['order_meta_data'].orderId);
        }
      }
    }

    log('checked order id this $orderIds');
    return orderIds;
  }

// 해당 유저에 대한 주문 정보 (옷바구니)
  Future<bool> deleteCart(String type, int? orderId) async {
    print("cartController - deleteCart init deleteorderid");
    print("CartController - deleteCart delteorderIds " + orderId.toString());

    String query = Uri(queryParameters: {
      'consumer_key': '${wp_api.wooCommerceApi.consumerKey}',
      'consumer_secret': '${wp_api.wooCommerceApi.consumerSecret}',
    }).query;

    try {
      var isSucceed = false;
      var orderIds = checkedOrderId();
      if (orderIds.isNotEmpty) {
        switch (type) {
          case 'many':
            try {
              for (int i = 0; i < orderIds.length; i++) {
                print("CartController - deleteCart init!!!!");
                http.Response response = await http.delete(
                    Uri.parse("https://needlecrew.com/wp-json/wc/v3/orders/" +
                        orderIds[i].toString() +
                        "?${query}"),
                    headers: {
                      'Accept-Encoding': 'gzip, deflate, br',
                      'Connection': 'keep-alive',
                    });
                print("CartController - deleteCart deleteOrder this!!!!" +
                    response.body.toString());

                print("CartController - deleteCart 주문 삭제 성공");
                isSucceed = true;
              }
            } catch (e) {
              print("CartController - deleteCart 주문 삭제 실패 $e");
              isSucceed = false;
            }
            break;
          case 'single':
            try {
              http.Response response = await http.delete(
                  Uri.parse(
                      "https://needlecrew.com/wp-json/wc/v3/orders/$orderId?${query}"),
                  headers: {
                    'Accept-Encoding': 'gzip, deflate, br',
                    'Connection': 'keep-alive',
                  });
              print("CartController - deleteCart deleteOrder this!!!!" +
                  response.body.toString());

              print("CartController - deleteCart 주문 삭제 성공");
              isSucceed = true;
            } catch (e) {
              print("CartController - deleteCart 주문 삭제 실패 $e");
              isSucceed = false;
            }
            break;
        }

        if (isSucceed) {
          Get.dialog(
            AlertDialogYes(
              titleText: "선택한 상품이 삭제되었습니다!",
              widgetname: "cart",
            ),
          );
        } else {
          Get.dialog(
            AlertDialogYes(
              titleText: "선택한 상품 삭제에 실패하였습니다.\n관리자에게 문의해주세요.",
              widgetname: "cart",
            ),
          );
        }
      } else {
        Get.dialog(
            barrierDismissible: false,
            AlertDialogYes(titleText: "삭제할 의뢰를 선택해 주세요."));
      }
      // print("this order deleted " + orders.toString());
      return isSucceed;
    } catch (e) {
      print("CartController - deleteCart 주문 삭제 실패 $e");
      return false;
    }
  }

// 주문에 대한 등록된 이미지 삭제
  Future deleteImage() async {
    String query = Uri(queryParameters: {
      'consumer_key': '${wp_api.wooCommerceApi.consumerKey}',
      'consumer_secret': '${wp_api.wooCommerceApi.consumerSecret}',
    }).query;

    print("cartController - deleteImage init!!!!");

    try {
      for (Map item in cartItem) {
        for (Map orderItem in item['category_items']) {
          if (orderItem['order_checked']) {
            for (int i = 0; i < orderItem['order_meta_data'].cartImages; i++) {
              List imageInfo =
                  orderItem['order_meta_data'].cartImages[i].split('|');
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
      // for (int i = 0; i < orderItem.length; i++) {
      //   for (int j = 0; j < orderid.length; j++) {
      //     if (orderItem[i].cartId == orderid[j]) {
      //       for (int k = 0; k < orderItem[i].cartImages.length; k++) {
      //
      //
      //         http.Response response = await http.post(
      //           Uri.parse("https://needlecrew.com/wp-json/wp/v2/media/" +
      //               imageInfo[0] +
      //               "?${query}"),
      //           headers: {
      //             'Accept-Encoding': 'gzip, deflate, br',
      //             'Connection': 'keep-alive',
      //             // ''
      //             // 'Content-Type': 'multipart/form-data'
      //           },
      //         );
      //
      //         print("CartController - deleteImage response " +
      //             response.body.toString());
      //       }
      //     }
      //   }
      // }
      print("CartController - deleteImage 성공!!!!");
      return true;
    } catch (e) {
      print("cartController - deleteImage error $e");
      return false;
    }
  }

  /// 접수 확인 list
  // Future<void> getOrder() async {
  //   registerOrders.clear();
  //   try {
  //     for (int i = 0; i < orderid.length; i++) {
  //       var lastCategory;
  //       String slug = "";
  //       String cartCategory = '';
  //
  //       List slugItem = [];
  //
  //       var order = await wp_api.wooCommerceApi.getOrderById(orderid[i]);
  //
  //       product = await wp_api.wooCommerceApi
  //           .getProductById(id: order.lineItems![0].productId!);
  //       slug = Uri.decodeComponent(product.categories[0].slug.toString());
  //
  //       slugItem = slug.split('-');
  //
  //       // 옷바구니의 추가 수선하기 카테고리 id값 가져오기
  //       lastCategory = await wp_api.wooCommerceApi
  //           .getProductCategories(product: order.lineItems![0].productId);
  //
  //       for (int i = 0; i < slugItem.length; i++) {
  //         if (slugItem[i] != "줄임" &&
  //             slugItem[i] != "늘임" &&
  //             slugItem[i] != "기타") {
  //           cartCategory += slugItem[i];
  //         }
  //       }
  //
  //       registerOrders.add({
  //         'category_id': lastCategory[0].parent!,
  //         'category_name': cartCategory,
  //         'category_items': [
  //           await wp_api.wooCommerceApi.getOrderById(orderid[i])
  //         ]
  //       });
  //     }
  //
  //     print("cartcontroller - getOrder orderItem info    " +
  //         orderItem.toString());
  //   } catch (e) {
  //     print("isError " + e.toString());
  //   }
  // }

  /// 장바구니에서 선택한 상품들로 주문 생성 : 기존 장바구니(주문-status<pending>) 항목 삭제
  Future<bool> registerOrder() async {
    Map orderMap = {
      'first_name': homeInitService.user.value.value!.firstName,
      'last_name': homeInitService.user.value.value!.lastName,
      'address_1': setAddress.value,
    };

    try {
      List<WooOrderPayloadMetaData> metaData = [];
      List<LineItems> lineItems = [];

      if (registerOrders.isNotEmpty) {
        for (Map item in registerOrders) {
          log('1. register order is not empty $item');
          if (item['category_items'].isNotEmpty) {
            log('2. register order is not empty ${item['category_items']}');
            for (Map categoryItem in item['category_items']) {
              log('3. register order is not empty $categoryItem');
              lineItems.add(LineItems(
                  productId: categoryItem['order_meta_data'].productId,
                  variationId: categoryItem['order_meta_data'].variationId,
                  quantity: categoryItem['order_meta_data'].cartCount));
              log('00000000000ine item length this ${categoryItem['order_meta_data'].toMap()}');
              metaData.add(WooOrderPayloadMetaData(
                  key:
                      '상품_${categoryItem['order_meta_data'].cartProductName}_${categoryItem['order_meta_data'].cartId}',
                  value: jsonEncode(categoryItem['order_meta_data'].toMap())));

              log('1111111111line item length this ${lineItems.length} meta data length this ${metaData.length}');
              try {
                await wp_api.wooCommerceApi.deleteOrder(
                    orderId: categoryItem['order_meta_data'].orderId);
                log('cart register order delete success');
              } catch (e) {
                log('cart register order delete failed $e');
              }
            }
          }
        }
        if (lineItems.isNotEmpty && metaData.isNotEmpty) {
          metaData.add(WooOrderPayloadMetaData(
              key: '결제정보',
              value:
                  "{'결제여부':'N', '결제키':'', '결제카드':'', '결제비용':'', '결제날짜':''}")); // Y || N
          metaData.add(WooOrderPayloadMetaData(
              key: '배송정보', value: "{'배송여부':'', '운송장번호':''}"));
          metaData.add(WooOrderPayloadMetaData(
              key: '수령인정보',
              value:
                  "{'수령인':'${homeInitService.user.value.value!.lastName}${homeInitService.user.value.value!.firstName}', '연락처':'${homeInitService.userInfo['phone_number']}', '수거희망일':'${fixdate.value}', '주소':'${setAddress.value}'"));
          await wp_api.wooCommerceApi.createOrder(WooOrderPayload(
            customerId: homeInitService.user.value.value!.id,
            billing: WooOrderPayloadBilling(
              firstName: orderMap['first_name'],
              lastName: orderMap['last_name'],
              address1: orderMap['address_1'],
            ),
            shipping: WooOrderPayloadShipping(
              firstName: orderMap['first_name'],
              lastName: orderMap['last_name'],
              address1: orderMap['address_1'],
            ),
            status: 'fix-register',
            lineItems: lineItems,
            metaData: metaData,
          ));
        }
        log('register order success');
        orderCount.value = 0;
        wholePrice.value = 0;
      }
      return true;
    } catch (e) {
      log('register order failed ----$e');
      return false;
    }
  }

// option 항목 가져오기
  Future<bool> getVariation(int productId) async {
    variation.clear();
    try {
      variation.value = await wp_api.wooCommerceApi
          .getProductVariations(productId: productId);

      print("this variation info " + variation.toString());
      return true;
    } catch (e) {
      print("isError" + e.toString());
      return false;
    }
  }

  /// address 설정
  void setAddressList(List addressItems) {
    for (AddressItem item in addressItems) {
      addressList.add({'is_checked': false, 'address_type': item.addressType});
    }
  }
}
