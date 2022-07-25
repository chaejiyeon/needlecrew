class UseGuideShoppingItem{
  final List listitem;
  final bool isstapInfo; // true : liststepInfo widget , false : liststep widget

  UseGuideShoppingItem(this.listitem, this.isstapInfo);
}

List<UseGuideShoppingItem> shoppingitems = [
  UseGuideShoppingItem([" 쇼핑몰에서 배송지 란에 수선소의 주소를 입력해주세요."], false),
  UseGuideShoppingItem([" 쇼핑몰에서 결제를 완료한 뒤, 옷의 품목명이 나오도록 주문완료 페이지를 캡쳐해 주세요.","쇼핑몰 사이트에서 정확한 옷의 이미지와 품목명이 나오도록 사진을 찍어 업로드 해주세요."], true),
  UseGuideShoppingItem([" 니들크루로 접속해 의류 출발지 선택에서 '쇼핑몰에서 보내요'를 선택해주세요."], false),
  UseGuideShoppingItem([" 쇼핑몰에서 캡처한 주문완료 페이지를 업로드해주세요."], false),
  UseGuideShoppingItem([" 수선할 옷 종류와 수선 항목을 선택해주세요.","쇼핑몰에서 수선소로 보내는 수선은 바지 기장 줄임 수선만 지원합니다."], true),
  UseGuideShoppingItem(["치수를 입력해주세요."], false),
  UseGuideShoppingItem(["추가로 요청할 사항을 기입해주세요."], false),
  UseGuideShoppingItem(["예상 비용을 확인한 후, 결제 정보를 입력하면 수선 접수가 완료됩니다."], false),
];

List<UseGuideShoppingItem> homeitems = [
  UseGuideShoppingItem([" 의류 출발지 선택에서 '우리집에서 보내요'를 선택해주세요."], false),
  UseGuideShoppingItem([" 수선할 옷 종류와 수선 항목을 선택해 주세요.", "원하는 항목이 없을 경우 직접 입력을 선택해주세요."], true),
  UseGuideShoppingItem([" 수선 치수를 표시할 방법을 선택하고, 가이드에 따라 진행해주세요.", "치수 입력 / 직접 표시 / 견본 의류 동봉 등", "내 치수를 입력해 두면 '내치수 불러오기'를 통해 매번 수선 사이즈를 입력하지 않아도 됩니다."], true),
  UseGuideShoppingItem([" 추가로 요청할 사항을 기입해 주세요."], false),
  UseGuideShoppingItem([" 수선 맡기실 옷의 이미지를 업로드해 주세요."], false),
  UseGuideShoppingItem([" 추가로 수선할 옷이 있다면 '다른 의류도 함께 맡기기'를 선택하고 신청 과정을 반복하시면 됩니다."], false),
  UseGuideShoppingItem([" 의류 수거를 위해 주소와 수거 희망일을 선택해 주세요."], false),
  UseGuideShoppingItem([" 예상 비용을 확인한 후, 결제 정보를 입력하면 수선 접수가 완료됩니다."], false),
];

