import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';

class OftenQuestion extends StatefulWidget {
  const OftenQuestion({Key? key}) : super(key: key);

  @override
  State<OftenQuestion> createState() => _OftenQuestionState();
}

class _OftenQuestionState extends State<OftenQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MypageAppBar(title: "자주하는 질문", icon: "",appbar: AppBar(), widget: widget),
    );
  }
}
