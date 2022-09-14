import 'package:needlecrew/models/addressItem.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class FixMyAddressList extends StatefulWidget {
  final bool addressExist;
  final List<AddressItem> items;

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
    return widget.addressExist == true
        ? Container(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(widget.items.length,
                  (index) => myaddressList(widget.items[index])),
            ),
          )
        : Container(
            alignment: Alignment.center,
            child: Text("등록된 주소가 없습니다."),
          );
  }

  // 주소가 있을 경우 주소 리스트 표시
  Widget myaddressList(AddressItem addressitem) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(addressitem.img),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontStyle(
                      text: addressitem.addressName,
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
              Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: HexColor("#fd9a03"),
                  side: BorderSide(
                    color: HexColor("#d5d5d5"),
                  ),
                  value: ischecked,
                  onChanged: (value) {
                    setState(() {
                      ischecked = value!;
                    });
                  }),
            ],
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: HexColor("#d5d5d5").withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }
}
