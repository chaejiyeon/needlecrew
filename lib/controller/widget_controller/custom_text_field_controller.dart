import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomTextFieldController extends GetxController {
  static CustomTextFieldController get to => Get.find();

  // text editing controller list
  RxList textFieldControllers = [].obs;

  Rx<FocusNode> formFocus = FocusNode().obs;

  @override
  void onClose() {
    if (textFieldControllers.isNotEmpty) {
      for (Map item in textFieldControllers) {
        item['editing_controller'].dispose();
      }
    }
    super.onClose();
  }

  setInit(List textFields) {
    if (textFieldControllers.isNotEmpty) {
      textFieldControllers.clear();
    }
    for (String title in textFields) {
      textFieldControllers.add({
        'name': title,
        'editing_controller': TextEditingController(),
        'focus_node': FocusNode()
      });
    }
  }
}
