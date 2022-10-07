import 'package:get/get.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/screens/main/myPage/addressList.dart';
import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/myPage/addressInsertForm.dart';
import 'package:flutter/material.dart';

class AddressUpdate extends StatelessWidget {
  final int index;

  const AddressUpdate({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    final address = controller.items[index].address.split(",");
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AddressInsertForm(
            appbarName: "주소 수정",
            addressSearch: false,
            hinttext1:
                address.length > 0 && address[0] != null ? address[0] : "",
            hinttext2: address.length == 2 ? address[1] : ""),
        bottomNavigationBar: Container(
            padding: EdgeInsets.all(20),
            child: CircleBlackBtn(btnText: "완료", pageName: "back")),
      ),
    );
  }
}
