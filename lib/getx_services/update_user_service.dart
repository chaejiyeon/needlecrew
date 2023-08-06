import 'package:flutter/cupertino.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:get/get.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';

class UpdateUserService extends GetxService {
  @override
  void onInit() async {
    super.onInit();
  }

  /// user metadata update
  Future<bool> updateUser(
      {String metaKey = '',
      String metaValue = '',
      String headerText = '',
      String headerContext = ''}) async {
    try {
      await wp_api.wooCommerceApi
          .updateCustomer(id: homeInitService.user.value.value!.id!, data: {
        'meta_data': [WooCustomerMetaData(null, metaKey, metaValue)],
      });
      Get.dialog(CustomDialog(
          header: DialogHeader(title: headerText, content: headerContext),
          bottom: DialogBottom(
              mainAlignment: MainAxisAlignment.center,
              btn: [BtnModel(text: '확인', callback: () => Get.close(3))])));
      return true;
    } catch (e) {
      Get.dialog(CustomDialog(
          header: DialogHeader(title: headerText, content: headerContext),
          bottom: DialogBottom(
              mainAlignment: MainAxisAlignment.center,
              btn: [BtnModel(text: '확인', callback: () => Get.close(2))])));
      return false;
    }
  }

  // 수선 확정 버튼 클릭 시 > 수선 진행중으로 status  변경
  Future<void> updateState(int orderId, Map updateInfo) async {
    try {
      await wp_api.wooCommerceApi
          .updateOrder(id: orderId, orderMap: updateInfo);

      print("order status change complete!!! ");

      // Get.off(() => PayMent());
    } catch (e) {
      print("isupdateState Error $e");
    }
  }
}


