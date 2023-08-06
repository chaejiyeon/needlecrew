import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/widgets/tootip_custom.dart';

class VisibleInfo extends StatelessWidget {
  final bool visible;
  final List<Map> formInfo; // { titleText, tooltipText, targetText, istooltip }

  const VisibleInfo({Key? key, required this.visible, required this.formInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Container(
        child: Column(
            children: List.generate(
                formInfo.length, (index) => listItem(index, formInfo[index]))),
      ),
      visible: visible,
    );
  }

  Widget listItem(int index, Map item) {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          formInfo[index]["istooltip"] == true
              ? TooltipCustom(
                  tooltipText: formInfo[index]["tooltipText"],
                  titleText: formInfo[index]["titleText"],
                  boldText: formInfo[index]["targetText"] != []
                      ? formInfo[index]["targetText"]
                      : [],
                  tailPosition: "up",
                  fontsize: 14,
                )
              : Text(
                  formInfo[index]["titleText"],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSansCJKkrRegular',
                    color: Colors.black,
                  ),
                ),
          EasyRichText(
            formInfo[index]["price"] + "원",
            defaultStyle: TextStyle(
              fontSize: 14,
              fontFamily: 'NotoSansCJKkrRegular',
              color: Colors.black,
            ),
            patternList: [
              EasyRichTextPattern(
                targetString: formInfo[index]["price"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
