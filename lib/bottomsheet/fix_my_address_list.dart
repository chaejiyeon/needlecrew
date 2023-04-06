import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/models/address_item.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class FixMyAddressList extends StatefulWidget {
  final bool addressExist;
  final List items;

  const FixMyAddressList(
      {Key? key, required this.addressExist, required this.items})
      : super(key: key);

  @override
  State<FixMyAddressList> createState() => _FixMyAddressListState();
}

class _FixMyAddressListState extends State<FixMyAddressList> {
  bool ischecked = false;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeInitService.items.length != 0
          ? Container(
              padding: EdgeInsets.zero,
              child: Column(
                children: List.generate(homeInitService.items.length,
                    (index) => myaddressList(homeInitService.items[index])),
              ),
            )
          : Align(
              alignment: Alignment.topCenter,
              child: Text("등록된 주소가 없습니다."),
            ),
    );
  }

  // 주소가 있을 경우 주소 리스트 표시
  Widget myaddressList(AddressItem addressitem) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: addressitem.addressType == "home" ||
                        addressitem.addressType == "company"
                    ? SvgPicture.asset(
                        "assets/icons/myPage/${addressitem.addressType == "home" ? "mypageHome_1.svg" : "mypageCompany_1.svg"}")
                    : Image.asset('assets/icons/myPage/mypageLocation_1.png'),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FontStyle(
                            text: addressitem.addressType == 'home'
                                ? '우리집'
                                : addressitem.addressType == 'company'
                                    ? '회사'
                                    : '기타',
                            fontsize: "",
                            fontbold: "bold",
                            fontcolor: Colors.black,
                            textdirectionright: false),
                        FontStyle(
                            text: addressitem.address,
                            fontsize: "",
                            fontbold: "",
                            fontcolor: HexColor("#909090"),
                            textdirectionright: false),
                      ],
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          if (!ischecked) {
                            ischecked = true;
                          } else {
                            ischecked = false;
                          }
                        });
                      },
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: Image.asset(
                            'assets/icons/${ischecked ? 'selectCheckIcon.png' : 'checkBtnIcon.png'}'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Container(
              height: 1,
              width: double.infinity,
              decoration:
                  BoxDecoration(color: HexColor("#d5d5d5").withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }
}
