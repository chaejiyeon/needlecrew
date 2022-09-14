
// Token 정보 가져오기
class GetToken{
  final dynamic access_token;

  GetToken({required this.access_token});

  factory GetToken.fromJson(Map json){
    return GetToken(access_token: json["access_token"]);
  }
}


// response 에서 토큰 분리
class Token{
  final dynamic response;

  Token({required this.response});

  factory Token.fromJson(Map json){
    return Token(response: json["response"]);
  }
}