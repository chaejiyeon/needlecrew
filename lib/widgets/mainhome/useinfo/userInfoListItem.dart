import 'package:needlecrew/bottomsheet/useInfoBottomsheet/fix_cancle_info_sheet.dart';
import 'package:needlecrew/bottomsheet/useInfoBottomsheet/fix_info_sheet.dart';
import 'package:needlecrew/bottomsheet/useInfoBottomsheet/use_info_process_sheet.dart';
import 'package:needlecrew/getxController/useInfo/useInfoController.dart';
import 'package:needlecrew/modal/fixClothes/fixCompleteModal.dart';
import 'package:needlecrew/modal/imageInfo.dart';
import 'package:needlecrew/models/fix_ready.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/widgets/circleLineBtn.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoListItem extends StatefulWidget {
  final FixReady fixReady;
  final String fixState;
  final Future myFuture;
  // final Stream myStream;



  const UserInfoListItem({
    Key? key,
    required this.fixReady,
    required this.fixState,
    required this.myFuture,
    // required this.myStream,
    // required this.myFuture
  }) : super(key: key);

  @override
  State<UserInfoListItem> createState() => _UserInfoListItemState();
}

class _UserInfoListItemState extends State<UserInfoListItem> {
  final UseInfoController controller = Get.put(UseInfoController());

