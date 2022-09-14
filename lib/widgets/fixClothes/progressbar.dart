import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressBar extends StatelessWidget {
  final String progressImg;
  const ProgressBar({Key? key, required this.progressImg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: SvgPicture.asset(
        "assets/icons/fixClothes/" + progressImg,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
