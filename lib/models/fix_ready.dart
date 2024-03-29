class FixReady {
  late final int fixId;
  final String fixState;  // ready : 수선대기. progress : 수선 진행중, complete : 수선 완료
  String fixDate;
  late final String readyDate; // 수선 대기 status 날짜
  final String fixType;
  final bool updatePossible;

  // 수선 대기 진행 상황 표기
  final int readyInfo;

  FixReady(this.fixId, this.fixState, this.fixDate, this.readyDate, this.fixType, this.readyInfo, this.updatePossible);

}
