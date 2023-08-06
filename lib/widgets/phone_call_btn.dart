import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/functions.dart';
import 'package:needlecrew/models/util/font_size.dart';

class PhoneCallBtn extends StatelessWidget {
  const PhoneCallBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 54),
      margin: EdgeInsets.only(bottom: 50),
      color: Colors.white,
      height: 200,
      child: Column(
        children: [
          GestureDetector(
              onTap: () {
                Functions().makePhoneCall();
              },
              child: Container(
                width: 150.w,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: HexColor("#d5d5d5").withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(3, 1),
                      )
                    ]),
                child: Row(
                  children: [
                    Expanded(child: Icon(CupertinoIcons.phone_fill)),
                    CustomText(
                      formMargin: EdgeInsets.only(left: 10),
                      text: '070-8095-4668',
                      fontSize: FontSize().fs4,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: Container(
                  // margin: EdgeInsets.only(bottom: 10),
                  child: Text(
            "평일 오전 9시 ~ 오후 6시까지 상담하며\n주말 및 공휴일은 휴무입니다.",
            textAlign: TextAlign.center,
          ))),
        ],
      ),
    );
  }
}
