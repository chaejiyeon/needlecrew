import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class CustomWidgetController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static CustomWidgetController get to => Get.find();

  late AnimationController animationController;

  RxBool isAnimated = true.obs;

  @override
  void onInit() async {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
