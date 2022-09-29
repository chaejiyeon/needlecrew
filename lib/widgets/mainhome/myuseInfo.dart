import 'package:needlecrew/getxController/fixClothes/cartController.dart';
import 'package:needlecrew/getxController/useInfo/useInfoController.dart';
import 'package:needlecrew/screens/main/fixClothes.dart';
import 'package:needlecrew/screens/main/useInfo.dart';
import 'package:needlecrew/screens/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MyUseInfo extends StatefulWidget {
  final Stream myStream;
  const MyUseInfo({Key? key, required this.myStream}) : super(key: key);

  @override
  State<MyUseInfo> createState() => _MyUseInfoState();
}

class _MyUseInfoState extends State<MyUseInfo> {
  final UseInfoController controller = Get.put(UseInfoController());


  @override
  void initState(){

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 25, bottom: 53),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FontStyle(
              text: "나의 이용내역",
              fontsize: "md",
              fontbold: "bold",
              fontcolor: Colors.black,
              textdirectionright: false),
          SizedBox(
            height: 34,
          ),
          StreamBuilder(
              stream: widget.myStream,
              builder: (context, snapshot) {
                bool isLoading = snapshot.connectionState == ConnectionState.waiting;

                return isLoading ? countSkeleton() :  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    iconInfo(
                        "assets/icons/main/writeIcon.svg",
                        controller.readyLists.length,
                        "대기 중",
                        "/useInfoReady"),
                    iconInfo(
                        "assets/icons/main/chartIcon.svg",
                        controller.progressLists.length,
                        "진행 중",
                        "/useInfoProgress"),
                    iconInfo(
                        "assets/icons/main/clothesIcon.svg",
                        controller.completeLists.length,
                        "수선 완료",
                        "/useInfoComplete"),
                  ],
                );

              })
        ],
      ),
    );
  }

  // 이용 내역 아이콘 버튼
  Widget iconInfo(String img, int count, String comment, String widget) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(widget);
      },
      child: Container(
        child: Column(
          children: [
            SvgPicture.asset(img),
            SizedBox(
              height: 14,
            ),
            Text(count.toString() + "건"),
            SizedBox(
              height: 3,
            ),
            Text(comment),
          ],
        ),
      ),
    );
  }

  Widget countSkeleton() {
    return Shimmer.fromColors(
      baseColor: Color.fromRGBO(240, 240, 240, 1),
      highlightColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          skeletonItem(),
          skeletonItem(),
          skeletonItem(),
        ],
      )
    );
  }

  Widget skeletonItem(){
    return Container(
      child: Column(
        children: [
          Container(width: 48,height: 48,color: Colors.grey,),
          SizedBox(height: 14,),
          Container(width: 23,height: 21,color: Colors.grey,),
          SizedBox(height: 3,),
          Container(width: 41,height: 20,color: Colors.grey,),
        ],
      ),
    );
  }
}
