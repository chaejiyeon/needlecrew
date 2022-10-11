import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:needlecrew/getxController/fixClothes/cartController.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/models/billing_info.dart';
import 'package:needlecrew/screens/main/alramInfo.dart';
import 'package:needlecrew/screens/main/cartInfo.dart';
import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/userInfoMenu.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class PayMent extends StatefulWidget {
  final int orderid;

  const PayMent({Key? key, required this.orderid}) : super(key: key);

  @override
  State<PayMent> createState() => _PayMentState();
}

class _PayMentState extends State<PayMent> {
  final HomeController controller = Get.put(HomeController());

  final _carouselcontroller = CarouselController();
  late int currentPage = 0;




  @override
  void initState() {
    super.initState();

    print("payMent card Info" + controller.cardsInfo.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset("assets/icons/prevIcon.svg",
              width: 11, height: 19),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(CartInfo());
            },
            icon: SvgPicture.asset("assets/icons/main/cartIcon.svg",
                width: 23, height: 23, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              Get.to(AlramInfo());
            },
            icon: SvgPicture.asset("assets/icons/main/alramIcon.svg",
                color: Colors.black),
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.getCardAll(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 24),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: FontStyle(
                            text: "결제하기",
                            fontsize: "lg",
                            fontbold: "bold",
                            fontcolor: Colors.black,
                            textdirectionright: false)),
                  ),
                  Container(
                    height: 230,
                    child: CarouselSlider(
                      carouselController: _carouselcontroller,
                      items: List.generate(controller.cardsInfo.length,
                              (index) => cardCutom(controller.cardsInfo![index])),
                      options: CarouselOptions(
                          aspectRatio: 2.0,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentPage = index;
                            });
                          }),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.zero,
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(CupertinoIcons.back, size: 20),
                        Container(
                          child: Row(
                            children: [
                              FontStyle(
                                  text: (currentPage + 1).toString(),
                                  fontsize: "",
                                  fontbold: "",
                                  fontcolor: Colors.black,
                                  textdirectionright: false),
                              FontStyle(
                                  text: "/",
                                  fontsize: "",
                                  fontbold: "",
                                  fontcolor: Colors.black,
                                  textdirectionright: false),
                              FontStyle(
                                  text: controller.cardsInfo.length.toString(),
                                  fontsize: "",
                                  fontbold: "",
                                  fontcolor: Colors.black,
                                  textdirectionright: false),
                            ],
                          ),
                        ),
                        Icon(CupertinoIcons.forward, size: 20),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        top: 39,
                      ),
                      child: FutureBuilder(
                        future: controller.orderInfo(widget.orderid),
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.done){
                            controller.payment['customer_uid'] = controller.cardsInfo[currentPage].customer_uid;
                            controller.payment['merchant_uid'] = "order_no" + controller.orderMap['order_no'];
                            controller.payment['amount'] = controller.orderMap['total_price'];
                            controller.payment['name'] = controller.orderMap['order_item'];

                            return Column(
                              children: [
                                infoList("결제 수단",
                                    controller.cardsInfo[currentPage].card_name, false),
                                infoList("의뢰 내역", controller.orderMap['order_item'], false),
                                infoList(
                                    "의뢰 비용",
                                    controller.setPrice(int.parse(controller.orderMap['order_price'])),
                                    true),
                                infoList(
                                    "택배 비용",
                                    controller.setPrice(int.parse(controller.orderMap['shipp_cost'])),
                                    true),
                                Container(
                                    padding: EdgeInsets.only(left: 24, right: 24),
                                    child: ListLine(
                                        height: 1,
                                        width: double.infinity,
                                        lineColor: HexColor("#ededed"),
                                        opacity: 1)),
                                SizedBox(
                                  height: 14,
                                ),
                                infoList("최종 결제 금액",
                                    controller.setPrice(controller.orderMap['total_price']), true),
                              ],
                            );
                          }else{
                            return Center(child: CircularProgressIndicator(),);
                          }
                        },

                      ),
                    ),
                  ),
                ],
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        },

      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: CircleBlackBtn(
          btnText: "결제하기",
          pageName: "mainHome",
          argument: currentPage,
        ),
      ),
    );
  }

  // card custom 위젯
  Widget cardCutom(CardInfo cardInfo) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          width: 300,
          child: Image.asset(
            "assets/images/card.png",
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          heightFactor: 2,
          child: Container(
            padding: EdgeInsets.only(left: 20),
            child: FontStyle(
                text: cardInfo.card_name,
                fontcolor: Colors.white,
                fontsize: "md",
                fontbold: "",
                textdirectionright: false),
          ),
        ),
        Align(
          widthFactor: 7.0,
          heightFactor: 6,
          alignment: Alignment.bottomRight,
          child: Container(
            child: FontStyle(
                text: cardInfo.card_number.substring(12, 16),
                fontcolor: Colors.white,
                fontbold: "",
                fontsize: "md",
                textdirectionright: false),
          ),
        ),
      ],
    );
  }

  // pay info item
  Widget infoList(String title, String info, bool isCost) {
    return Container(
      padding: EdgeInsets.only(left: 42, right: 42, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FontStyle(
              text: title,
              fontsize: "md",
              fontbold: "bold",
              fontcolor: Colors.black,
              textdirectionright: false),
          isCost == false
              ? FontStyle(
                  text: info,
                  fontsize: "",
                  fontbold: "",
                  fontcolor:
                      title == "의뢰 내역" ? HexColor("#aaaaaa") : Colors.black,
                  textdirectionright: false)
              : Row(
                  children: [
                    FontStyle(
                        text: info,
                        fontsize: "",
                        fontbold: "",
                        fontcolor: title == "최종 결제 금액"
                            ? HexColor("#fd9a03")
                            : Colors.black,
                        textdirectionright: false),
                    Text("원")
                  ],
                ),
        ],
      ),
    );
  }
}
