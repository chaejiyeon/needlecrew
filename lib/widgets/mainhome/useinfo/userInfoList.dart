import 'package:needlecrew/getxController/useInfo/useInfoController.dart';
import 'package:needlecrew/models/fix_ready.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:needlecrew/widgets/mainhome/useinfo/userInfoListItem.dart';
import 'package:shimmer/shimmer.dart';

final List<String> fixState = ['ready', 'progress', 'complete'];

class UseInfoList extends StatefulWidget {
  final String fixState;
  final List<FixReady> fixItems;
  final Stream myStream;

  const UseInfoList(
      {Key? key,
      required this.fixState,
      required this.fixItems,
      required this.myStream})
      : super(key: key);

  @override
  State<UseInfoList> createState() => _UseInfoListState();
}

class _UseInfoListState extends State<UseInfoList> {
  final UseInfoController controller = Get.put(UseInfoController());

  int skeletonCount = 0;

  //
  // @override
  // void didUpdateWidget(UseInfoList oldWidget){
  //   super.didUpdateWidget(oldWidget);
  //   print("didUpdateWidget init!!!!!!");
  //   if(fixState == "progress" && oldWidget.myStream != widget.myStream){
  //     controller.widgetUpdate.value = true;
  //
  //     print("didUpdateWidget " + controller.widgetUpdate.value.toString());
  //   }
  // }

  List<FixReady> useInfos = [];



  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child:
      widget.fixItems.length > 0
          ? ListView(
              padding: EdgeInsets.zero,
              children: List.generate(
                widget.fixItems.length,
                (index) => UserInfoListItem(
                  fixReady: widget.fixItems[index],
                  fixState: widget.fixState,
                  myStream: widget.myStream,
                ),
              ),
            )
          : EmptyFix(),
      // widget.fixItems.length > 0
      //     ? ListView(
      //         padding: EdgeInsets.zero,
      //         children: List.generate(
      //           widget.fixItems.length,
      //           (index) => UserInfoListItem(
      //             fixReady: widget.fixItems[index],
      //             fixState: widget.fixState,
      //             myStream: widget.myStream,
      //           ),
      //         ),
      //       )
      //     : EmptyFix(),
    );
  }

  // fix List 목록이 없을 경우
  Widget EmptyFix() {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 50),
      child: FontStyle(
          text: widget.fixState == "ready"
              ? "대기 중인 의뢰가 없습니다."
              : widget.fixState == "progress"
                  ? "진행 중인 의뢰가 없습니다."
                  : "수선 목록이 없습니다.",
          fontcolor: Colors.black,
          fontsize: "md",
          fontbold: "",
          textdirectionright: false),
    );
  }

  Widget countSkeleton() {
    return StreamBuilder(
        stream: widget.myStream,
        builder: (context, snapshot) {
          return Shimmer.fromColors(
            baseColor: Color.fromRGBO(240, 240, 240, 1),
            highlightColor: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: List.generate(5, (index) => skeletonItem()),
            ),
          );
        });
  }

  Widget skeletonItem() {
    return Container(
      padding: EdgeInsets.only(left: 24, top: 10, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5),
            width: 195,
            height: 20,
            color: Colors.grey,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 3),
            margin: EdgeInsets.only(top: 5),
            width: 152,
            height: 24,
            color: Colors.grey,
          ),
          SizedBox(
            height: 3,
          ),
          Container(
            width: 87,
            height: 36,
            color: Colors.grey,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            height: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
