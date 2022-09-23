import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:intl/intl.dart';
import 'package:needlecrew/modal/alertDialogYes.dart';
import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/widgets/cartInfo/cartListItem.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();

  final isInitialized = false.obs;

  late WooCustomer user;

  List<WooOrder> orders = [];
  List<WooOrder> registerOrders = [];
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

  // 전체 선택
  RxBool isWholechecked = true.obs;

  // 카테고리별 전체 선택
  RxList isCategorychecked = [].obs;

  // 상위 카테고리 구별
  List category = [];

  // 상위 카테고리
  RxString thisCategory = "".obs;
  RxInt categoryCount = 0.obs;

  // 옷바구니 리스트
  List<CartItem> cartItem = [];
  List<List<CartItem>> cartListitem = [];

  List<CartItem> orderItem = [];

  // 체크된 상품 구별 리스트
  RxList checkItem = []
      .obs; // {"orderid": cartItem.cartId, "price": cartItem.productPrice, "ischecked": false}

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
  void isOrderId(bool ischecked, int orderId, CartItem item) {
    if (ischecked == true) {
      registerid.value.add(orderId);
      orderid.value.add(orderId);

      orderItem.add(item);
      orderCount.value++;
    } else {
      for (int i = 0; i < orderid.length; i++) {
        if (orderid[i] == orderId) {
          registerid.value.removeAt(i);
          orderid.value.removeAt(i);

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
  void ischecked(int parentIndex, int index) {
    if (checkItem[parentIndex][index]["ischecked"] == true) {
      checkItem[parentIndex][index]["ischecked"] = false;

      isWholechecked.value = false;

      isCategorychecked[parentIndex] = false;

      iswholePrice(checkItem[parentIndex][index]["ischecked"],
          int.parse(cartItem[parentIndex].productPrice));
      isOrderId(checkItem[parentIndex][index]["ischecked"],
          cartItem[parentIndex].cartId, cartItem[parentIndex]);
    } else if (checkItem[parentIndex][index]["ischecked"] == false) {
      int count = 0;
      checkItem[parentIndex][index]["ischecked"] = true;

      iswholePrice(checkItem[parentIndex][index]["ischecked"],
          int.parse(cartItem[parentIndex].productPrice));
      isOrderId(checkItem[parentIndex][index]["ischecked"],
          cartItem[parentIndex].cartId, cartItem[parentIndex]);

      for (int i = 0; i < checkItem[parentIndex].length; i++) {
        if (checkItem[parentIndex][i]["ischecked"] == true) {
          count++;
        }
      }

      if (count == checkItem[parentIndex].length) {
        isCategorychecked[parentIndex] = true;
      }
    }

    print("this checkitem info " +
        parentIndex.toString() +
        index.toString() +
        checkItem[parentIndex][index]["ischecked"].toString());

    update();
    // UI에 반영
    checkItem.refresh();
  }

  // 카테고리 선택 시
  void iscategoryChecked(int parentIndex) {
    print(
        "this checkitem category update " + checkItem[parentIndex].toString());

    int count = 0;

    if (isCategorychecked[parentIndex] == false) {
      isCategorychecked[parentIndex] = true;

      // 카테고리 전체 체크시 전체 선택 활성화
      for (int i = 0; i < isCategorychecked.length; i++) {
        if (isCategorychecked[i] == true) {
          count++;
        }
      }

      if (count == isCategorychecked.length) {
        isWholechecked.value = true;
      }
      // end- 카테고리 전체 체크시 전체 선택 활성화

      print("this checkitem count " + checkItem[parentIndex].length.toString());
      for (int i = 0; i < checkItem[parentIndex].length; i++) {
        checkItem[parentIndex][i]["ischecked"] = true;

        if (checkItem[parentIndex][i]["ischecked"] = true) {
          wholePrice.value += int.parse(checkItem[parentIndex][i]["price"]);
          registerid.value.add(checkItem[parentIndex][i]["orderid"]);
          orderid.value.add(checkItem[parentIndex][i]["orderid"]);

          orderItem.add(cartItem[parentIndex]);
          orderCount++;
        }
      }
    } else if (isCategorychecked[parentIndex] == true) {
      isCategorychecked[parentIndex] = false;
      isWholechecked.value = false;

      for (int i = 0; i < checkItem[parentIndex].length; i++) {
        checkItem[parentIndex][i]["ischecked"] = false;

        wholePrice.value -= int.parse(checkItem[parentIndex][i]["price"]);
        registerid.value.remove(checkItem[parentIndex][i]["orderid"]);
        orderid.value.remove(checkItem[parentIndex][i]["orderid"]);

        orderItem.remove(checkItem[parentIndex][i]["orderid"]);
        orderCount--;
      }
    }

    update();
    isCategorychecked.refresh();
    checkItem.refresh();
  }

  // 전체 선택 시
  void iswholeChecked() {
    if (isWholechecked.value == false) {
      isWholechecked.value = true;

      for (int i = 0; i < checkItem.length; i++) {
        for (int j = 0; j < checkItem[i].length; j++) {
          checkItem[i][j]["ischecked"] = true;
        }
      }

      for (int j = 0; j < isCategorychecked.length; j++) {
        isCategorychecked[j] = true;
      }

      if (wholePrice.value != 0) {
        wholePrice.value = 0;
        orderCount.value = 0;
      }

      // 전체 금액
      for (int i = 0; i < cartItem.length; i++) {
        wholePrice.value += int.parse(cartItem[i].productPrice);
      }

      // 주문할 Id
      for (int i = 0; i < cartItem.length; i++) {
        registerid.value.add(cartItem[i].cartId);
        orderid.value.add(cartItem[i].cartId);

        orderItem.add(cartItem[i]);

        orderCount.value++;
      }
      print("주문 등록할 orderid " + orderid.value.toString());
    } else {
      isWholechecked.value = false;

      for (int i = 0; i < checkItem.length; i++) {
        for (int j = 0; j < checkItem[i].length; j++) {
          checkItem[i][j]["ischecked"] = false;
        }
      }

      for (int j = 0; j < isCategorychecked.length; j++) {
        isCategorychecked[j] = false;
      }

      registerid.clear();
      orderid.clear();
      orderItem.clear();
      orderCount.value = 0;
      wholePrice.value = 0;
    }

    update();
    checkItem.refresh();
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
    orderid.clear();
    try {
      cartItem.clear();
      cartListitem.clear();
      orders.clear();
      isCategorychecked.clear();
      checkItem.clear();

      user = await wp_api.getUser();

      orders = await wp_api.wooCommerceApi
          .getOrders(customer: user.id, status: ['pending']);

      Map orderMeta = {
        '의뢰 방법': '기타',
        '치수': '',
        // '수량': '',
        '추가 설명': '',
        '물품 가액': '',
        '추가 옵션': '',
        '사진': '',
      };

      WooProduct product;
      List<WooProductCategory> lastCategrory = [];
      String slug = "";

      print("orders length this     " + orders.length.toString());

      // 첫 상위 카테고리에 넣어주고 카테고리별 리스트 넣어주고 cartInfo에서 CartListItem으로 뿌려줌
      for (int i = 0; i < orders.length; i++) {
        String cartCategory = "";
        List slugItem = [];

        product = await wp_api.wooCommerceApi
            .getProductById(id: orders[i].lineItems![0].productId!);
        slug = Uri.decodeComponent(product.categories[0].slug.toString());

        slugItem = slug.split('-');

        // 옷바구니의 추가 수선하기 카테고리 id값 가져오기
        lastCategrory = await wp_api.wooCommerceApi
            .getProductCategories(product: orders[i].lineItems![0].productId);

        for (int i = 0; i < slugItem.length; i++) {
          if (slugItem[i] != "줄임" &&
              slugItem[i] != "늘임" &&
              slugItem[i] != "기타") {
            cartCategory += slugItem[i];
          }
        }

        for (int j = 0; j < orders[i].metaData!.length; j++) {
          if (orders[i].metaData![j].key!.indexOf('물품 가액') != -1) {
            orderMeta['물품 가액'] = orders[i].metaData![j].value;
          } else if (orders[i].metaData![j].key!.indexOf('사진') != -1) {
            orderMeta['사진'] = orders[i].metaData![j].value;
          } else if (orders[i].metaData![j].key!.indexOf('의뢰 방법') != -1) {
            orderMeta['의뢰 방법'] = orders[i].metaData![j].value;
          }

          // else if (orders[i].metaData![j].key!.indexOf('추가 설명') != -1) {
          //   orderMeta['추가 설명'] = orders[i].metaData![j].value;
          // }

          else if (orders[i].metaData![j].key!.indexOf('추가 옵션') != -1) {
            orderMeta['추가 옵션'] = orders[i].metaData![j].value;
          } else if (orders[i].metaData![j].key!.indexOf('치수') != -1) {
            orderMeta['치수'] = orders[i].metaData![j].value;
          }
        }

        orderMeta['추가 설명'] = orders[i].customerNote!;

        // 첫 상위 카테고리 삽입
        cartItem.add(CartItem(
            lastCategrory[0].parent!,
            orders[i].id!,
            product.id!,
            orders[i].lineItems![0].name!,
            orders[i].lineItems![0].quantity!,
            cartCategory,
            ["cartImages"],
            orderMeta['의뢰 방법'],
            orderMeta['치수'],
            orderMeta['추가 설명'],
            orderMeta['물품 가액'],
            orders[i].lineItems![0].price!));

        checkItem.add([]);
      }

      // list 오름차순 정렬
      cartItem.sort((a, b) => a.cartCategory.compareTo(b.cartCategory));
      checkItem.toSet();

      for (int i = 0; i < cartItem.length; i++) {
        isCategorychecked.add(true);
      }

      iswholeChecked();
    } catch (e) {
      print("is getCart Error " + e.toString());
      return false;
    }
    return true;
  }

  // 해당 유저에 대한 주문 정보 (옷바구니)
  Future<bool> deleteCart(String type, int orderId) async {
    deleteOrderIds.clear();
    try {
      if (type == "choose") {
        for (int i = 0; i < orderid.length; i++) {
          await wp_api.wooCommerceApi.deleteOrder(orderId: orderid[i]);
        }
        print("this order choose deleted " + orderid.toString());
      } else {
        await wp_api.wooCommerceApi.deleteOrder(orderId: orderId);
        print("this order deleted " + orderId.toString());
      }

      Get.dialog(
        AlertDialogYes(
          titleText: "선택한 상품이 삭제되었습니다!",
          widgetname: "cart",
        ),
      );
      print("this order deleted " + orders.toString());
    } catch (e) {
      print("isError " + e.toString());
      return false;
    }
    return true;
  }

  // 접수 확인 list
  Future<void> getOrder() async {
    registerOrders.clear();
    try {
      for (int i = 0; i < orderid.length; i++) {
        registerOrders
            .add(await wp_api.wooCommerceApi.getOrderById(orderid[i]));
      }

      print("cartcontroller - getOrder orderItem info    " +
          orderItem.toString());
    } catch (e) {
      print("isError " + e.toString());
    }
  }

  // 선택한 주문에 대한 주소 입력
  Future<bool> registerAddress() async {
    Map order_map = {
      'first_name': user.firstName,
      'last_name': user.lastName,
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
