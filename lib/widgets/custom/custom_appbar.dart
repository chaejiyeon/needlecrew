import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leadingWidget;
  final bool isElevated;
  final String title;
  final String appbarcolor;
  final AppBar appbar;
  /// AppbarItem List
  final List<Widget>? actionItems;

  const CustomAppbar(
      {Key? key,
      this.leadingWidget,
      this.isElevated = false,
      this.title = '',
      required this.appbarcolor,
      required this.appbar,
      this.actionItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          appbarcolor == "white" ? Colors.white : Colors.transparent,
      elevation: isElevated && appbarcolor == "white" ? 3 : 0,
      leading: leadingWidget,
      centerTitle: title != '' ? true : false,
      title: FontStyle(
          text: title,
          fontsize: "md",
          fontcolor: appbarcolor == "white" ? Colors.black : Colors.white,
          fontbold: "bold",
          textdirectionright: false),
      actions: actionItems,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}
