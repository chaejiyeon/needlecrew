import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../controller/fixClothes/fixselectController.dart';


class RadioBtn extends StatefulWidget {
  final String list;
  final double bottomPadding;
  final String textBold;
  final bool checked;

  const RadioBtn(
      {Key? key,
      required this.list,
      required this.bottomPadding,
      required this.textBold,
      this.checked = false})
      : super(key: key);

  @override
  State<RadioBtn> createState() => _RadioBtnState();
}

class _RadioBtnState extends State<RadioBtn> {
  final FixSelectController controller = Get.put(FixSelectController());
  bool ischecked = false;


  @override
  Widget build(BuildContext context) {

    return Obx(
      () =>
        CustomRadioWidget(
          text: widget.list,
          value: widget.list,
          groupValue: controller.isSelected.value,
          onChanged: (value) {
            controller.isSelectedValue(widget.list);
            controller.isSelected.value = value.toString();
          },
        ),
      // ),
    );
  }
}

// radio custom
class CustomRadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;
  final String text;

  CustomRadioWidget(
      {required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.text,
      this.width = 20,
      this.height = 20});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(this.value);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 19),
        child: Row(
          children: [
            Container(
              height: this.height,
              width: this.width,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1,
                  color: value == groupValue
                      ? HexColor("fd9a03")
                      : HexColor("#d5d5d5"),
                ),
              ),
              child: Center(
                child: Container(
                  height: this.height - 8,
                  width: this.width - 8,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color:
                        value == groupValue ? HexColor("fd9a03") : Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            Text(text),
          ],
        ),
      ),
    );
  }
}
