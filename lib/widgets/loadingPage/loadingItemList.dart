import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';

class LoadingItem extends StatelessWidget {
  final String img;
  final String text1;
  final String text2;

  const LoadingItem(
      {Key? key, required this.img, required this.text1, required this.text2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(height: 308, child: Image.asset(img)),
          Column(
            children: [
              textCustom(text1),
              textCustom(text2),
            ],
          ),
        ],
      ),
    );
  }

  // text 설정
  Widget textCustom(String text){
    return Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
  }
}
