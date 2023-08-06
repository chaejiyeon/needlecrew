import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';

class CustomDropDown extends StatelessWidget {
  final dynamic dropDownWidth;
  final dynamic dropDownHeight;
  final dynamic dropDownMargin;

  //
  final dynamic dropDownItemWidth;

  //
  final String hintText;

  //
  final EdgeInsets dropDownBtnPadding;

  //
  final Object? value;
  final Function(Object?)? onChange;

  //
  final List dropDownItems;

  const CustomDropDown(
      {Key? key,
      this.dropDownWidth,
      this.dropDownHeight,
      this.dropDownMargin,
      this.dropDownItemWidth,
      this.hintText = '',
      this.dropDownBtnPadding = EdgeInsets.zero,
      this.value,
      this.onChange,
      this.dropDownItems = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dropDownWidth,
      height: dropDownHeight,
      margin: dropDownMargin,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          dropdownWidth: dropDownItemWidth,
          hint: CustomText(
              text: hintText,
              fontColor: SetColor().colorD5,
              fontSize: FontSize().fs),
          dropdownPadding: EdgeInsets.zero,
          dropdownDecoration:
              BoxDecoration(borderRadius: BorderRadius.circular(10)),
          // style: TextStyle(
          //   color: dropTextColor,
          //   fontSize: FontSize().ftsize,
          //   fontWeight: dropTextWeight,
          // ),
          isExpanded: true,
          buttonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: SetColor().colorD5),
          ),
          icon: SvgPicture.asset(
            "assets/icons/dropdownIcon.svg",
            color: SetColor().color90,
          ),
          buttonPadding: dropDownBtnPadding,
          value: value,
          items: List<DropdownMenuItem<String>>.generate(
            dropDownItems.length,
            (index) => DropdownMenuItem(
              value: dropDownItems[index]['id'],
              child: Text(dropDownItems[index]['name'],
                  style: TextStyle(
                    color: value == dropDownItems[index]['id'] &&
                            value != 'default'
                        ? Colors.black
                        : SetColor().color70,
                    fontSize: FontSize().fs4,
                  )),
            ),
          ),
          onChanged: onChange,
        ),
      ),
    );
  }
}
