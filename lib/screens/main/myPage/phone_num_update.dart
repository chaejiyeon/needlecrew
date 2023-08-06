import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/myPage/update_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom/custom_widgets.dart';

class PhoneNumUpdate extends StatefulWidget {
  const PhoneNumUpdate({Key? key}) : super(key: key);

  @override
  State<PhoneNumUpdate> createState() => _PhoneNumUpdateState();
}

class _PhoneNumUpdateState extends State<PhoneNumUpdate> {
  final HomeController controller = Get.find();

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
        appBar: CustomAppbar(
          appbarcolor: 'white',
          appbar: AppBar(),
          title: '전화번호 변경',
          leadingWidget: BackBtn(),
        ),
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
            function: () async {
              await updateUserService.updateUser(
                  metaKey: 'phoneNum',
                  metaValue: controller.textController.text,
                  headerText: '전화번호 변경');
              // controller.updateUser('전화번호 변경'),
            },
            btnText: "변경 완료",
          ),
        ),
      ),
    );
  }
}
