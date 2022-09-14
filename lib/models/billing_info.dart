
// billing 정보 가져오기
class BillingInfo {
  final dynamic code;
  final dynamic message;
  final dynamic response;

  BillingInfo(
      {required this.code, required this.message, required this.response});

  factory BillingInfo.fromJson(Map json) {
    return BillingInfo(
        code: json["code"],
        message: json["message"],
        response: json["response"]);
  }
}


// billing에서 response 분리
class CardInfo {
  final dynamic card_number;
  final dynamic expiry;
  final dynamic birth;
  final dynamic pwd_2digit;

  CardInfo(
      {required this.card_number,
      required this.expiry,
      required this.birth,
      required this.pwd_2digit});

  factory CardInfo.fromJson(Map json) {
    return CardInfo(
        card_number: json["card_number"],
        expiry: json["expiry"],
        birth: json["birth"],
        pwd_2digit: json["pwd_2digit"]);
  }
}
