import 'package:flutter/material.dart';

class TooltipText {
  final String tooltipName;
  final String tooltipText;
  final List boldText;

  TooltipText(
      {required this.tooltipName,
      required this.tooltipText,
      required this.boldText});
}

// 예상 의뢰 비용 , 예상 비용, // 선택한 의뢰 비용
TooltipText cost = TooltipText(
    tooltipName: "예상 비용",
    tooltipText: "옷의 부위와 재질, 수선 난이도에 따라 추가 비용이 발생할 수 있습니다.",
    boldText: ["추가 비용이 발생"]);

// 배송 비용
TooltipText ship = TooltipText(
    tooltipName: "배송 비용",
    tooltipText: "의류 수거 비용 3,000원, 배송지 발송 비용 3,000원이 부과되며, 한 번에 결제한 의뢰 건 기준(6,000원)으로 묶음배송 진행됩니다.",
    boldText: ["3,000", "한 번에 결제한 의뢰 건 기준","(6,000원)"]);


// 직접입력
TooltipText insert = TooltipText(
    tooltipName: "직접 입력",
    tooltipText: "정확한 수선비용은 수선 전문가의 확인 후 결정됩니다.",
    boldText: []);
