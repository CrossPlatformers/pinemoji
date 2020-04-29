import 'package:flutter/material.dart';
import 'package:pinemoji/shared/noti_icons_icons.dart';
import 'package:pinemoji/widgets/bottom.navi.bar.dart';

import 'health.dart';
import 'material.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  /// We are changing the page with [_selectedIndex]
  /// also it activates the current [BottomNavyBarItem]
  int _selectedIndex = 0;

  /// It help us to animate between pages when we are changing tabs
  PageController _pageController;

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Theme.of(context).primaryColorDark,
            Theme.of(context).primaryColorDark.withOpacity(0.9),
            Theme.of(context).primaryColorDark.withOpacity(0.7),
            Theme.of(context).primaryColorDark.withOpacity(0.3),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedIndex,
          backgroundColor: Colors.transparent,
          showElevation: true,
          // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
                icon: Icon(NotiIcons.compass_1),
                title: Text("Malzeme\nDurumu"),
                activeColor: Theme.of(context).primaryColorDark,
                inactiveColor: Theme.of(context).primaryColorLight,
                textAlign: TextAlign.center),
            BottomNavyBarItem(
                icon: Icon(Icons.error_outline),
                title: Text("Sağlık\nDurumu"),
                activeColor: Theme.of(context).primaryColorDark,
                inactiveColor: Theme.of(context).primaryColorLight,
                textAlign: TextAlign.center),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
            if (_selectedIndex != 1) {
              _isEditMode = false;
            }
          },
          children: <Widget>[
            MaterialStatus(),
            HealthStatus(),
          ],
        ),
      ),
    );
  }
}
