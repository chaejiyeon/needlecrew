import 'package:needlecrew/widgets/mainhome/priceInfo/priceDropdown.dart';
import 'package:needlecrew/widgets/mainhome/priceInfo/priceDropdownHeader.dart';
import 'package:needlecrew/widgets/mainhome/priceInfo/tableHeader.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PriceListSheetHeader extends StatefulWidget {
  const PriceListSheetHeader({Key? key}) : super(key: key);

  @override
  State<PriceListSheetHeader> createState() => _PriceListSheetHeaderState();
}

class _PriceListSheetHeaderState extends State<PriceListSheetHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          PriceDropdownHeader(),
          PriceDropDown(
            selectNum: 1,
            hintCheck: false,
            hint: "",
          ),
          PriceDropDown(
            selectNum: 2,
            hintCheck: false,
            hint: "",
          ),
          PriceDropDown(
            selectNum: 3,
            hintCheck: false,
            hint: "",
          ),
          // table header
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
            child: Row(
              children: [
                Align(
                  child: TableHeader(
                      width: 80,
                      borderColor: HexColor("#fd9a03").withOpacity(0.6),
                      text: "종류"),
                ),
                Expanded(
                  child: TableHeader(
                      width: 190,
                      borderColor: HexColor("#fd9a03").withOpacity(0.2),
                      text: "수선"),
                ),
                 TableHeader(
                      width: 80,
                      borderColor: HexColor("#fd9a03").withOpacity(0.2),
                      text: "가격"),
              ],
            ),
          ),
        ],
    );
  }
}
