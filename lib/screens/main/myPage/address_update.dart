import 'package:get/get.dart';
import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:needlecrew/widgets/myPage/address_insert_form.dart';
import 'package:flutter/material.dart';

class AddressUpdate extends StatelessWidget {
  final int index;

  const AddressUpdate({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    final address = homeInitService.items[index].address.split(",");

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AddressInsertForm(
            appbarName: "주소 수정",
            hinttext1:
                address.length > 1 && address[0] != null ? address[0] : "",
            hinttext2: address.length == 1
                ? address[0]
                : address.length == 2
                    ? address[1]
                    : "",
            index: index),
        bottomNavigationBar: Container(
            padding: EdgeInsets.all(20),
            child: CircleBlackBtn(
                function: () => controller.updateAddress('update'),
                btnText: "완료")),
      ),
    );
  }
}
