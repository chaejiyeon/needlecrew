import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/controller/my_use_info/useInfo_controller.dart';
import 'package:needlecrew/getx_services/home_init_service.dart';
import 'package:needlecrew/getx_services/order_services.dart';
import 'package:needlecrew/getx_services/payment_service.dart';
import 'package:needlecrew/getx_services/product_services.dart';
import 'package:needlecrew/getx_services/update_user_service.dart';
import 'package:needlecrew/getx_services/utils_service.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(() => ProductServices(), permanent: true);
    Get.put(() => HomeInitService(), permanent: true);
    Get.put(() => OrderServices(), permanent: true);
    Get.put(() => PaymentService(), permanent: true);
    Get.put(() => UtilsService(), permanent: true);
    Get.put(() => UpdateUserService(), permanent: true);
    Get.put(CartController());
    Get.put(UseInfoController());
    Get.lazyPut(() => HomeController());
  }
}
