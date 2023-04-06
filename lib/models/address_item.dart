class AddressItem{
  final int sort; // 0 : 우리집 / 1 : 회사 / 2 : 기타
  final String addressType; // api 요청 값  ex) default_address
  final String address;

  AddressItem(this.sort, this.addressType, this.address);
}