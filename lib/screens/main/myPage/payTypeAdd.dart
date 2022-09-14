import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/screens/main/myPage/payTypeAddConfirm.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class PayTypeAdd extends StatefulWidget {
  final bool isFirst;

  const PayTypeAdd({Key? key, required this.isFirst}) : super(key: key);

  @override
  State<PayTypeAdd> createState() => _PayTypeAddState();
}

class _PayTypeAddState extends State<PayTypeAdd> {
  final HomeController controller = Get.put(HomeController());
  late ScrollController scrollController = ScrollController();

  List<TextEditingController> editingcontroller =
      []; // 0 : 이름, 1 : 이메일, 2~5 : 카드번호, 6 : 유효기간, 7 : 비밀번호 앞2자리, 8 : 생년월일6자리

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> emailList = [
    '직접 입력',
    'gmail.com',
    'naver.com',
    'hanmail.net',
    'nate.com',
  ];

  String selectValue = "직접 입력";
  String currentField = "";

  @override
  void initState() {
    for (int i = 0; i < 9; i++) {
      editingcontroller.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < 9; i++) {
      editingcontroller[i].dispose();
    }
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        scrollController.animateTo(0,
            duration: Duration(milliseconds: 1), curve: Curves.linear);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: MypageAppBar(
            title: widget.isFirst == true ? "결제 수단 등록" : "결제 수단 추가 등록",
            icon: "",
            widget: MainHome(),
            appbar: AppBar()),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(left: 24, right: 24, top: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이름 입력
                  FontStyle(
                      text: "이름",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 10,
                  ),
                  textForm("이름", "", editingcontroller[0]),
                  SizedBox(
                    height: 10,
                  ),

                  // 이메일 입력
                  FontStyle(
                      text: "이메일",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: textForm("이메일", "", editingcontroller[1]),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(children: [
                        Container(
                          height: 44,
                          width: 118,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              value: selectValue,
                              onChanged: (value) {
                                setState(() {
                                  selectValue = value.toString();
                                });
                                print("selectValue  " + selectValue);
                              },
                              hint: Text(
                                emailList[0],
                                style: TextStyle(fontSize: 14),
                              ),
                              items: emailList
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Container(
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              color: HexColor("#909090"),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              buttonWidth: 166,
                              buttonHeight: 36,
                              buttonPadding:
                                  EdgeInsets.only(left: 10, right: 14),
                              buttonDecoration: BoxDecoration(
                                  border:
                                      Border.all(color: HexColor("#ededed")),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              icon: SvgPicture.asset(
                                "assets/icons/dropdownIcon.svg",
                                color: HexColor("#909090"),
                              ),
                            ),
                          ),
                        ),
                        currentField == "이메일"
                            ? Container(
                                height: 30,
                              )
                            : Container()
                      ]),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // 카드번호 입력
                  FontStyle(
                      text: "카드 번호",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 74,
                          child: textForm("카드 번호", "", editingcontroller[2])),
                      Container(
                          width: 74,
                          child: textForm("카드 번호", "", editingcontroller[3])),
                      Container(
                          width: 74,
                          child: textForm("카드 번호", "", editingcontroller[4])),
                      Container(
                          width: 74,
                          child: textForm("카드 번호", "", editingcontroller[5])),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // 유효기간
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FontStyle(
                                text: "유효기간",
                                fontsize: "",
                                fontbold: "",
                                fontcolor: Colors.black,
                                textdirectionright: false),
                            SizedBox(
                              height: 10,
                            ),
                            textForm("유효기간", "MM/YY", editingcontroller[6]),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FontStyle(
                                text: "비밀번호 앞 두자리",
                                fontsize: "",
                                fontbold: "",
                                fontcolor: Colors.black,
                                textdirectionright: false),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                    width: 80,
                                    child: textForm("비밀번호 앞 두자리", "",
                                        editingcontroller[7])),
                                SizedBox(
                                  width: 10,
                                ),
                                FontStyle(
                                    text: "**",
                                    fontsize: "",
                                    fontbold: "",
                                    fontcolor: HexColor("#909090"),
                                    textdirectionright: false),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // 생년월일
                  FontStyle(
                      text: "생년월일 6자리",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 10,
                  ),
                  textForm("생년월일", "-빼고 입력해주세요.", editingcontroller[8]),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
            padding: EdgeInsets.all(20),
            child: widget.isFirst == true
                ? formSubmitBtn(
                    "완료",
                    PayTypeAddConfirm(
                      isFirst: true,
                    ))
                : formSubmitBtn(
                    "등록하기",
                    PayTypeAddConfirm(
                      isFirst: false,
                    ))),
      ),
    );
  }

  // textfield form
  Widget textForm(
      String title, String hinttxt, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      onChanged: (value) {
        if (title == "카드 번호" || title == "유효기간") {
          if (value.length >= 4) {
            FocusScope.of(context).unfocus();
          }
        } else if (title == "비밀번호 앞 두자리") {
          if (value.length >= 2) {
            FocusScope.of(context).unfocus();
          }
        } else if (title == "생년월일") {
          if (value.length >= 6) {
            FocusScope.of(context).unfocus();
          }
        }
      },
      validator: (value) {
        if (title == "이름") {
          RegExp regExp = new RegExp(r'^([가-힣|a-zA-Z])+$');

          if (value.toString().length <= 2 ||
              !regExp.hasMatch(value.toString())) {
            return "이름을 정확히 입력해주세요.";
          }
        } else if (title == "이메일") {
          RegExp regExp1 = new RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

          RegExp regExp2 = new RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))$');

          if (selectValue == "직접 입력") {
            if (!regExp1.hasMatch(value!)) {
              setState(() {
                currentField = "이메일";
              });
              return "이메일 주소를 확인해 주세요.";
            }
          } else {
            if (!regExp2.hasMatch(value!)) {
              setState(() {
                currentField = "이메일";
              });
              return "이메일 주소를 확인해 주세요.";
            }
          }
        }
      },
      keyboardType: title == "카드 번호" ||
              title == "유효기간" ||
              title == "비밀번호 앞 두자리" ||
              title == "생년월일"
          ? TextInputType.number
          : null,
      obscureText: title == "비밀번호 앞 두자리" ? true : false,
      onTap: () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      },
      textAlign: hinttxt == "MM/YY" ? TextAlign.center : TextAlign.left,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(fontSize: 12),
        hintText: hinttxt != "" && title == currentField ? hinttxt : null,
        hintStyle: TextStyle(color: HexColor("#909090"), fontSize: 12),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: HexColor("#ededed")),
        ),
        suffixIcon: title == "이메일" && selectValue != "직접 입력"
            ? Container(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  "@",
                  style: TextStyle(color: HexColor("#909090")),
                ),
              )
            : null,
        suffixIconConstraints: BoxConstraints(),
      ),
    );
  }

  Widget formSubmitBtn(String btnText, Widget widgetName) {
    String customer_uid = "";
    String expiry = "";
    String cardNum = "";

    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      child: TextButton(
        onPressed: () {
          if (this._formKey.currentState!.validate()) {
            setState(() {
              customer_uid = editingcontroller[0].text +
                  "_" +
                  DateFormat('yymmdd').format(DateTime.now()) +
                  "_" +
                  editingcontroller[5].text;
              expiry = "20" + editingcontroller[6].text.substring(2, 3) + "-" + editingcontroller[6].text.substring(0, 1);

              cardNum = editingcontroller[2].text +
                  "-" +
                  editingcontroller[3].text +
                  "-" +
                  editingcontroller[4].text +
                  "-" +
                  editingcontroller[5].text;
            });

            Get.to(widgetName);
            // 카드정보 설정
            controller.setCardInfo({
              "card_number": cardNum,
              "expiry": expiry,
              "birth": editingcontroller[8].text,
              "pwd_2digit": editingcontroller[7].text,
              "customer_uid": customer_uid
            });
            controller.getData();
            print("결제카드 등록 성공!!!!!!");
          } else {
            print("currentfield    " + currentField);
            Get.snackbar("결제카드 등록", "입력된 정보를 확인해주세요!!");
          }
        },
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
