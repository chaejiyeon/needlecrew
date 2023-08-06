import 'dart:developer';

import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/order_payload.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/db/wp-api.dart';

class OrderServices extends GetxService {
  RxMap getOrder = {}.obs;

  RxBool isPressed = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  /// product 조회 : order > productId로
  Future searchProductById(int? productId) async {
    WooProduct product;
    String slug = "";
    List slugItem = [];
    String productName = '';

    product = await wp_api.wooCommerceApi.getProductById(id: productId!);
    slug = Uri.decodeComponent(product.categories[0].slug.toString());

    slugItem = slug.split('-');

    for (int i = 0; i < slugItem.length; i++) {
      if (slugItem[i] != "줄임" && slugItem[i] != "늘임" && slugItem[i] != "기타") {
        productName += slugItem[i];
      }
    }
    getOrder.value = {'product_name': productName, 'product_info': product};
  }

  /// variation 조회
  Future<WooProductVariation?> searchVariationById(
      int? productId, int? variationId) async {
    try {
      WooProductVariation variation;
      variation = await wp_api.wooCommerceApi.getProductVariationById(
          productId: productId!, variationId: variationId);
      printInfo(info: 'search variation this ${variation.id}');
      return variation;
    } catch (e) {
      printInfo(info: 'search variation failed ===============\n$e');
      return null;
    }
  }

  /// 주문 수정
  Future updateOrder(int orderId, Map updateContent) async {
    // try {
    printInfo(info: 'update order this $updateContent');

    /// 업데이트 전 : 주문 삭제 후 재생성
    await wp_api.wooCommerceApi.deleteOrder(orderId: orderId);

    printInfo(info: 'update order this');
    printInfo(info: 'update order this $updateContent');

    await wp_api.wooCommerceApi.createOrder(WooOrderPayload(
      customerId: homeInitService.user.value.value!.id,
      status: 'pending',
      customerNote: updateContent['추가 설명'],
      lineItems: updateContent['line_items'],
      metaData: updateContent['meta_data'],
    ));
    printInfo(info: 'update order success====================');
    // return true;
    // } catch (e) {
    //   printInfo(info: 'update order failed=====================\n$e');
    //   return false;
    // }
  }

  /// 장바구니 추가
  addCart(
      {Map registerInfo = const {},
      List<WooOrderPayloadMetaData> metadata = const []}) async {
    // { "product_id" : productId,"variationId": variationId, "select_count" : 0, "customer_note": add_description(추가 설명), }
    CartController cartController = Get.find();
    cartController.isLoading.value = false;
    try {
      List<LineItems> lineItems = [
        LineItems(
          quantity: registerInfo['select_count'],
          productId: registerInfo['product_id'],
          variationId: registerInfo['variation_id'],
        ),
      ];

      WooOrderPayload wooOrderPayload = WooOrderPayload(
        customerId: homeInitService.user.value.value!.id,
        status: 'pending',
        lineItems: lineItems,
        metaData: metadata,
      );

      var resultInfo = await wp_api.wooCommerceApi.createOrder(wooOrderPayload);

      print('장바구니 담기 성공');
      return {'result': true, 'info': resultInfo};
    } catch (e) {
      print('장바구니 담기 실패' + e.toString());
      return {'result': false, 'info': null};
    }
  }
}
