import 'package:flutter/cupertino.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:get/get.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';

class MysizeInfoController extends GetxController {
  static MysizeInfoController get to => Get.find();

  // 사이즈 text controller
  RxList sizeController = [].obs;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    if (sizeController.isNotEmpty) {
      for (Map item in sizeController) {
        item.forEach((key, value) {
          item[key].dispose();
        });
      }
    }
    super.onClose();
  }

  /// text controller 설정
  void setInit(List sizeInfo) {
    for (Map item in sizeInfo) {
      sizeController.add({item['key_name']: TextEditingController()});
    }
  }

  /// 사이즈 수정
  Future updateSize(String sizeType) async {
    try {
      var key = '';
      var value = '';
      switch (sizeType) {
        case 'shirt':
          key = 'shirt_size';
          if (sizeController.length == 1) {
            sizeController.first.forEach((key, setValue) {
              if (setValue.text.isNotEmpty) {
                value += '{"$key": "${setValue.text}"}';
              } else {
                value += '{"$key": "0"}';
              }
            });
          } else {
            for (int i = 0; i < sizeController.length; i++) {
              if (i == 0) {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '{"$key": "${setValue.text}",';
                  } else {
                    value += '{"$key": "0",';
                  }
                });
              } else if (i + 1 != sizeController.length) {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '"$key": "${setValue.text}",';
                  } else {
                    value += '"$key": "0",';
                  }
                });
              } else {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '"$key": "${setValue.text}"}';
                  } else {
                    value += '"$key": "0"}';
                  }
                });
              }
            }
          }
          break;
        case 'pants':
          key = 'pants_size';
          if (sizeController.length == 1) {
            sizeController.first.forEach((key, setValue) {
              if (setValue.text.isNotEmpty) {
                value += '{"$key": "${setValue.text}"}';
              } else {
                value += '{"$key": "0"}';
              }
            });
          } else {
            for (int i = 0; i < sizeController.length; i++) {
              if (i == 0) {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '{"$key": "${setValue.text}",';
                  } else {
                    value += '{"$key": "0",';
                  }
                });
              } else if (i + 1 != sizeController.length) {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '"$key": "${setValue.text}",';
                  } else {
                    value += '"$key": "0",';
                  }
                });
              } else {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '"$key": "${setValue.text}"}';
                  } else {
                    value += '"$key": "0"}';
                  }
                });
              }
            }
          }
          break;
        case 'one_piece':
          key = 'onepiece_size';
          if (sizeController.length == 1) {
            sizeController.first.forEach((key, setValue) {
              if (setValue.text.isNotEmpty) {
                value += '{"$key": "${setValue.text}"}';
              } else {
                value += '{"$key": "0"}';
              }
            });
          } else {
            for (int i = 0; i < sizeController.length; i++) {
              if (i == 0) {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '{"$key": "${setValue.text}",';
                  } else {
                    value += '{"$key": "0",';
                  }
                });
              } else if (i + 1 != sizeController.length) {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '"$key": "${setValue.text}",';
                  } else {
                    value += '"$key": "0",';
                  }
                });
              } else {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '"$key": "${setValue.text}"}';
                  } else {
                    value += '"$key": "0"}';
                  }
                });
              }
            }
          }
          break;
        case 'skirt':
          key = 'skirt_size';
          if (sizeController.length == 1) {
            sizeController.first.forEach((key, setValue) {
              if (setValue.text.isNotEmpty) {
                value += '{"$key": "${setValue.text}"}';
              } else {
                value += '{"$key": "0"}';
              }
            });
          } else {
            for (int i = 0; i < sizeController.length; i++) {
              if (i == 0) {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '{"$key": "${setValue.text}",';
                  } else {
                    value += '{"$key": "0",';
                  }
                });
              } else if (i + 1 != sizeController.length) {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '"$key": "${setValue.text}",';
                  } else {
                    value += '"$key": "0",';
                  }
                });
              } else {
                sizeController[i].forEach((key, setValue) {
                  if (setValue.text.isNotEmpty) {
                    value += '"$key": "${setValue.text}"}';
                  } else {
                    value += '"$key": "0"}';
                  }
                });
              }
            }
          }
          break;
      }

      homeInitService.user.value.value = await wp_api.wooCommerceApi
          .updateCustomer(id: homeInitService.user.value.value!.id!, data: {
        'meta_data': [WooCustomerMetaData(null, key, value)],
      });

      printInfo(
          info:
              '========== update user size success ========== ${homeInitService.user.value.value!.id}');


      Get.dialog(
          barrierDismissible: false,
          CustomDialog(
            header: DialogHeader(
              title: '사이즈 변경',
              content: '사이즈가 변경되었습니다!',
            ),
            bottom: DialogBottom(isExpanded: true, btn: [
              BtnModel(
                callback: () {
                  Get.close(3);
                },
                text: '확인',
              )
            ]),
          ));
    } catch (e) {
      printInfo(info: '============ update size failed ============\n$e');
    }
  }
}