  void bottomsheetOpen(
      BuildContext context, String bottomsheet, int progressNum) {
    if (bottomsheet == "fixinfo" ||
        bottomsheet == "detailInfo" ||
        bottomsheet == "fixProgressInfo" ||
        bottomsheet == "fixCompleteInfo") {
      showStickyFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 0.9,
        maxHeight: 0.9,
        context: context,
        bottomSheetColor: HexColor("#fafafa").withOpacity(0.2),
        decoration: BoxDecoration(
          color: HexColor("#f7f7f7"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(39), topRight: Radius.circular(39)),
        ),
        headerHeight: 59,
        headerBuilder: (context, offset) {
          return bottomsheetHeader(bottomsheet);
        },
        bodyBuilder: (context, offset) {
          return SliverChildListDelegate([
            // Container()
            FixInfoSheet(
              orderId: widget.fixReady.fixId,
              controller: controller,
              fixInfoTitle: bottomsheet,
              readyInfo: widget.fixReady.readyInfo,
            ),
          ]);
        },
      );
    } else if (bottomsheet == "readyInfo") {
      showStickyFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 0.65,
        maxHeight: 0.65,
        context: context,
        bottomSheetColor: HexColor("#fafafa").withOpacity(0.1),
        decoration: BoxDecoration(
          color: HexColor("#f7f7f7"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(39)),
        ),
        headerHeight: 90,
        headerBuilder: (context, offset) {
          return Column(children: [
            Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.topCenter,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(39),
                      topRight: Radius.circular(39)),
                ),
                child: Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50)),
                )),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontStyle(
                        text: "수선 진행 상황",
                        fontsize: "md",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),
                    SizedBox(
                      height: 7,
                    ),
                    ListLine(
                        height: 1,
                        width: double.infinity,
                        lineColor: HexColor("#fd9a03"),
                        opacity: 0.1),
                  ],
                ),
              ),
            ),
          ]);
        },
        bodyBuilder: (context, offset) {
          return SliverChildListDelegate([
            UseInfoProcessSheet(
                progressNum: progressNum, date: widget.fixReady.readyDate),
          ]);
        },
      );
    } else if (bottomsheet == "fixconfirm") {
      showStickyFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 0.9,
        maxHeight: 0.9,
        context: context,
        bottomSheetColor: HexColor("#fafafa").withOpacity(0.1),
        decoration: BoxDecoration(
          color: HexColor("#ffffff"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(39)),
        ),
        headerHeight: 59,
        headerBuilder: (context, offset) {
          return bottomsheetHeader(bottomsheet);
        },
        bodyBuilder: (context, offset) {
          return SliverChildListDelegate([
            FixCancleInfoSheet(
                fixInfoTitle: bottomsheet,
                orderId: widget.fixReady.fixId,
                fixPossible: widget.fixReady.updatePossible,
                controller: controller)
          ]);
        },
      );
    }
  }

  // 본체
  @override
  Widget build(BuildContext context) {
    print("current fix state this " + widget.fixReady.readyInfo.toString());

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
      ),
      child: widget.fixState == "ready"
          ? FixReady()
          : widget.fixState == "progress"
              ? FixProgress()
              : FixComplete(),
    );
  }

  // 수선 대기 widget
  Widget FixReady() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        listTitle(),
        FontStyle(
            text: widget.fixReady.readyInfo == 1
                ? "수선 접수가 완료되었습니다."
                : widget.fixReady.readyInfo == 2
                    ? "의류 수거를 위해 준비중입니다."
                    : widget.fixReady.readyInfo == 3
                        ? "고객님의 의류가 수선사에게 배송중입니다."
                        : widget.fixReady.readyInfo == 4
                            ? "고객님의 의류가 수선사에게 도착했습니다."
                            : widget.fixReady.readyInfo == 5
                                ? "수선사가 고객님의 의류를 확인하고 있습니다."
                                : widget.fixReady.readyInfo == 6
                                    ? "수선내역에서 최종 결제 비용을 확인해주세요!"
                                    : "접수하신 의뢰는 수선이 불가합니다.",
            fontbold: "bold",
            fontsize: "md",
            fontcolor: Colors.black,
            textdirectionright: false),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            useinfoBtn("진행 상황", "readyInfo"),
            useinfoBtn("수선 내역", "detailInfo"),
            widget.fixReady.readyInfo == 6
                ? useinfoBtn("수선 확정", "fixComplete")
                : widget.fixReady.readyInfo == 7
                    ? useinfoBtn("내용 확인", "fixconfirm")
                    : Container(
                        width: 0,
                      ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        listLine(),
      ],
    );
  }

  // 수선 진행중 widget
  Widget FixProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        listTitle(),
        FontStyle(
            text: "고객님의 의류를 수선 중입니다.",
            fontbold: "bold",
            fontsize: "md",
            fontcolor: Colors.black,
            textdirectionright: false),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            useinfoBtn("수선 내역", "fixProgressInfo"),
            useinfoBtn("사진 보기", "fixImageInfo"),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        listLine(),
      ],
    );
  }

  // 수선 완료 widget
  Widget FixComplete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        listTitle(),
        FontStyle(
            text: widget.fixReady.readyInfo == 1
                ? "수선이 완료되었습니다."
                : widget.fixReady.readyInfo == 2
                    ? "고객님의 수령지로 의류를 발송하였습니다."
                    : "수선 완료",
            fontbold: "bold",
            fontsize: "md",
            fontcolor: Colors.black,
            textdirectionright: false),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            useinfoBtn("수선 내역", "fixCompleteInfo"),
            widget.fixReady.readyInfo == 1
                ? useinfoBtn("사진 보기", "shippingInfo")
                : widget.fixReady.readyInfo == 2
                    ? useinfoBtn("배송 조회", "shippingInfo")
                    : Container(
                        height: 0,
                      )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        listLine(),
      ],
    );
  }

  //  <공통 위젯>
  // 날짜 및 수선 타입
  Widget listTitle() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          FontStyle(
              text: widget.fixReady.fixDate,
              fontcolor: HexColor("#909090"),
              fontsize: "",
              fontbold: "",
              textdirectionright: false),
          FontStyle(
              text: " / ",
              fontbold: "",
              fontsize: "",
              fontcolor: HexColor("#909090"),
              textdirectionright: false),
          FontStyle(
              text: widget.fixReady.fixType,
              fontbold: "",
              fontsize: "",
              fontcolor: HexColor("#909090"),
              textdirectionright: false),
        ],
      ),
    );
  }

  // list 구별 선
  Widget listLine() {
    return Container(
      height: 2,
      width: double.infinity,
      decoration: BoxDecoration(color: HexColor("#fd9a03").withOpacity(0.1)),
    );
  }

  // bottomsheet 연결 버튼
  Widget useinfoBtn(String text, String bottomsheet) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 87,
      height: 36,
      decoration: BoxDecoration(
        color: text == "수선 확정" ||
                text == "사진 보기" ||
                text == "내용 확인" ||
                text == "배송 조회"
            ? HexColor("#fd9a03")
            : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          width: 1,
          color: text == "수선 확정" ||
                  text == "사진 보기" ||
                  text == "내용 확인" ||
                  text == "배송 조회"
              ? HexColor("#fd9a03")
              : HexColor("#d5d5d5"),
        ),
      ),
      child: TextButton(
        onPressed: () {
          if (text == "수선 확정") {
            Get.dialog(FixCompleteModal(
              orderid: widget.fixReady.fixId,
              controller: controller,
            ));
          }
          if (text == "사진 보기") {
            Get.dialog(ImageInfoModal());
          }
          bottomsheetOpen(context, bottomsheet, widget.fixReady.readyInfo);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: text == "수선 확정" ||
                        text == "사진 보기" ||
                        text == "내용 확인" ||
                        text == "배송 조회"
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 수선 내역 bottomsheetHeader
  Widget bottomsheetHeader(String bottomsheet) {
    return Container(
      height: 59,
      decoration: BoxDecoration(
        color: bottomsheet == "fixconfirm"
            ? HexColor("#ffffff")
            : HexColor("#f7f7f7"),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
          left: 45,
          top: 25,
          right: bottomsheet == "fixconfirm" ? 45 : 24,
          bottom: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FontStyle(
              text: bottomsheet == "fixconfirm" ? "수선 불가 사유 안내" : "수선 내역",
              fontsize: "md",
              fontbold: "bold",
              fontcolor: Colors.black,
              textdirectionright: false),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset(
              "assets/icons/xmarkIcon_full_acolor.svg",
              width: 24,
              height: 24,
            ),
          )
        ],
      ),
    );
  }
}
