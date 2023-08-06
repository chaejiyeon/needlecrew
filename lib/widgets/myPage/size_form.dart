import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SizeForm extends StatefulWidget {
  final String title;
  final String hintTxt;
  final TextEditingController? editingController;
  final bool isTextfield;

  const SizeForm(
      {Key? key,
      required this.title,
      required this.hintTxt,
      this.editingController,
      required this.isTextfield})
      : super(key: key);

  @override
  State<SizeForm> createState() => _SizeFormState();
}

class _SizeFormState extends State<SizeForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      child: widget.isTextfield == true
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FontStyle(
                    text: widget.title,
                    fontsize: "",
                    fontbold: "",
                    fontcolor: Colors.black,
                    textdirectionright: false),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: widget.editingController,
                  style: TextStyle(height: 0.5),
                  decoration: InputDecoration(
                    hintText: widget.hintTxt,
                    suffixIcon: Container(
                        padding: EdgeInsets.only(top: 10.h), child: Text("cm")),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: HexColor("#d5d5d5"),
                      ),
                    ),
                  ),
                )
              ],
            )
          : Container(
              padding: EdgeInsets.zero,
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: HexColor("#ededed"),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title),
                  Row(
                    children: [
                      Text(widget.hintTxt),
                      SizedBox(
                        width: 8,
                      ),
                      Text("cm"),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
