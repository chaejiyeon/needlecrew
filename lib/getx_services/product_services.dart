import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'dart:developer';

import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:get/get.dart';

class ProductServices extends GetxController {

  RxBool isLoading = false.obs;
  /// id 값으로 수선 항목 카테고리 조회
  Future searchCategoryById(int searchId) async {
    isLoading.value = true;
    try {
      var resultList = [];
      List<WooProductCategory> categories =
          await wp_api.wooCommerceApi.getProductCategories(
        parent: searchId,
      );

      log('search category by id success $isLoading');

      for (WooProductCategory item in categories) {
        resultList.add({'id': item.id.toString(), 'name': item.name});
      }
      isLoading.value = false;
      return resultList;
    } catch (e) {
      log('search category by id failed ================$e');
    }
  }

  /// 상품 조회 : parent ids로
  Future searchProductsById(List<int> searchId) async {
    try {
      List<WooProduct> result =
          await wp_api.wooCommerceApi.getProducts(parent: searchId);
      log('dssearch product by id success $result');
      for (int i = 0; i < result.length; i++) {
        log('result product this ${result[i]}');
        result[i];
      }
      return result;
    } catch (e) {
      log('search product by id failed ================$e');
      return [];
    }
  }
}
