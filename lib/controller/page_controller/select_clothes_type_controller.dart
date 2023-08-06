import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/fix_clothes/fixselect_controller.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;

class SelectClothesTypeController extends GetxController
    with GetTickerProviderStateMixin {
  static SelectClothesTypeController get to => Get.find();

  // 선택한 카테고리 하위 목록
  RxList selectCategories = <WooProductCategory>[].obs;

  // 선택한 카테고리의 상품 목록
  RxList selectProducts = <WooProduct>[].obs;

  // tab controller 설정
  var tabController = Rxn<TabController>().obs;

  // 선택한 카테고리 아이디값
  RxInt selectCategoryId = 0.obs;

  // 선택한 카테고리 항목 : back btn 클릭시 돌아갈 카테고리 아이디 목록
  RxList crumbs = [].obs;

  // 마지막 선택 카테고리
  RxString lastCategoryName = ''.obs;

  // 부모 아이디
  RxInt selectParentId = 0.obs;

  // 선택한 상품  - {'product': WooProduct, 'variation': WooProductVariation}
  RxMap productInfo = {}.obs;

  // 선택한 상품 등록 텍스트 컨트롤러 리스트
  RxList registerController = ['size', 'product_price', 'add_description'].obs;

  // 기타 - 선택 수량 설정
  RxInt selectCount = 1.obs;

  // 선택한 총 금액
  RxInt selectWholePrice = 0.obs;

  @override
  void onInit() {
    // setCategories(selectParentId.value);
    ever(selectParentId, <int>(callback) {
      setCategories(selectParentId.value);
    });
    ever(selectCategoryId, (callback) => {getProducts()});
    super.onInit();
  }

  @override
  void onClose() {
    tabController.value.value?.dispose();
    super.onClose();
  }

  // 의류 선택 진입 설정
  setCategories(int parentId) async {
    log('set init parent id this $parentId');
    FixSelectController fixSelectController = Get.find();
    if (selectCategories.isNotEmpty) {
      selectCategories.clear();
    }

    if (parentId == 0) {
      fixSelectController.crumbs.clear();
    }
    // fixSelectController.crumbs.add(parentId);

    selectCategories.value = await wp_api.wooCommerceApi
        .getProductCategories(parent: parentId, order: 'desc');

    tabController.value.value =
        TabController(length: selectCategories.length, vsync: this);

    if (selectCategories.indexWhere((element) => element.name == '기타') != -1) {
      lastCategoryName.value = selectCategories.first.name;
      selectCategoryId.value = selectCategories.first.id;
      getProducts();
    }
    selectCategories.refresh();
    log('set init select category length this ${selectCategories.length}');
  }

  // 카테고리 상품 가져오기
  getProducts() async {
    if (selectProducts.isNotEmpty) {
      selectProducts.clear();
    }
    log('get product init ------');
    selectProducts.value = await wp_api.wooCommerceApi.getProducts(
        perPage: 100,
        // orderBy: 'slug',
        category: selectCategoryId.value == 0
            ? selectCategories.first.id.toString()
            : selectCategoryId.value.toString());

    selectProducts.refresh();
  }

  // 상품 - 추가 정보 조회
  getVariationById(int? productId, int? categoryId) async {
    log('category id this $categoryId');

    if (productInfo['product_category_info'] != null) {
      productInfo['product_category_info'] = null;
    }
    if (productInfo['variation'] != null) {
      productInfo['variation'] = null;
    }
    productInfo['product_category_info'] = await wp_api.wooCommerceApi
        .getProductCategoryById(categoryId: categoryId!);
    productInfo['variation'] =
        await wp_api.wooCommerceApi.getProductVariations(productId: productId!);

    log('variation this ${productInfo['variation']}');
  }
}
