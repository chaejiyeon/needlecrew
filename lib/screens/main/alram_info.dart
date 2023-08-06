import 'package:flutter/services.dart';
import 'package:needlecrew/models/alram_item.dart';
import 'package:needlecrew/widgets/alramInfo/alram_btn_text.dart';
import 'package:needlecrew/widgets/alramInfo/alram_list_item.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlramInfo extends StatefulWidget {
  const AlramInfo({Key? key}) : super(key: key);

  @override
  State<AlramInfo> createState() => _AlramInfoState();
}


class _AlramInfoState extends State<AlramInfo> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AlramAppbar(
        appbar: AppBar(),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FontStyle(
                      text: "알림",
                      fontsize: "lg",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Expanded(
                child: ListView(
              children: List.generate(
                  alrams.length,
                  (index) => AlramListItem(
                        alram: alrams[index],
                      )),
            )),
          ],
        ),
      ),
    );
  }
}

// alram appbar
class AlramAppbar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appbar;

  const AlramAppbar({Key? key, required this.appbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            CupertinoIcons.xmark,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(

          statusBarBrightness: Brightness.light
      ),
      // brightness: Brightness.light,
      elevation: 0,
      actions: [
        alramBtnText(text: "전체선택",textColor: Colors.black),
        SizedBox(
          width: 32,
        ),
        alramBtnText(text:  "삭제",textColor: Colors.red),
        SizedBox(
          width: 24,
        ),
      ],
      // systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}




//
// // alram appbar itemBtn
// Widget alramBtnTxt(String text, Color textColor) {
//   return GestureDetector(
//     onTap: () {
//       if (text == "전체선택") {
//         if (wholeCheck == false)
//           wholeCheck = true;
//         else
//           wholeCheck == false;
//       }
//     },
//     child: Container(
//       padding: EdgeInsets.only(top: 20),
//       child: Text(
//         text,
//         style: TextStyle(color: textColor, fontSize: 16),
//       ),
//     ),
//   );
// }
