import 'package:needlecrew/controller/homeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircleBlackBtn extends GetView<HomeController> {
  final Function function;
  final String btnText;

  const CircleBlackBtn({
    Key? key,
    required this.function,
    required this.btnText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    // controller.getCardAll();
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      child: TextButton(
        onPressed: () {
          function();
        },
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
