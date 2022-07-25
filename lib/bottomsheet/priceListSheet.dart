import 'package:needlecrew/widgets/mainhome/priceInfo/tableListItem.dart';
import 'package:flutter/material.dart';

class PriceListSheet extends StatefulWidget {
  const PriceListSheet({Key? key}) : super(key: key);

  @override
  State<PriceListSheet> createState() => _PriceListSheetState();
}

class _PriceListSheetState extends State<PriceListSheet> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      padding: EdgeInsets.zero,
      controller: scrollController,
      shrinkWrap: true,
      children: [
            TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
            TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
            TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
            TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
            TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
            TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
            TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
            TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),

      ],
    ));
  }
}
