import 'package:flutter_svg/flutter_svg.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class UpdateForm extends StatefulWidget {
  final String appbarName;
  final String updateType;
  final String hintText;

  const UpdateForm({Key? key, required this.appbarName, required this.updateType, required this.hintText,}) : super(key: key);

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final HomeController controller = Get.put(HomeController());


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _textController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          MypageAppBar(title: widget.appbarName, icon: "", widget: MainHome(), appbar: AppBar()),
          Container(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FontStyle(
                    text: widget.updateType,
                    fontsize: "",
                    fontbold: "",
                    fontcolor: Colors.black,textdirectionright: false),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (value){
                    setState((){});
                  },
                  controller: controller.textController,
                  style: TextStyle(height: 1),
                  keyboardType: widget.updateType == "전화번호" ? TextInputType.number : null,
                  decoration: InputDecoration(

                      suffixIcon: controller.textController.text.isNotEmpty ? IconButton(
                        icon: SvgPicture.asset("assets/icons/xmarkIcon_full.svg",),
                        onPressed: () {
                          controller.textController.clear();
                          setState((){});
                        },
                      ) : null,
                      hintText: widget.hintText,
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
