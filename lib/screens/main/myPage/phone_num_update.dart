import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/getxServices/home_init_service.dart';
import 'package:needlecrew/modal/alert_dialog_yes.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:needlecrew/widgets/myPage/update_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumUpdate extends StatefulWidget {
  const PhoneNumUpdate({Key? key}) : super(key: key);

  @override
  State<PhoneNumUpdate> createState() => _PhoneNumUpdateState();
}

class _PhoneNumUpdateState extends State<PhoneNumUpdate> {
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    controller.textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.updateUserInfo('phoneNum');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => UpdateForm(
            appbarName: "전화번호 변경",
            updateType: "전화번호",
            hintText: homeInitService.userInfo['phone_number'] != ''
                ? homeInitService.userInfo['phone_number']
                : "",
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(20),
          child: CircleBlackBtn(
            function: () => {
              // controller.updateUser('전화번호 변경'),
            },
            btnText: "변경 완료",
          ),
        ),
      ),
    );
  }
}
