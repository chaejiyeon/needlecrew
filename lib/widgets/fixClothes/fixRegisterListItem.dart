import 'package:needlecrew/widgets/fixClothes/fixtypeRegisterListItem.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../getxController/fixClothes/cartController.dart';

class FixRegisterListItem extends StatefulWidget {
  final int index;
  final List<LineItems> lineItem;
  const FixRegisterListItem({Key? key, required this.lineItem, required this.index}) : super(key: key);

  @override
  State<FixRegisterListItem> createState() => _FixRegisterListItemState();
}

class _FixRegisterListItemState extends State<FixRegisterListItem> {
  final CartController controller = Get.put(CartController());


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.wholePrice.value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Obx((){
      if(controller.isInitialized.value){
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          margin: EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "일반바지",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ListLine(
                  height: 2,
                  width: double.infinity,
                  lineColor: HexColor("#909090"),
                  opacity: 0.2),
              // Obx(() {
              //   if(controller.isInitialized.value){
              //     for(int i=0; i<controller.orders.length; i++){
              //       if(controller.orders[i].shipping!.address1 != ""){
              //       }
              //     }
              //     return Container();
              //   }else{
              //     return Container();
              //   }
              // }),
              Column(
                children: List.generate(widget.lineItem.length, (index) =>
                    FixTypeRegisterListItem(
                      item: widget.lineItem[index], index: widget.index,)),
                // children: [
                //   FixTypeRegisterListItem(),
                // ],
              ),
            ],
          ),
        );
      }else{
        return Center(child: CircularProgressIndicator(),);
      }
    });
    //   Container(
    //   padding: EdgeInsets.only(left: 20, right: 20, top: 15),
    //   margin: EdgeInsets.only(bottom: 25),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     shape: BoxShape.rectangle,
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   child: Column(
    //     children: [
    //       Container(
    //         alignment: Alignment.centerLeft,
    //         child: Text(
    //           "일반바지",
    //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 5,
    //       ),
    //       ListLine(
    //           height: 2,
    //           width: double.infinity,
    //           lineColor: HexColor("#909090"),
    //           opacity: 0.2),
    //       // Obx(() {
    //       //   if(controller.isInitialized.value){
    //       //     for(int i=0; i<controller.orders.length; i++){
    //       //       if(controller.orders[i].shipping!.address1 != ""){
    //       //       }
    //       //     }
    //       //     return Container();
    //       //   }else{
    //       //     return Container();
    //       //   }
    //       // }),
    //       Column(
    //         children: List.generate(widget.lineItem.length, (index) =>
    //             FixTypeRegisterListItem(
    //               item: widget.lineItem[index], index: widget.index,)),
    //         // children: [
    //         //   FixTypeRegisterListItem(),
    //         // ],
    //       ),
    //     ],
    //   ),
    // );
    //   return controller.orders[widget.index].shipping!.address1 != "" ? Container(
    //     padding: EdgeInsets.only(left: 20, right: 20,top: 15),
    //     margin: EdgeInsets.only(bottom: 25),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       shape: BoxShape.rectangle,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Column(
    //       children: [
    //         Container(
    //           alignment: Alignment.centerLeft,
    //           child: Text(
    //             "일반바지",
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //           ),
    //         ),
    //         SizedBox(
    //           height: 5,
    //         ),
    //         ListLine(
    //             height: 2,
    //             width: double.infinity,
    //             lineColor: HexColor("#909090"),
    //             opacity: 0.2),
    //         // Obx(() {
    //         //   if(controller.isInitialized.value){
    //         //     for(int i=0; i<controller.orders.length; i++){
    //         //       if(controller.orders[i].shipping!.address1 != ""){
    //         //       }
    //         //     }
    //         //     return Container();
    //         //   }else{
    //         //     return Container();
    //         //   }
    //         // }),
    //         Column(
    //           children: List.generate(widget.lineItem.length, (index) => FixTypeRegisterListItem(item: widget.lineItem[index],index: widget.index,)),
    //           // children: [
    //           //   FixTypeRegisterListItem(),
    //           // ],
    //         ),
    //       ],
    //     ),
    //   ) : Container() ;
  }
}
