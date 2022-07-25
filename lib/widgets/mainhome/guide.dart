import 'package:needlecrew/models/guideItem.dart';
import 'package:flutter/material.dart';

import 'guidItemList.dart';

class Guide extends StatelessWidget {
  const Guide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(guides.length, (index) => GuideItemList(items: guides[index],),),
      ),
    );
  }
}
