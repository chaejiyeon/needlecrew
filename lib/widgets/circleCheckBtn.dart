import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CircleCheckBtn extends StatefulWidget {
  final String list;
  final Widget listInfo;
  final bool checked;


  const CircleCheckBtn({Key? key, required this.list, required this.listInfo, required this.checked})
      : super(key: key);

  @override
  State<CircleCheckBtn> createState() => _RadioBtnState();
}

class _RadioBtnState extends State<CircleCheckBtn> {
  bool ischecked = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                side: BorderSide(
                  color: HexColor("#d5d5d5"),
                ),
                value: widget.checked == true ? ischecked == false : ischecked == true,
                onChanged: (value) {
                  setState(() {
                    ischecked = value!;
                  });
                }),
          ),
          SizedBox(width: 7,),
          Expanded(
            child: GestureDetector(
              onTap: (){
                // Get.to(widget.listInfo);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.list),
                  SvgPicture.asset("assets/icons/nextIcon.svg", color: HexColor("#d5d5d5"),height: 13, width: 7,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
