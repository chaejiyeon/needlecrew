import 'package:needlecrew/bottomsheet/fix_address_bottom_sheet_header.dart';
import 'package:needlecrew/bottomsheet/fix_my_address_list.dart';
import 'package:needlecrew/getxController/fixClothes/cartController.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/models/addressItem.dart';
import 'package:needlecrew/screens/main/fixClothes/takeFixdate.dart';
import 'package:needlecrew/widgets/fixClothes/fixClothesAppbar.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kpostal/kpostal.dart';

import '../../../widgets/fixClothes/progressbar.dart';

class AddressInsert extends StatefulWidget {
  const AddressInsert({Key? key}) : super(key: key);

  @override
  State<AddressInsert> createState() => _AddressInsertState();
}

class _AddressInsertState extends State<AddressInsert> {
  final CartController controller = Get.put(CartController());
  final HomeController homeController = Get.put(HomeController());

  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  TextEditingController textEditingController = TextEditingController();

  // List<AddressItem> addressitems = [
  //   AddressItem("assets/icons/myPage/mypageHome_1.svg", "우리집",
  //       "부산 강서구 명지국제3로 97 105동 221호")
  // ];

  @override
  void initState() {
    super.initState();
    // controller.isSaved(false);
  }

  // 주소 관리 bottomsheet
  void bottomsheetOpen(BuildContext context) {
    showStickyFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 0.5,
        maxHeight: 0.5,
        context: context,
        bottomSheetColor: HexColor("#909090").withOpacity(0.2),
        decoration: BoxDecoration(
          color: HexColor("#f5f5f5"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        headerHeight: 85,
        headerBuilder: (context, offset) {
          return homeController.items.length != 0
              ? FixAddressBottomSheetHeader(
                  addressExist: true,
                )
              : FixAddressBottomSheetHeader(
                  addressExist: false,
                );
        },
        bodyBuilder: (context, offset) {
          return SliverChildListDelegate([
            homeController.items.length != 0
                ? FixMyAddressList(
                    addressExist: true,
                    items: homeController.items,
                  )
                : FixMyAddressList(
                    addressExist: false,
                    items: homeController.items,
                  )
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: FixClothesAppBar(
          appbar: AppBar(),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 24,right: 24),
                  child: ProgressBar(progressImg: "fixProgressbar_3.svg")),
              Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(
                        text: "주소 입력",
                        fontsize: "lg",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    FontStyle(
                        text: "수거된 의류는 결제일로부터 3~4일 후\n수선사에게 도착합니다.",
                        fontsize: "",
                        fontbold: "",
                        fontcolor: Colors.black.withOpacity(0.7),
                        textdirectionright: false),
                    Container(
                      padding: EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          searchAddress("지번,도로명,건물명 검색"),
                          insertTextfield("상세주소"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: myaddressBtn(),
      ),
    );
  }

  // address 입력 필드
  Widget insertTextfield(String hintTxt) {
    return Container(
      child: TextField(
        controller: textEditingController,
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
          },
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        alignment: Alignment.center,
        height: 64,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: HexColor("#909090").withOpacity(0.5))),
        child: Text(
          postCode != "-" && address != "-" ? address : "지번, 도로명, 건물명 검색",
          style: TextStyle(color: HexColor("#909090"), fontSize: 15),
        ),
      ),
    );
  }

  // bottomnavigation 버튼
  Widget myaddressBtn() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              bottomsheetOpen(context);
            },
            child: Container(
              width: 150,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: HexColor("#fd9a03"),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FontStyle(
                      text: "내 주소",
                      fontcolor: HexColor("#fd9a03"),
                      fontsize: "",
                      fontbold: "",
                      textdirectionright: false),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(CupertinoIcons.chevron_up,
                      color: HexColor("#fd9a03"), size: 15),
                ],
              ),
            ),
          ),

          // 수거 희망일 페이지로이동
          GestureDetector(
            onTap: () {
              if (textEditingController.text.length > 0) {
                controller
                    .isAddress(address + " " + textEditingController.text);
                // controller.registerAddress();
                Get.to(TakeFixDate());
              }
            },
            child: Container(
              height: 63,
              alignment: Alignment.bottomCenter,
              child: textEditingController.text.length > 0
                  ? Image.asset(
                      "assets/icons/selectFloatingIcon.png",
                      width: 54,
                      height: 54,
                    )
                  : SvgPicture.asset(
                      "assets/icons/floatingNext.svg",
                      color: HexColor("#d5d5d5"),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
