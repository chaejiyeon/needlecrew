import 'dart:math';

import 'package:html/parser.dart';
import 'package:intl/intl.dart';

class FormatMethod {
  /// 날짜 변경
  String convertDate(int date, String convertType) {
    var convert = DateTime.fromMillisecondsSinceEpoch(date!);
    return DateFormat(convertType).format(convert);
  }

  /// convert string to timestamp
  convertStringToDate(String date) {
    var convert = DateTime.parse(date);
    return convert;
  }

  /// price 표기
  convertPrice({int? price, String type = '###,###,###'}) {
    var convert = NumberFormat(type).format(price);
    return convert;
  }

  /// convert html text to text
  convertHtmlToText(String htmlText) {
    var cvtText = '';
    var document = parse(htmlText);
    cvtText = parse(document.body!.text).documentElement!.text;
    return cvtText;
  }

  /// option name
  convertOptionName(String optionName) {
    var name = '';
    List nameList = optionName.split('-');

    for (int i = 0; i < nameList.length; i++) {
      name += nameList[i] + ' ';
    }
    return name;
  }

  /// primary orderNo
  setId(){
    const chars = 'ABCDEFGHIJKLMNPQRSTUVWXYZ123456789';
    Random rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

    var primaryId = getRandomString(5);

    return primaryId;
  }

  /// 날짜 변환 - 나의 이용내역 title 날짜
  Map convertedUseInfoDate(String pattern, String date) {
    Map dateInfo = {
      'date': '',
      'day': '',
    };

    DateTime dateTime = DateTime.parse(date);
    String registerDate = DateFormat(pattern).format(dateTime);
    String day = DateFormat.E('ko_KR').format(dateTime);



    dateInfo['date'] = registerDate;
    dateInfo['day'] = day;
    return dateInfo;
  }
}
