import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:intl/intl.dart';
import 'package:needlecrew/models/cartItemModel.dart';
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
  RxBool isWholechecked = false.obs;

  // 카테고리별 전체 선택
  RxBool isCategorychecked = false.obs;

  // 상위 카테고리 구별
  List category = [];

  // 상위 카테고리
  String thisCategory = "";

  // 옷바구니 리스트
  List<CartItem> cartItem = [];
  List<List<CartItem>> cartListitem = [];

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
    await getCart();

    isInitialized.value = true;
    return;
  }

  // productId 값 설정
  void isProductId(int productId) {
    productid.value = productId;
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
  void isOrderId(bool ischecked, int orderId) {
    if (ischecked == true) {
      registerid.value.add(orderId);
      orderid.value.add(orderId);
      print("주문 등록할 orderid " + orderid.value.toString());
      orderCount.value++;
    } else {
      for (int i = 0; i < orderid.length; i++) {
        if (orderid[i] == orderId) {
          registerid.value.removeAt(i);
          orderid.value.removeAt(i);
        }
      }
      print("주문 등록할 orderid " + orderid.value.toString());
      orderCount.value--;
    }

    update();
  }

  // 총 비용 설정
  void iswholePrice(bool ischecked, int price) {
    if (ischecked == true) {
      wholePrice.value += price + 6000;
    } else {
      wholePrice.value -= price + 6000;
    }

    print("wholePrice " + wholePrice.value.toString());
    update();
  }

  // 수거 희망일
  void fixDate(String selectMonth, String selectDay) {
    fixdate.value = selectMonth + "월" + selectDay + "일";
    update();
  }

  // 단위 변환
  String setPrice() {
    String setPrice = NumberFormat('###,###,###').format(wholePrice.value);
    update();
    return setPrice;
  }

  // // fixselect 상위 카테고리
  // Future<bool> getProductCategory(int productId) async {
  //   cartCount.value = 0;
  //   category.clear();
  //
  //
  //   try {
  //     WooProduct product = await wp_api.wooCommerceApi.getProductById(id: productId);
  //     String slug = Uri.decodeComponent(product.categories[0].slug.toString());
  //
  //
  //     category = slug.split('-');
  //
  //
  //     thisCategory = category[category.length-2] + category[category.length-1];
  //
  //     print("upcategory this info      " + thisCategory.toString());
  //     print("category this info      " + category.toString());
  //
  //
  //
  //   } catch (e) {
  //     print("is getProductCategory Error $e");
  //     return false;
  //   }
  //   return true;
  // }

  // 해당 유저에 대한 주문 정보 (옷바구니)
  Future<bool> getCart() async {
    orderid.clear();
    try {
      cartItem.clear();
      cartListitem.clear();

      user = await wp_api.getUser();

      orders = await wp_api.wooCommerceApi
          .getOrders(customer: user.id, status: ['pending']);

      Map orderMeta = {
        '의뢰 방법': '',
        '치수': '',
        '추가 설명': '',
        '물품 가액': '',
        '추가 옵션': '',
        '사진': '',
      };

      WooProduct product;
      String slug = "";

      print("orders length this     " + orders.length.toString());

      // 첫 상위 카테고리에 넣어주고 카테고리별 리스트 넣어주고 cartInfo에서 CartListItem으로 뿌려줌
      for (int i = 0; i < orders.length; i++) {
        product = await wp_api.wooCommerceApi
            .getProductById(id: orders[i].lineItems![0].productId!);
        slug = Uri.decodeComponent(product.categories[0].slug.toString());

        // print("cart orders length this    " + orders.length.toString());
        if (orders[i].metaData![i].key!.indexOf('물품 가액') != -1) {
          orderMeta['물품 가액'] = orders[i].metaData![i].value;
        } else if (orders[i].metaData![i].key!.indexOf('사진') != -1) {
          orderMeta['사진'] = orders[i].metaData![i].value;
        } else if (orders[i].metaData![i].key!.indexOf('의뢰 방법') != -1) {
          orderMeta['의뢰 방법'] = orders[i].metaData![i].value;
        } else if (orders[i].metaData![i].key!.indexOf('추가 설명') != -1) {
          orderMeta['추가 설명'] = orders[i].metaData![i].value;
        } else if (orders[i].metaData![i].key!.indexOf('추가 옵션') != -1) {
          orderMeta['추가 옵션'] = orders[i].metaData![i].value;
        } else if (orders[i].metaData![i].key!.indexOf('치수') != -1) {
          orderMeta['치수'] = orders[i].metaData![i].value;
        }

        print("get cartInfo init!!!!!!!!!");

        // 첫 상위 카테고리 삽입
        cartItem.add(CartItem(
            orders[i].lineItems![0].name!,
            orders[i].lineItems![0].quantity!,
            slug.split('-'),
            ["cartImages"],
            orderMeta['의뢰 방법'],
            orderMeta['치수'],
            orderMeta['추가 설명'],
            orderMeta['물품 가액'],
            orders[i].lineItems![0].price!));

        print("get cartitem this      " + cartItem.toString());
      }
      // 1. 첫 카테고리를 cartItem 리스트에 넣어준다 (cartListitem이 비었을때)
      if (cartListitem.length == 0) {
        cartListitem.add([cartItem[0]]);
      }

      cartSeperate();
    } catch (e) {
      print("is getCart Error " + e.toString());
      return false;
    }
    return true;
  }

  void cartSeperate() {
    for (int i = 0; i < cartItem.length; i++) {
      print("cartitem productname this     " + cartItem[i].cartProductName);
    }




    for (int i = 0; i < cartListitem.length; i++) {
      // if(cartListitem[0][0].cartCategory == cartItem[i].cartCategory && cartListitem[0][0].cartProductName != cartItem[i].cartProductName){
      //   cartListitem[cartListitem.length].add(cartItem[i]);
      // }else{
      //   cartListitem[cartListitem.length + 1].add(cartItem[i]);
      // }
      // 3. cartListitem의 cartItem category와 같은 cartListitem[index]에 추가 해준다.
      for (int j = 0; j < cartItem.length; j++) {
        String listCategory = "";
        String itemCategory = "";


        // for(int k = 0; k < cartItem[j].cartCategory.length; k++){
        //  listCategory += cartItem[j].cartCategory[k];
        //  print("listCategory this   " + listCategory);
        // }
        //
        // for(int l =0; l < cartListitem[i][0].cartCategory.length; l++){
        //   itemCategory += cartListitem[i][0].cartCategory[l];
        //   print("itemCategory this   " + itemCategory);
        // }



        if (listCategory == itemCategory &&
            cartListitem[i][0].cartProductName != cartItem[j].cartProductName) {
          cartListitem[i].add(cartItem[j]);

          // print("this cartlistitem seperate           ");
        } else {
          // print("seperate else init !!!");
          // 4. cartListitem의 cartItem category와 같은 값이 없을 경우 새로 추가
          cartListitem.add([cartItem[j]]);
        }
      }
    }

    print("get cartListitem length this     " + cartListitem.length.toString());
  }

  // 해당 유저에 대한 주문 정보 (옷바구니)
  Future<bool> deleteCart() async {
    try {
      for (int i = 0; i < orderid.length; i++) {
        await wp_api.wooCommerceApi.deleteOrder(orderId: orderid[i]);
      }

      print("this order deleted " + orders.toString());

      // // 접수 완료 시 완료 된 주문건 제외 후 옷바구니에 표시
      // if(setSave == true) {
      //   orders = await wp_api.wooCommerceApi.getOrders(customer: user.id,);
      //   for(int i=0; i< registerid.length; i++){
      //     for (int j = 0; j < orders.length; j++) {
      //       if (registerid[i] == orders[j].id) {
      //         orders.removeAt(j);
      //       }
      //     }
      //   }
      // }else {
      //   orders = await wp_api.wooCommerceApi.getOrders(customer: user.id,);
      // }
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
        // print("getorder " + registerOrders.toString());
      }
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
      {'key': '수거 희망일', 'value': fixdate.value}
    ];

    try {
      for (int i = 0; i < orderid.length; i++) {
        order =
            await wp_api.wooCommerceApi.updateOrder(id: orderid[i], orderMap: {
          'billing': order_map,
          'shipping': order_map,
          'customer_note': '주문 완료',
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
}
