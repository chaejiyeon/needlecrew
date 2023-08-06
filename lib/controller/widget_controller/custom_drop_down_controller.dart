import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart';

class CustomDropDownController extends GetxController {
  static CustomDropDownController get to => Get.find();

  // 첫 번째 카테고리 항목
  RxList parentCategories = [].obs;
  RxString selectParent = ''.obs;

  // 첫 번째 > 두 번째 카테고리 항목
  RxList secondCategories = [].obs;
  RxString selectSecond = ''.obs;

  // 첫 번째 > 두 번째 > 마지막 카테고리 항목
  RxList lastCategories = [].obs;
  RxString selectLast = ''.obs;

  // 필터된 수선 가격 목록표
  RxList filteredPriceInfo = <WooProduct>[].obs;

  @override
  void onInit() async {
    if (homeInitService.priceCategories.isNotEmpty) {
      for (Map item in homeInitService.priceCategories) {
        parentCategories.add(item);
      }
      var secondCategoriesItem = await productServices
          .searchCategoryById(int.parse(parentCategories.first['id']));

      if (secondCategoriesItem.isNotEmpty) {
        for (Map item in secondCategoriesItem) {
          secondCategories.add(item);
        }
      }

      var lastCategoriesItem = await productServices
          .searchCategoryById(int.parse(secondCategories.first['id']));

      if (lastCategoriesItem.isNotEmpty) {
        for (Map item in lastCategoriesItem) {
          lastCategories.add(item);
        }
      }
    }
    selectParent.value = parentCategories.first['id'];
    selectSecond.value = secondCategories.first['id'];
    selectLast.value = lastCategories.first['id'];

    filteredPriceInfo.value = await productServices.searchProductsById([
      int.parse(selectParent.value),
      int.parse(selectSecond.value),
      int.parse(selectLast.value)
    ]);

    ever(homeInitService.priceCategories, (callback) async {
      parentCategories.clear();
      secondCategories.clear();
      lastCategories.clear();
      if (homeInitService.priceCategories.isNotEmpty) {
        for (Map item in homeInitService.priceCategories) {
          parentCategories.add(item);
        }
        var secondCategoriesItem = await productServices
            .searchCategoryById(int.parse(parentCategories.first['id']));

        if (secondCategoriesItem.isNotEmpty) {
          for (Map item in secondCategoriesItem) {
            secondCategories.add(item);
          }
        }

        var lastCategoriesItem = await productServices
            .searchCategoryById(int.parse(secondCategories.first['id']));

        if (lastCategoriesItem.isNotEmpty) {
          for (Map item in lastCategoriesItem) {
            lastCategories.add(item);
          }
        }
      }
    });
    ever(selectParent, (callback) async {
      List<int> searchIds = [];
      searchIds.add(int.parse(selectParent.value));
      if (selectSecond.value != 'default') {
        searchIds.add(int.parse(selectSecond.value));
      }
      if (selectLast.value != 'default') {
        searchIds.add(int.parse(selectLast.value));
      }
      filteredPriceInfo.value =
          await productServices.searchProductsById(searchIds);
    });
    ever(selectSecond, (callback) async {
      List<int> searchIds = [];
      searchIds.add(int.parse(selectParent.value));
      searchIds.add(int.parse(selectSecond.value));
      if (selectLast.value != 'default') {
        searchIds.add(int.parse(selectLast.value));
      }
      filteredPriceInfo.value =
          await productServices.searchProductsById(searchIds);
    });
    ever(selectLast, (callback) async {
      List<int> searchIds = [];
      searchIds.add(int.parse(selectParent.value));
      searchIds.add(int.parse(selectLast.value));
      if (selectSecond.value != 'default') {
        searchIds.add(int.parse(selectSecond.value));
      }
      filteredPriceInfo.value =
          await productServices.searchProductsById(searchIds);
    });
    super.onInit();
  }
}
