import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  RxList ischecked = [].obs;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }


  // 초기화
  Future<void> initialize() async {
    return;
  }

  // 약관 동의
  void setChecked(){
    for(int i=0; i<4; i++){
      ischecked.add(false);
    }
    update();
  }

  // 동의 여부
  void isChecked(int index){
    if(ischecked[index] == true) {
      ischecked[index] = false;
    }else{
      ischecked[index] = true;
    }

    update();
  }


  // 전체 동의
  void wholeChecked(bool wholecheck){
    if(wholecheck == true){
      for(int i=0; i<4; i++){
        ischecked[i] = true;
      }
    }else{
      for(int i=0; i<4; i++){
        ischecked[i] = false;
      }
    }

    update();
  }
}
