import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/controller/loginController.dart';

class CircleCheckBtn extends StatefulWidget {
  final String list;
  final Widget listInfo;
  final bool checked;
  final int index;

  const CircleCheckBtn(
      {Key? key,
      required this.list,
      required this.listInfo,
      required this.checked,
      required this.index})
      : super(key: key);

  @override
  State<CircleCheckBtn> createState() => _RadioBtnState();
}

class _RadioBtnState extends State<CircleCheckBtn> {
  final LoginController controller = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              controller.isChecked(widget.index);
              print("this checked index" +
                  controller.ischecked[widget.index].toString());
            },
            child: Obx(
              () => Row(
                children: [
                  controller.ischecked[widget.index] == true
                      ? SvgPicture.asset("assets/icons/checkedIcon.svg")
                      : SvgPicture.asset("assets/icons/uncheckedIcon.svg"),
                  SizedBox(
                    width: 7,
                  ),
                  Text(widget.list),
                ],
              ),
            ),
          ),
          Expanded(
            child:  GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.to(widget.listInfo);
              },
              child: Align(
              alignment: Alignment.centerRight,
              child:Container(
                  alignment: Alignment.centerRight,
                  width: 100,
                  child: SvgPicture.asset(
                    "assets/icons/nextIcon.svg",
                    color: HexColor("#d5d5d5"),
                    height: 13,
                    width: 7,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
