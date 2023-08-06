import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/screens/main/main_home.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class UpdateForm extends StatefulWidget {
  final String appbarName;
  final String updateType;
  final String hintText;

  const UpdateForm({
    Key? key,
    required this.appbarName,
    required this.updateType,
    required this.hintText,
  }) : super(key: key);

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final HomeController controller = Get.find();

  @override
  void initState() {
    controller.textController = TextEditingController();
    controller.textController.text = widget.hintText;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40.h, left: 24.w, right: 24.w),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: widget.updateType,
                  fontSize: FontSize().fs4,
                  formMargin: EdgeInsets.only(bottom: 7),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: controller.textController,
                  style: TextStyle(height: 1),
                  keyboardType:
                      widget.updateType == "전화번호" ? TextInputType.number : null,
                  decoration: InputDecoration(
                      suffixIcon: controller.textController.text != ""
                          ? IconButton(
                              icon: SvgPicture.asset(
                                "assets/icons/xmarkIcon_full_acolor.svg",
                              ),
                              onPressed: () {
                                controller.textController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: HexColor("#d5d5d5"),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
