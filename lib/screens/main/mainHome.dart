import 'package:get/get.dart';
import 'package:needlecrew/getxController/useInfo/useInfoController.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/mainhome/bannerslide.dart';
import 'package:needlecrew/widgets/mainhome/footer.dart';
import 'package:needlecrew/widgets/mainhome/guide.dart';
import 'package:needlecrew/widgets/mainhome/mainHomeAppbar.dart';
import 'package:needlecrew/widgets/mainhome/myuseInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome>
    with SingleTickerProviderStateMixin {
  final UseInfoController useInfoController = Get.put(UseInfoController());


  // late Stream myStream;
  late Future myFuture;
  // bool _showAppbar = true;
  ScrollController _scrollController = new ScrollController();
  bool isScrollingDown = false;

  late Color color = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      print("scorll position  " + _scrollController.position.pixels.toString());
      if (_scrollController.position.pixels >= 15) {
        setState((){
          color = Colors.white;
        });
      }else{
        setState((){
          color = Colors.transparent;
        });
      }
      // setState((){});
    });

    // myStream = useInfoController.getCompleteOrder();
    myFuture = useInfoController.getCompleteOrder();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar:  MainHomeAppBar(
              appbar: AppBar(),
              color: color,
            ),
      body: ListView(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        children: [
          BannerSlides(),
          MyUseInfo(
            myFuture: myFuture,
          ),
          Container(
            padding: EdgeInsets.only(left: 24, bottom: 10),
            child: FontStyle(
                text: "니들크루 가이드",
                fontsize: "md",
                fontbold: "bold",
                fontcolor: Colors.black,
                textdirectionright: false),
          ),
          Guide(),
          Footer(),
        ],
      ),
    );
  }
}
