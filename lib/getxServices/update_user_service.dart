import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/db/wp-api.dart';

class UpdateUserService extends GetxService {
  @override
  void onInit() async {
    super.onInit();
  }

  /// user metadata update
  Future<bool> updateUser(
      String metaKey, String metaValue, String dialogText) async {
    try {
      await wp_api.wooCommerceApi
          .updateCustomer(id: homeInitService.user.value.value!.id!, data: {
        'meta_data': [WooCustomerMetaData(null, metaKey, metaValue)],
      });

      return true;
    } catch (e) {
      return false;
    }
  }

}
