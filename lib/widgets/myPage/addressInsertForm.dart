import 'package:get/get.dart';
import 'package:kpostal/kpostal.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class AddressInsertForm extends StatefulWidget {
  final String appbarName;
  final String hinttext1;
  final String hinttext2;
  final int index;

  const AddressInsertForm(
      {Key? key,
      required this.appbarName,
      required this.hinttext1,
      required this.hinttext2,
      this.index = 0})
      : super(key: key);

  @override
  State<AddressInsertForm> createState() => _AddressInsertFormState();
}

class _AddressInsertFormState extends State<AddressInsertForm> {
  final HomeController controller = Get.find();
  late String selectAddress = "";

  List setText = ["지번, 도로명, 건물명 검색", "상세주소"];

  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  @override
  void initState() {
    setState(() {
      selectAddress = controller.items[widget.index].addressName;
    });
    controller.textController = TextEditingController();
    controller.textController.text = widget.hinttext2;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (selectAddress == "우리집") {
      controller.updateUserInfo("default_address");
    } else if (selectAddress == "회사") {
      controller.updateUserInfo("company");
    } else {
      if (widget.index == 2) {
        controller.updateUserInfo("address_1");
      } else if (widget.index == 3) {
        controller.updateUserInfo("address_2");
      } else {
        controller.updateUserInfo("add_address");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MypageAppBar(
          title: widget.appbarName,
          icon: "",
          widget: MainHome(),
          appbar: AppBar()),
      body: Container(
        padding: EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            searchAddress(widget.hinttext1),
            CircleAddressSearch(widget.hinttext2),
            Container(
              padding: EdgeInsets.only(top: 31),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Typecheck("mypageHome.svg", "우리집"),
                  Typecheck("mypageCompany.svg", "회사"),
                  Typecheck("mypageLocation.svg", "기타"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 주소 입력폼
  Widget CircleAddressSearch(String title) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        onChanged: (value) {
          setState(() {});
        },
        controller: controller.textController,
        textAlign: widget.hinttext2 != "" ? TextAlign.start : TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 30, top: 16, bottom: 17),
          suffixIcon: IconButton(
            icon: controller.textController.text != ""
                ? SvgPicture.asset(
                    "assets/icons/xmarkIcon_full.svg",
                  )
                : Container(),
            onPressed: () {
              controller.textController.clear();
              setState(() {});
            },
          ),
          hintText: title != "" ? null : setText[1],
          hintStyle: TextStyle(
            color: widget.hinttext2 != "" ? Colors.black : HexColor("#a5a5a5"),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: HexColor("#d5d5d5"),
            ),
          ),
        ),
      ),
    );
  }

  // 주소 검색
  Widget searchAddress(String text) {
    return GestureDetector(
      onTap: () async {
        await Get.to(KpostalView(
          useLocalServer: true,
          localPort: 1024,
          // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
          callback: (Kpostal result) {
            setState(() {
              this.postCode = result.postCode;
              this.address = result.address;
              this.latitude = result.latitude.toString();
              this.longitude = result.longitude.toString();
              this.kakaoLatitude = result.kakaoLatitude.toString();
              this.kakaoLongitude = result.kakaoLongitude.toString();
            });
            controller.updateText = result.address;
          },
        ));
      },
      child: Container(
        padding: EdgeInsets.only(
            left: widget.hinttext1 != "" || postCode != "-" || address != "-"
                ? 30
                : 0,
            top: 16,
            bottom: 17),
        margin: EdgeInsets.only(bottom: 10),
        alignment: widget.hinttext1 != "" || postCode != "-" || address != "-"
            ? null
            : Alignment.center,
        // height: 64,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: HexColor("#d5d5d5"))),
        child: Text(
          widget.hinttext1 != "" && postCode == "-" && address == "-"
              ? widget.hinttext1
              : postCode != "-" && address != "-"
                  ? address
                  : setText[0],
          style: TextStyle(
              color: widget.hinttext1 != "" || postCode != "-" || address != "-"
                  ? Colors.black
                  : HexColor("#a5a5a5"),
              fontSize: 15),
          // TextStyle(color: widget.addressSearch == true
          //     ? HexColor("#a5a5a5") : Colors.black, fontSize: 15),
        ),
      ),
    );
  }

  // 주소 Type 버튼
  Widget Typecheck(String icon, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectAddress = text;
        });
      },
      child: Column(
        children: [
          SvgPicture.asset(
            "assets/icons/myPage/" + icon,
            color: selectAddress == text ? HexColor("#fd9a03") : Colors.black,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 3.7,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                  color: selectAddress == text
                      ? HexColor("#fd9a03")
                      : HexColor("#d5d5d5")),
              borderRadius: BorderRadius.circular(30),
            ),
            child: FontStyle(
                text: text,
                fontbold: "",
                fontsize: "md",
                fontcolor:
                    selectAddress == text ? HexColor("#fd9a03") : Colors.black,
                textdirectionright: false),
          ),
        ],
      ),
    );
  }
}
