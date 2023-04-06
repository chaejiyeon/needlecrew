import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/getxServices/home_init_service.dart';
import 'package:needlecrew/getxServices/order_services.dart';
import 'package:needlecrew/getxServices/payment_service.dart';
import 'package:needlecrew/getxServices/update_user_service.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(() => HomeInitService(), permanent: true);
    Get.put(() => OrderServices(), permanent: true);
    Get.put(() => PaymentService(), permanent: true);
    Get.put(() => UpdateUserService(), permanent: true);
    Get.lazyPut(() => HomeController());
  }
}
