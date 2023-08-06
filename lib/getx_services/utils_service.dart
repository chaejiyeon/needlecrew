import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:needlecrew/format_method.dart';

class UtilsService extends GetxService {
  // 공휴일 목록
  RxList holidays = <DateTime>[].obs;

  // 공휴일 정보가져오기
  Future getHolidays() async {
    for (int i = 1; i < 13; i++) {
      http.Response response = await http.get(Uri.parse(
          'http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getHoliDeInfo?_type=json&solYear=${DateTime.now().year}&solMonth=${i < 10 ? '0$i' : i}&ServiceKey=9WoNhppA%2BmBPSiTp4pl8rVT1FtuyLSMJqVhKZOF19SeXxIKZO4L5QIvZfb6Lvi6r4xkYFXhlYYq5RWDcncCjCQ%3D%3D'));

      log('get holidays this ${response.body}');

      Map result = jsonDecode(response.body);

      result.forEach((key, value) {
        log('get holiday info key $key value $value');
        Map bodyInfo = value;
        log('get holiday info body this ${bodyInfo['body']}');
        bodyInfo['body'].forEach((key, value) {
          log('0. get holiday info body this ${value}');
          if (key == 'items') {
            log('1. get holiday info body this ${value.runtimeType}');
            if (value.runtimeType != String) {
              log('2. get holiday info body this ${value['item'].runtimeType}');
              if (value['item'].runtimeType != List) {
                if (value['item']['isHoliday'] == 'Y') {
                  DateTime convertDate = FormatMethod()
                      .convertStringToDate(value['item']['locdate'].toString());
                  holidays.add(convertDate);
                }
              } else {
                for (Map item in value['item']) {
                  if (item['isHoliday'] == 'Y') {
                    DateTime convertDate = FormatMethod()
                        .convertStringToDate(item['locdate'].toString());
                    var result = FormatMethod()
                        .convertStringToDate(item['locdate'].toString());
                    holidays.add(convertDate);
                    log('3. get holiday info body this ${result.runtimeType}');
                  }
                }
              }
            }
          }
        });
      });
    }
  }

  /// holiday check
  isHoliday(DateTime selectDay) {
    log('is holiday ${holidays.first.runtimeType}');
    log('1. is holiday ${holidays.indexWhere((element) => element.year == selectDay.year && element.month == selectDay.month && element.day == selectDay.day)}');
    if (holidays.indexWhere((element) =>
            element.year == selectDay.year &&
            element.month == selectDay.month &&
            element.day == selectDay.day) !=
        -1) {
      log('2. is holiday ${holidays.indexWhere((element) => element.millisecondsSinceEpoch == selectDay.millisecondsSinceEpoch)}');
      return true;
    } else {
      return false;
    }
  }
}
