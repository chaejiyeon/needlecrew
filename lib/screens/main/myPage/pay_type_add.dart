import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/screens/main/myPage/pay_type_add_confirm.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class PayTypeAdd extends StatefulWidget {
  final bool isFirst;

  const PayTypeAdd({Key? key, required this.isFirst}) : super(key: key);

  @override
  State<PayTypeAdd> createState() => _PayTypeAddState();
}

class _PayTypeAddState extends State<PayTypeAdd> with TickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());
  late ScrollController scrollController = ScrollController();

  List<TextEditingController> editingcontroller =
      []; // 0 : 이름, 1 : 이메일, 2~5 : 카드번호, 6 : 유효기간, 7 : 비밀번호 앞2자리, 8 : 생년월일6자리

  List<FocusNode> focusnode = [];

  List onTaped = [];

  int currentIndex = 0;

  bool isSuccess = true;
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
      focusnode.add(FocusNode());
      onTaped.add(false);
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
        appBar: CustomAppbar(
          appbarcolor: 'white',
          appbar: AppBar(),
          title: widget.isFirst == true ? "결제 수단 등록" : "결제 수단 추가 등록",
          leadingWidget: BackBtn(),
        ),
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
                      text: onTaped[0] == true ? "" : "이름",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 6,
                  ),
                  textForm(true, "이름", "이름", "", 0),
                  SizedBox(
                    height: 10,
                  ),

                  // 이메일 입력
                  FontStyle(
                      text: onTaped[1] == true ? "" : "이메일",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: textForm(true, "이메일", "이메일", "", 1),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Container(
                            height: 47,
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
                          SizedBox(
                            height: isSuccess == false ? 30 : 0,
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // 카드번호 입력
                  FontStyle(
                      text: onTaped[2] == true ? "" : "카드 번호",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 74,
                          child: textForm(true, "카드 번호", "카드 번호", "", 2)),
                      Container(
                          width: 74, child: textForm(false, "", "카드번호", "", 3)),
                      Container(
                          width: 74, child: textForm(false, "", "카드번호", "", 4)),
                      Container(
                          width: 74, child: textForm(false, "", "카드번호", "", 5)),
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
                                text: onTaped[6] == true ? "" : "유효기간",
                                fontsize: "",
                                fontbold: "",
                                fontcolor: Colors.black,
                                textdirectionright: false),
                            SizedBox(
                              height: 6,
                            ),
                            textForm(true, "유효기간", "유효기간", "MM/YY", 6),
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
                                text: onTaped[7] == true ? "" : "비밀번호",
                                fontsize: "",
                                fontbold: "",
                                fontcolor: Colors.black,
                                textdirectionright: false),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Container(
                                    width: 80,
                                    child:
                                        textForm(true, "앞 두자리", "비밀번호", "", 7)),
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
                      text: onTaped[8] == true ? "" : "생년월일 6자리",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 6,
                  ),
                  textForm(true, "생년월일 6자리", "생년월일", "-빼고 입력해주세요.", 8),
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
      bool isLabel, String labelText, String title, String hinttxt, int index) {
    return TextFormField(
      maxLength: title == "생년월일"
          ? 6
          : title == "카드 번호" || title == "카드번호" || title == "유효기간"
              ? 4
              : title == "비밀번호 앞 두자리"
                  ? 2
                  : null,
      focusNode: focusnode[index],
      controller: editingcontroller[index],
      onChanged: (value) {
        if (value.length > 0) {
          setState(() {
            onTaped[index] = true;
          });
          if (index < editingcontroller.length &&
              index != editingcontroller.length - 1) {
            if (title == "카드 번호" || title == "카드번호" || title == "유효기간") {
              if (value.length >= 4) {
                FocusScope.of(context).requestFocus(focusnode[index + 1]);
              }
            }
            if (title == "비밀번호") {
              if (value.length >= 2) {
                FocusScope.of(context).requestFocus(focusnode[index + 1]);
              }
            }
            if (title == "생년월일") {
              if (value.length >= 6) {
                FocusScope.of(context).unfocus();
              }
            }
          }
        } else {
          setState(() {
            onTaped[index] = false;
          });

          FocusScope.of(context).unfocus();
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
              title == "카드번호" ||
              title == "유효기간" ||
              title == "비밀번호" ||
              title == "생년월일"
          ? TextInputType.number
          : title == "이메일"
              ? TextInputType.emailAddress
              : null,
      obscureText: title == "비밀번호" ? true : false,
      onTap: () {
        setState(() {
          currentField = title;
          onTaped[index] = true;
          currentIndex = index;
        });
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      },
      // textAlign: title != "유효기간" ? TextAlign.center : TextAlign.left,
      decoration: InputDecoration(
        counterText: '',
        floatingLabelBehavior:
            onTaped[index] == true ? FloatingLabelBehavior.always : null,
        label: title == "유효기간"
            ? Container(
                alignment: onTaped[index] == true ? null : Alignment.center,
                child: Text(onTaped[index] == true ? labelText : hinttxt),
              )
            : Text(onTaped[index] == true ? labelText : hinttxt),
        labelStyle: TextStyle(
            fontSize: 12,
            color: isLabel == true && onTaped[index] == false && hinttxt == ""
                ? Colors.white
                : HexColor("#909090")),
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
    String currentYear = DateTime.now().year.toString().substring(0, 2);

    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      child: TextButton(
        onPressed: () async {
          if (this._formKey.currentState!.validate()) {
            bool isCompleted = false;

            setState(() {
              isCompleted = true;
              print("expiry this " + editingcontroller[6].text);
              customer_uid = editingcontroller[0].text +
                  DateFormat('yymmdd').format(DateTime.now()) +
                  editingcontroller[5].text;
              expiry = currentYear +
                  editingcontroller[6].text.substring(2, 4) +
                  "-" +
                  editingcontroller[6].text.substring(0, 2);

              cardNum = editingcontroller[2].text +
                  "-" +
                  editingcontroller[3].text +
                  "-" +
                  editingcontroller[4].text +
                  "-" +
                  editingcontroller[5].text;
            });

            print("this expiry num " + editingcontroller[6].text);

            // 카드정보 설정
            isCompleted = await paymentService.registerPaymentCard({
              "name": editingcontroller[0].text,
              "email": selectValue != "직접 입력"
                  ? editingcontroller[1].text + "@" + selectValue
                  : editingcontroller[1].text,
              "card_number": cardNum,
              "expiry": expiry,
              "birth": editingcontroller[8].text,
              "pwd_2digit": editingcontroller[7].text,
              "customer_uid": customer_uid
            });

            if (isCompleted == true) {
              Get.to(widgetName);
              print("결제카드 등록 성공!!!!!!");
            }
          } else {
            setState(() {
              isSuccess = false;
            });
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
