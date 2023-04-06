class GetUser {
  late dynamic loginToken;
  late dynamic userName;
  late dynamic phoneNumber;
  late dynamic address;
  late dynamic defaultCard;

  GetUser({
    this.loginToken = '',
    this.userName = '',
    this.phoneNumber = '',
    this.address,
    this.defaultCard = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'login_token': loginToken,
      'user_name': userName,
      'phone_number': phoneNumber,
      'default_address': address,
      'card': defaultCard,
    };
  }
}
