import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/controller/fix_clothes/cart_controller.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/fixClothes/take_fix_info.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/progress_bar.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

class TakeFixDate extends StatefulWidget {
  const TakeFixDate({Key? key}) : super(key: key);

  @override
  State<TakeFixDate> createState() => _TakeFixDateState();
}

class _TakeFixDateState extends State<TakeFixDate> {
  final CartController controller = Get.find();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int nowYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    printInfo(
        info:
            'register order length this - 수거 날짜 ${controller.registerOrders.length}');
    return Scaffold(
      appBar: CustomAppbar(
        leadingWidget: BackBtn(),
        appbarcolor: 'white',
        appbar: AppBar(),
        actionItems: [
          AppbarItem(
            icon: 'homeIcon.svg',
            iconColor: Colors.black,
            iconFilename: 'main',
            widget: MainPage(pageNum: 0),
          ),
          AppbarItem(
            icon: 'cartIcon.svg',
            iconColor: Colors.black,
            iconFilename: 'main',
            widget: CartInfo(),
          ),
          AppbarItem(
            icon: 'alramIcon.svg',
            iconColor: Colors.black,
            iconFilename: 'main',
            widget: AlramInfo(),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: ProgressBar(progressImg: "fixProgressbar_4.svg")),
            Container(
              padding: EdgeInsets.only(left: 24, right: 24),
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
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: SingleChildScrollView(
                  child: TableCalendar(
                    locale: 'ko-KR',
                    daysOfWeekHeight: 30,
                    focusedDay: _focusedDay,
                    firstDay: DateTime.now(),
                    lastDay: DateTime(nowYear, 12, 31),
                    calendarBuilders: CalendarBuilders(
                      todayBuilder: (context, month, day) {
                        return Stack(
                          children: [
                            Positioned(
                              top: 13,
                              right: 13,
                              child: Container(
                                height: 6,
                                width: 6,
                                decoration: BoxDecoration(
                                  color: HexColor("#fd9a03"),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(DateTime.now().day.toString()),
                            ),
                          ],
                        );
                      },
                      defaultBuilder: (context, startDay, endDay) {
                        String dayOfWeeks =
                            DateFormat('E', 'ko_KR').format(startDay);

                        if (dayOfWeeks == '일') {
                          return Container(
                            child: Center(
                              child: Text(startDay.day.toString(),
                                  style: TextStyle(color: Colors.red)),
                            ),
                          );
                        }
                      },
                      holidayBuilder: (context, startDay, endDay) {
                        String dayOfWeeks = startDay.day.toString();

                        return Container(
                          child: Center(
                            child: Text(dayOfWeeks,
                                style: TextStyle(color: Colors.red)),
                          ),
                        );
                      },
                      dowBuilder: (context, day) {
                        String dayOfWeeks =
                            DateFormat('E', 'ko_KR').format(day);

                        if (day.weekday == DateTime.sunday) {
                          return Container(
                            child: Center(
                              child: Text(dayOfWeeks,
                                  style: TextStyle(color: Colors.red)),
                            ),
                          );
                        }

                        return Container(
                          child: Center(
                              child: Text(dayOfWeeks,
                                  style: TextStyle(color: Colors.black))),
                        );
                      },
                    ),
                    holidayPredicate: (day) {
                      return utilsService.isHoliday(day);
                    },
                    // currentDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: ((selectedDay, focusedDay) {
                      String dayOfWeeks =
                          DateFormat('E', 'ko_KR').format(selectedDay);

                      if (!isSameDay(_selectedDay, selectedDay)) {
                        if (dayOfWeeks == "일" ||
                            utilsService.isHoliday(selectedDay)) {
                          Get.snackbar('수거 불가',
                              '일요일 및 공휴일은 수거가 불가하며, 토요일 선택시 월요일로 수거가 넘어갈 수 있습니다.');
                        } else {
                          setState(() {
                            printInfo(
                                info: 'select day this ${selectedDay.month}');
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        }
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
                      markerDecoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(50)
                          ),
                    ),
                    headerStyle: HeaderStyle(
                      rightChevronIcon:
                          SvgPicture.asset("assets/icons/nextIcon.svg"),
                      leftChevronIcon:
                          SvgPicture.asset("assets/icons/prevIcon.svg"),
                      leftChevronPadding: EdgeInsets.zero,
                      rightChevronPadding: EdgeInsets.zero,
                      headerMargin: EdgeInsets.only(bottom: 20),
                      titleCentered: true,
                      formatButtonVisible: false,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: HexColor("#ededed"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationbar(),
    );
  }

  // bottm Info
  Widget _bottomNavigationbar() {
    String selectYear = _focusedDay.year.toString();
    String selectMonth = _focusedDay.month.toString();
    String selectDay = _focusedDay.day.toString();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 24, right: 24),
      margin: EdgeInsets.only(bottom: 5),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: EasyRichText(
                    "수거 희망일 : " + selectMonth + "월 " + selectDay + "일",
                    defaultStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'NotoSansCJKkrRegular',
                        color: Colors.black),
                    patternList: [
                      EasyRichTextPattern(
                        targetString: selectMonth + "월 " + selectDay + "일",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "* ",
                          style: TextStyle(
                            fontSize: 14,
                            color: HexColor("#a5a5a5"),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "일요일 및 공휴일은 수거가 불가하며, 토요일 선택시 월요일로 수거가 넘어갈 수 있습니다.",
                            style: TextStyle(
                              fontSize: 14,
                              color: HexColor("#a5a5a5"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                controller.fixDate(selectYear, selectMonth, selectDay);
                Get.to(() => TakeFixInfo());
              },
              child: Image.asset(
                "assets/icons/selectFloatingIcon.png",
                width: 54,
                height: 54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
