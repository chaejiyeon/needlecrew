import 'package:get/get.dart';

class MypayInfoController extends GetxController {
  static MypayInfoController get to => Get.find();

  // 결제 내역
  RxList payInfoList = [].obs;
}
