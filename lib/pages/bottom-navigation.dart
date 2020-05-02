import 'package:flutter/material.dart';
import 'package:pinemoji/pages/health.dart';
import 'package:pinemoji/pages/survey-result.dart';
import 'package:pinemoji/shared/noti_icons_icons.dart';
import 'package:pinemoji/widgets/bottom.navi.bar.dart';

import 'material.dart';

class BottomNavigation extends StatefulWidget {
  final bool isAdminUser;
  BottomNavigation({this.isAdminUser = false});
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  /// We are changing the page with [_selectedIndex]
  /// also it activates the current [BottomNavyBarItem]
  int _selectedIndex = 0;
  
  /// It help us to animate between pages when we are changing tabs
  PageController _pageController;

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Theme.of(context).primaryColorDark,
              Theme.of(context).primaryColorDark.withOpacity(0.9),
              Theme.of(context).primaryColorDark.withOpacity(0.7),
              Theme.of(context).primaryColorDark.withOpacity(0.2),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: !widget.isAdminUser || _selectedIndex == 0 ? Colors.transparent : Theme.of(context).primaryColorLight,
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.transparent,
            shadowColor: !widget.isAdminUser || _selectedIndex == 0 ? Colors.white38 : Theme.of(context).primaryColor,
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
                  inactiveColor: !widget.isAdminUser || _selectedIndex == 0 ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                  textAlign: TextAlign.center),
              BottomNavyBarItem(
                  icon: Icon(Icons.error_outline),
                  title: Text("Sağlık\nDurumu"),
                  activeColor: Theme.of(context).primaryColorDark,
                  inactiveColor: !widget.isAdminUser || _selectedIndex == 0 ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                  textAlign: TextAlign.center),
            ],
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: <Widget>[
              MaterialStatus(),
              widget.isAdminUser ? SurveyResultPage() : HealthStatus(),
            ],
          ),
        ),
      ),
    );
  }
}
