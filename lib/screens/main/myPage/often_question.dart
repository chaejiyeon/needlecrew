import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';

class OftenQuestion extends StatefulWidget {
  const OftenQuestion({Key? key}) : super(key: key);

  @override
  State<OftenQuestion> createState() => _OftenQuestionState();
}

class _OftenQuestionState extends State<OftenQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: '자주하는 질문',
        leadingWidget: BackBtn(),
      ),
    );
  }
}
