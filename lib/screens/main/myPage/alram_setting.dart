import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';

class AlramSetting extends StatefulWidget {
  const AlramSetting({Key? key}) : super(key: key);

  @override
  State<AlramSetting> createState() => _AlramSettingState();
}

class _AlramSettingState extends State<AlramSetting> {
  bool serviceSwitch = false;
  bool eventSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: '알림 설정',
        leadingWidget: BackBtn(),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  // 서비스 및 이용 공지
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "서비스 및 이용 공지",
                        style:
                            TextStyle(fontSize: 14, color: HexColor("#202427")),
                      ),
                      FlutterSwitch(
                          width: 52,
                          inactiveColor: HexColor("#cccccc"),
                          activeColor: HexColor("#fa9d03"),
                          value: serviceSwitch,
                          onToggle: (value) {
                            setState(() {
                              serviceSwitch = value;
                            });
                          })
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListLine(
                      height: 1,
                      width: double.infinity,
                      lineColor: HexColor("#edededed"),
                      opacity: 1),
                  SizedBox(
                    height: 20,
                  ),

                  // 이벤트 및 혜택 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "이벤트 및 혜택 정보",
                        style:
                            TextStyle(fontSize: 14, color: HexColor("#202427")),
                      ),
                      FlutterSwitch(
                          width: 52,
                          inactiveColor: HexColor("#cccccc"),
                          activeColor: HexColor("#fa9d03"),
                          value: eventSwitch,
                          onToggle: (value) {
                            setState(() {
                              eventSwitch = value;
                            });
                          })
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListLine(
                      height: 1,
                      width: double.infinity,
                      lineColor: HexColor("#edededed"),
                      opacity: 1),
                ],
              ),
            ),
            // alramSettingItem("서비스 및 이용 공지", serviceSwitch),
            // alramSettingItem("이벤트 및 혜택 정보", eventSwitch),
          ],
        ),
      ),
    );
  }

// Widget alramSettingItem(String settingName, bool isswitch) {
//   return Container(
//     padding: EdgeInsets.only(top: 15),
//     child: Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               settingName,
//               style: TextStyle(fontSize: 14, color: HexColor("#202427")),
//             ),
//             FlutterSwitch(
//
//                 value: isswitch,
//                 onToggle: (value) {
//                   setState(() {
//                     isswitch = value;
//                   });
//                 })
//           ],
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         ListLine(
//             height: 1,
//             width: double.infinity,
//             lineColor: HexColor("#edededed"),
//             opacity: 1),
//       ],
//     ),
//   );
// }
}
