import 'package:needlecrew/screens/main/fixClothes/takeFixInfo.dart';
import 'package:needlecrew/widgets/fixClothes/fixClothesAppbar.dart';
import 'package:needlecrew/widgets/fixClothes/progressbar.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../getxController/fixClothes/cartController.dart';

class TakeFixDate extends StatefulWidget {
  const TakeFixDate({Key? key}) : super(key: key);

  @override
  State<TakeFixDate> createState() => _TakeFixDateState();
}

class _TakeFixDateState extends State<TakeFixDate> {
  final CartController controller = Get.put(CartController());

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int nowYear = DateTime.now().year;

  @override
  void initState(){
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FixClothesAppBar(appbar: AppBar()),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBar(progressImg: "fixProgressbar_4.svg"),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontStyle(
                      text: "수거 희망일",
                      fontsize: "lg",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  FontStyle(
                      text: "의류 수거를 위해 수거 희망일을 선택해주세요.",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black.withOpacity(0.7),
                      textdirectionright: false),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(

                child: TableCalendar(
                  locale: 'ko-KR',
                  daysOfWeekHeight: 30,
                  focusedDay: _focusedDay,
                  firstDay: DateTime.now(),
                  lastDay: DateTime(nowYear, 12, 31),
                  // currentDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: ((selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  }),
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: HexColor("#fd9a03"),
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: HexColor("#fd9a03"),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: HexColor("#d5d5d5"),
                      )))),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNabigationbar(),
    );
  }

  // bottm Info
  Widget _bottomNabigationbar() {
    String selectMonth = _focusedDay.month.toString();
    String selectDay = _focusedDay.day.toString();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FontStyle(
                      text: "수거 희망일 : ",
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  FontStyle(
                      text: selectMonth + "월" + selectDay + "일",
                      fontsize: "",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                ],
              ),
              FontStyle(
                  text: "* 주말 및 공휴일은 수거가 불가능 합니다.",
                  fontsize: "",
                  fontbold: "",
                  fontcolor: HexColor("#d5d5d5"),
                  textdirectionright: false)
            ],
          ),
          GestureDetector(
            onTap: (){
              Get.to(TakeFixInfo());
              controller.fixDate(selectMonth, selectDay);
            },
            child: SvgPicture.asset("assets/icons/floatingNext.svg"),
          ),
        ],
      ),
    );
  }
}
