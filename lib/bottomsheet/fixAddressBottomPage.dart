import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

// 주소 등록 페이지 bottom sheet
class AddressInsert extends StatefulWidget {
  const AddressInsert({Key? key}) : super(key: key);

  @override
  State<AddressInsert> createState() => _AddressInsertState();
}

class _AddressInsertState extends State<AddressInsert> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                insertTextfield("지번,도로명,건물명 검색"),
                insertTextfield("상세주소"),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Typecheck("mypageHome.svg", "우리집"),
                      Typecheck("mypageCompany.svg", "회사"),
                      Typecheck("mypageLocation.svg", "기타"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(padding: EdgeInsets.all(20),child: CircleBlackBtn(btnText: "완료", pageName: "back")),
        ],
      ),
    );
  }

  // address 입력 필드
  Widget insertTextfield(String hintTxt) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            hintText: hintTxt,
            hintStyle: TextStyle(color: HexColor("#909090")),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: HexColor("#909090"),
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: HexColor("#909090").withOpacity(0.5),
                ))),
      ),
    );
  }

  // 주소 Type 버튼
  Widget Typecheck(String icon, String text) {
    return GestureDetector(
      child: Column(
        children: [
          SvgPicture.asset("assets/icons/myPage/" + icon),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: HexColor("#d5d5d5")),
              borderRadius: BorderRadius.circular(30),
            ),
            child: FontStyle(
                text: text,
                fontbold: "",
                fontsize: "md",
                fontcolor: Colors.black,
                textdirectionright: false),
          ),
        ],
      ),
    );
  }
}



// 주소 관리 bottom sheet
class AddressManagement extends StatefulWidget {
  const AddressManagement({Key? key}) : super(key: key);

  @override
  State<AddressManagement> createState() => _AddressManagementState();
}

class _AddressManagementState extends State<AddressManagement> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
