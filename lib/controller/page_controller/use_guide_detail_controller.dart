import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vertical_scrollable_tabview/vertical_scrollable_tabview.dart';

class UseGuideDetailController extends GetxController
    with GetTickerProviderStateMixin {
  static UseGuideDetailController get to => Get.find();

  var tabController = Rxn<TabController>().obs;
  ScrollController? scrollController;
  var verticalPosition = Rxn<VerticalScrollPosition>().obs;

  List<String> items = ["쇼핑몰에서 보낼 경우", "집에서 보낼 경우"];
  RxString selectValue = "쇼핑몰에서 보낼 경우".obs;

  void onInit() {
    tabController.value.value = TabController(length: 5, vsync: this);
    verticalPosition.value.value = VerticalScrollPosition.begin;
    super.onInit();
  }

  void onClose() {
    super.onClose();
  }
}
