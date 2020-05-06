import 'package:flutter/material.dart';
import 'package:pinemoji/pages/map_page.dart';
import 'package:pinemoji/repositories/map_repository.dart';
import 'package:pinemoji/pages/health.dart';
import 'package:pinemoji/pages/survey-result.dart';
import 'package:pinemoji/services/authentication-service.dart';
import 'package:pinemoji/shared/noti_icons_icons.dart';
import 'package:pinemoji/widgets/bottom.navi.bar.dart';

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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    MapRepository.init();
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
          backgroundColor: Colors.transparent,
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.white38,
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
                  inactiveColor:
                      Theme.of(context).primaryColorLight.withOpacity(.5),
                  textAlign: TextAlign.center),
              BottomNavyBarItem(
                  icon: Icon(Icons.error_outline),
                  title: Text("Sağlık\nDurumu"),
                  activeColor: Theme.of(context).primaryColorDark,
                  inactiveColor:
                      Theme.of(context).primaryColorLight.withOpacity(.5),
                  textAlign: TextAlign.center),
            ],
          ),
          body: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: <Widget>[
              [
                "TTBA",
                "PD"
              ].contains(AuthenticationService.verifiedUser.extraInfo['status'])
                  ? MapPage(
                      fromRoot: true,
                    )
                  : MaterialStatus(),
              AuthenticationService.verifiedUser.extraInfo['status'] == "TTBA"
                  ? HealthStatus()
                  : HealthStatus(),
            ],
          ),
        ),
      ),
    );
  }
}
