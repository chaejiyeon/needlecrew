import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leadingWidget;
  final bool showLeadingBtn;
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
      this.showLeadingBtn = true,
      this.title = '',
      required this.appbarcolor,
      required this.appbar,
      this.actionItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showLeadingBtn,
      backgroundColor:
          appbarcolor == "white" ? Colors.white : Colors.transparent,
      elevation: isElevated && appbarcolor == "white" ? 3 : 0,
      leading: leadingWidget,
      centerTitle: title != '' ? true : false,
      title: CustomText(
        text: title,
        fontSize: FontSize().fs6,
        fontColor: appbarcolor == "white" ? Colors.black : Colors.white,
        fontWeight: FontWeight.bold,
      ),
      actions: actionItems,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}
