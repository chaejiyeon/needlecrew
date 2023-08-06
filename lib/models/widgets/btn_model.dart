import 'package:flutter/material.dart';

class BtnModel {
  final Function callback;
  final double? width;
  final double? height;
  final double? margin;
  final String text;
  final Color? textColor;
  final double? textSize;
  final FontWeight? textWeight;
  final Color borderColor;
  final Color? btnColor;
  final double? distance;
  final double? endDistance;
  final EdgeInsets? endIconMargin;
  final String? btnIcon;
  final String? endBtnIcon;
  final String? prevBtnIcon;
  final Color? iconColor;
  final double? iconWidth;
  final double? iconHeight;
  final double? prevIconHeight;
  final double? prevIconWidth;
  final double? prevDistance;
  final EdgeInsets? prevMargin;

  BtnModel(
      {required this.callback,
      this.width,
      this.height = 100,
      this.margin = 0,
      this.text = '',
      this.textColor,
      this.textSize = 14,
      this.textWeight = FontWeight.normal,
      this.borderColor = Colors.transparent,
      this.btnColor,
      this.distance = 0,
      this.endDistance = 0,
      this.endIconMargin = const EdgeInsets.only(right: 21),
      this.btnIcon = '',
      this.endBtnIcon = '',
      this.prevBtnIcon = '',
      this.iconColor = Colors.white,
      this.prevIconWidth = 0,
      this.prevDistance = 0,
      this.prevIconHeight = 0,
      this.prevMargin = EdgeInsets.zero,
      this.iconWidth = 0,
      this.iconHeight = 0});
}
