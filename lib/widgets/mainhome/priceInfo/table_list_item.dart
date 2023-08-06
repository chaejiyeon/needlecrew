import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:hexcolor/hexcolor.dart';

class TableListItem extends StatefulWidget {
  final String type;
  final String fixInfo;
  final String price;

  const TableListItem({
    Key? key,
    required this.type,
    required this.fixInfo,
    required this.price,
  }) : super(key: key);

  @override
  State<TableListItem> createState() => _TableListItemState();
}

class _TableListItemState extends State<TableListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomText(
                  formWidth: 80.w, text: widget.type, fontSize: FontSize().fs4),
              Expanded(
                child: CustomText(
                    formMargin: EdgeInsets.only(left: 15.w),
                    formAlign: Alignment.centerLeft,
                    text: widget.fixInfo,
                    fontSize: FontSize().fs4),
              ),
              CustomText(
                  formAlign: Alignment.centerRight,
                  formWidth: 80.w,
                  text:
                      "₩ ${FormatMethod().convertPrice(price: int.parse(widget.price))}",
                  fontSize: FontSize().fs4),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListLine(
              height: 1,
              width: double.infinity,
              lineColor: HexColor("#d5d5d5"),
              opacity: 0.5),
        ],
      ),
    );
  }
}
