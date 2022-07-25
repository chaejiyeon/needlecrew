import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class PriceDropDown extends StatefulWidget {
  final bool hintCheck;
  final String hint;
  final int selectNum;

  const PriceDropDown({Key? key,required this.hintCheck, required this.selectNum, required this.hint}) : super(key: key);

  @override
  State<PriceDropDown> createState() => _PriceDropDownState();
}

class _PriceDropDownState extends State<PriceDropDown> {
  List select1 = [
    {'no': 1, 'keyword': '하의'},
    {'no': 2, 'keyword': '상의'},
    {'no': 3, 'keyword': '아우터'},
    {'no': 4, 'keyword': '원피스'},
    {'no': 5, 'keyword': '정장/교복'}
  ];
  List select2 = [
    {'no': 1, 'keyword': '바지'},
    {'no': 2, 'keyword': '스커트'},
  ];
  List select3 = [
    {'no': 1, 'keyword': '일반바지'},
    {'no': 2, 'keyword': '청바지'},
    {'no': 3, 'keyword': '트레이닝바지'},
    {'no': 4, 'keyword': '가죽/레지바지'},
  ];

  List select4 = [
    {'no': 1, 'keyword': 'gmail.com'},
    {'no': 2, 'keyword': 'naver.com'},
    {'no': 3, 'keyword': 'hanmail.net'},
    {'no': 4, 'keyword': 'nate.com'},
  ];

  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
  var _selectedTest;
  bool selected = false;

  @override
  void initState() {
    _dropdownTestItems = buildDropdownTestItems(widget.selectNum == 1
        ? select1
        : widget.selectNum == 2
            ? select2 : widget.selectNum == 3 ? select3
            : select4);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<DropdownMenuItem<Object?>> buildDropdownTestItems(List select) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in select) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i['keyword']),
        ),
      );
    }
    return items;
  }

  onChangeDropdownTests(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest = selectedTest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: widget.selectNum == 4 ? EdgeInsets.only(left: 10) : EdgeInsets
            .only(left: 20, right: 20, top: 5, bottom: 5),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            value: _selectedTest,
            onChanged: onChangeDropdownTests,
            style: TextStyle(fontSize: 14, color: Colors.black),
            hint: widget.hintCheck == true
                ? Text(widget.hint,)
                : _dropdownTestItems[0],
            items: _dropdownTestItems,
            buttonWidth: 166,
            buttonHeight: 41,
            buttonPadding: EdgeInsets.only(left: 25, right: 14,),
            buttonDecoration: BoxDecoration(
                border: Border.all(
                    color: HexColor("#d5d5d5")
                ),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white),
            icon: SvgPicture.asset(
              "assets/icons/dropdownIcon.svg",
              color: HexColor("#909090"),
            ),
          ),
        ));
  }

}
