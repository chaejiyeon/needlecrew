import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;

class OrderServices extends GetxService {
  @override
  void onInit() async {
    super.onInit();
  }

  /// product 조회 : order > productId로
  Future searchOrderById(int? productId) async {
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
    return {'product_name': productName, 'product_info': product};
  }
}
