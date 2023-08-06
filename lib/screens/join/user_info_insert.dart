import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/screens/join/user_phone_insert.dart';
import 'package:needlecrew/widgets/base_appbar.dart';
import 'package:needlecrew/widgets/floating_next_btn.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class UserInfoInsert extends StatefulWidget {
  const UserInfoInsert({Key? key}) : super(key: key);

  @override
  State<UserInfoInsert> createState() => _UserInfoInsertState();
}

class _UserInfoInsertState extends State<UserInfoInsert> {
  final HomeController homeController = Get.find();
  ScrollController _scrollController = ScrollController();
  List<TextEditingController> editingcontroller = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool availablePassword = false;
  String passwordAlert = "";
  String currentField = "";

  @override
  void initState() {
    for (int i = 0; i < 4; i++) {
      editingcontroller.add(TextEditingController());
    }

    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < 4; i++) {
      editingcontroller[i].dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: BaseAppbar(
          appbar: AppBar(),
          prevFunction: () => Get.back(),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 25.w, right: 25.w),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30.h),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(
                        text: "고객님의 정보를",
                        fontsize: "lg",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    FontStyle(
                        text: "입력해주세요",
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
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        loginTextField("이름", "이름 입력", editingcontroller[0]),
                        loginTextField(
                            "이메일 주소", "이메일 주소 입력", editingcontroller[1]),
                        loginTextField("비밀번호", "영문/숫자/특수문자 포함 8~16자 입력",
                            editingcontroller[2]),
                        loginTextField(
                            "비밀번호 확인", "비밀번호를 재입력해주세요.", editingcontroller[3]),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 111,
                child: FloatingNextBtn(
                    margin: EdgeInsets.only(bottom: 20.h),
                    function: () async {
                      if (this._formKey.currentState!.validate()) {
                        List keyList = [
                          "user_name",
                          "email",
                          "password",
                          "checkPassword"
                        ];
                        for (int i = 0; i < editingcontroller.length; i++) {
                          homeController.setUserInfo(
                              keyList[i], editingcontroller[i].text);
                        }
                        if (editingcontroller[1].text != 'test@test.com') {
                          Get.to(UserPhoneInsert());
                        } else {
                          if (editingcontroller[2].text != 'test1234!') {
                            Get.snackbar('테스트 비밀번호', '테스트 비밀번호를 입력해주세요!');
                          } else {
                            await homeController.LoginUs();
                            Get.offAllNamed('/mainHome');
                          }
                        }
                      } else {
                        Get.snackbar("회원가입", "입력된 정보를 확인해주세요!");
                      }
                    },
                    ischecked: editingcontroller[0].text.length > 0 &&
                            editingcontroller[1].text.length > 0 &&
                            editingcontroller[2].text.length > 0 &&
                            editingcontroller[3].text.length > 0
                        ? true
                        : false),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 회원가입 필드 위젯
  Widget loginTextField(
      String titleText, String hintText, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Container(
            child: TextFormField(
              validator: (value) {
                if (titleText == "이름") {
                  RegExp regExp = new RegExp(r'^([가-힣|a-zA-Z])+$');

                  if (value.toString().length <= 2 ||
                      !regExp.hasMatch(value.toString())) {
                    return "이름을 정확히 입력해주세요.";
                  }
                } else if (titleText == "이메일 주소") {
                  RegExp regExp = new RegExp(
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                  if (!regExp.hasMatch(value!)) {
                    return "이메일 주소가 유효하지 않습니다.";
                  }
                } else if (titleText == "비밀번호 확인") {
                  if (editingcontroller[2].text != value!) {
                    return "비밀번호가 일치하지 않습니다.";
                  } else {
                    return null;
                  }
                }
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              keyboardType:
                  titleText == "이메일 주소" ? TextInputType.emailAddress : null,
              obscureText:
                  titleText == "비밀번호" || titleText == "비밀번호 확인" ? true : false,
              controller: controller,
              onTap: () {
                _scrollController.animateTo(120.0,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
                setState(() {
                  currentField = titleText;
                });
              },
              onChanged: (value) {
                setState(() {});
                if (titleText == "비밀번호") {
                  RegExp regExp = new RegExp(
                      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$');
                  if (!regExp.hasMatch(value)) {
                    setState(() {
                      passwordAlert = "영문/숫자/특수문자(공백 제외) 포함 8~16자를 입력해주세요.";
                      availablePassword = false;
                    });
                  } else {
                    setState(() {
                      passwordAlert = "사용가능한 비밀번호 입니다.";
                      availablePassword = true;
                    });
                  }
                }
              },
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: HexColor("#d5d5d5"),
                  ),
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: HexColor("#d5d5d5"),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.clear();
                    setState(() {});
                  },
                  icon: controller.text.isNotEmpty && currentField == titleText
                      ? SvgPicture.asset(
                          "assets/icons/xmarkIcon_full.svg",
                        )
                      : Container(),
                ),
              ),
            ),
          ),
          titleText == "비밀번호" && passwordAlert != ""
              ? Container(
                  child: Text(
                    passwordAlert,
                    style: TextStyle(
                        color: availablePassword == true
                            ? Colors.green
                            : Colors.red),
                  ),
                )
              : Container(
                  height: 0,
                ),
        ],
      ),
    );
  }
}
