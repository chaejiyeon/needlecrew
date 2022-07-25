class AlramItem{
  final String alramNo;
  final String title;
  final int time;

  AlramItem(this.alramNo, this.title, this.time);
}

List<AlramItem> alrams = [
  AlramItem("confirmIcon.svg", "수선 확정을 기다리는 의뢰가 있어요!", 10),
  AlramItem("arriveIcon.svg", "고객님의 의류가 수선사에게 도착했어요!", 60),
  AlramItem("arriveIcon.svg", "아아아아아아아", 60),
];