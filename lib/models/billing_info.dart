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
  final dynamic customer_uid;
  final dynamic customer_name;
  final dynamic customer_email;
  final dynamic card_name;
  final dynamic card_number;

  CardInfo({
    required this.customer_uid,
    required this.customer_name,
    required this.customer_email,
    required this.card_name,
    required this.card_number,
  });

  factory CardInfo.fromJson(Map json) {
    return CardInfo(
        customer_uid: json['customer_uid'],
        customer_name: json["customer_name"],
        customer_email: json["customer_email"],
        card_name: json["card_name"],
        card_number: json["card_number"],);
  }
}
