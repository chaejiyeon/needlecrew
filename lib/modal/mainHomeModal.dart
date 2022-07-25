import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:needlecrew/getxController/fixClothes/cartController.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/screens/main/fixClothes.dart';
import 'package:needlecrew/widgets/fixClothes/startAddressChoose.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/widgets/circleLineBtn.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;

class MainHomeModal extends StatefulWidget {

  const MainHomeModal({Key? key,}) : super(key: key);

  @override
  State<MainHomeModal> createState() => _MainHomeModalState();
}

class _MainHomeModalState extends State<MainHomeModal> {
  late Future getName;

  String? name = "";




  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsername();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUsername() async {
    name = await wp_api.storage.read(key: 'username');
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());


    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.only(top: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
                controller.isMainmodal(true);
              },
              child: Icon(
                CupertinoIcons.xmark_circle,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(
              height: 30,
            ),

            FutureBuilder(
                future: getUsername(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    print("getusername this     " + name!);
                    return FontStyle(
                        text: "반가워요, " + name! + "님!",
                        fontsize: "lg",
                        fontbold: "bold",
                        fontcolor: Colors.white,
                        textdirectionright: false);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),

            FontStyle(
                text: "지금 바로 니들크루 수선의뢰를",
                fontsize: "md",
                fontbold: "",
                fontcolor: Colors.white,
                textdirectionright: false),
            FontStyle(
                text: "이용해 보시겠어요?",
                fontsize: "md",
                fontbold: "",
                fontcolor: Colors.white,
                textdirectionright: false),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleLineBtn(
                    btnText: "이용하기",
                    fontboxwidth: 100,
                    bordercolor: Colors.white,
                    fontcolor: Colors.white,
                    fontsize: "",
                    btnIcon: "",
                    btnColor: Colors.transparent,
                    widgetName: FixClothes(),
                    fontboxheight: "",
                    iswidget: true,
                  ),
                  Expanded(
                      child: SvgPicture.asset("assets/images/mainInfo.svg", width: 185, height: 185,)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
