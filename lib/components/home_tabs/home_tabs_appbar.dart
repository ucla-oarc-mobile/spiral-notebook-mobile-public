import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class HomeTabsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeTabsAppBar({Key? key, required this.barTitle}) : super(key: key);

  final String barTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: null,
      title: Text(barTitle.toUpperCase()),
      backgroundColor: primaryButtonBlue,
      actions: null,
    );
  }

  // per [flutter - The AppBarDesign can't be assigned to the parameter type 'PreferredSizeWidget' - Stack Overflow](https://stackoverflow.com/questions/52678469/the-appbardesign-cant-be-assigned-to-the-parameter-type-preferredsizewidget)
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

