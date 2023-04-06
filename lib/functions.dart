import 'package:get/get.dart';
import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_register_info.dart';

class Functions {
  void payTypeAdd() {
    HomeController controller = Get.find();
    if (paymentService.cardsInfo.length >= 1) {
      Get.to(FixRegisterInfo());
    } else {
      Get.toNamed("/payTypeAdd");
    }
  }
}
