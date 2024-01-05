import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/home_tabs/home_tabs_appbar.dart';
import 'package:spiral_notebook/models/navigation_tab_item/navigation_tab_item.dart';
import 'package:spiral_notebook/screens/dashboard_screen.dart';
import 'package:spiral_notebook/screens/help_screen.dart';
import 'package:spiral_notebook/screens/notifications_list_screen.dart';
import 'package:spiral_notebook/screens/settings_screen.dart';
import 'package:spiral_notebook/utilities/constants.dart';


enum InitialTabSelection {
  home,
  help,
  notifications,
  settings,
}

class HomeTabsFrame extends StatefulWidget {
  static String id = 'home_tabs_frame';

  const HomeTabsFrame({
    Key? key,
    this.tabSelection,
  }) : super(key: key);

  final InitialTabSelection? tabSelection;

  @override
  _HomeTabsFrameState createState() => _HomeTabsFrameState();
}

class _HomeTabsFrameState extends State<HomeTabsFrame> {

  static const double iconSize = 30.0;

  List<NavigationTabItem> navItems = [
    NavigationTabItem(
      appBarTitle: 'Home',
      destinationWidget: DashboardScreen(),
      icon: Icon(Icons.house_outlined, size: iconSize),
    ),
    NavigationTabItem(
      appBarTitle: 'Help',
      destinationWidget: HelpScreen(),
      icon: Icon(Icons.help_outline, size: iconSize),
    ),
    NavigationTabItem(
      appBarTitle: 'Notifications',
      destinationWidget: NotificationsListScreen(),
      icon: Icon(Icons.notifications_none_outlined, size: iconSize),
    ),
    NavigationTabItem(
      appBarTitle: 'Settings',
      destinationWidget: SettingsScreen(),
      icon: Icon(Icons.settings_outlined, size: iconSize),
    ),
  ];

  late int selectedIndex;

  late NavigationTabItem currentTabItem;

  Future<bool> onItemTapped(int index) async {
    try {
      await navItems[index].onSelect?.call();
    } catch (e) {
      navItems[index].onSelectFail?.call();
      return false;
    }
    setState(() {
      selectedIndex = index;
    });
    return true;
  }
  InitialTabSelection? tabSelection;

  @override
  void initState() {
    super.initState();

    tabSelection = widget.tabSelection;

    // on first load, default to the initially provided tab.
    selectedIndex = tabSelection?.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    currentTabItem = navItems[selectedIndex];

    return Scaffold(
      appBar: HomeTabsAppBar(barTitle: currentTabItem.appBarTitle),
      body: currentTabItem.destinationWidget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: navItems.map((navItem) => BottomNavigationBarItem(
          icon: navItem.icon,
          label: navItem.appBarTitle,
        )).toList(),
        selectedItemColor: primaryButtonBlue,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
