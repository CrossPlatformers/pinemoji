import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/pages/bottom-navigation.dart';
import 'package:pinemoji/pages/welcome.dart';
import 'package:pinemoji/services/authentication-service.dart';
import 'package:pinemoji/shared/custom_theme.dart';

void main() => runApp(
      DevicePreview(
        builder: (context) => MyApp(),
        enabled: false,
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loggedIn;
  @override
  void initState() {
    // AuthenticationService().signOut();
    AuthenticationService.instance.onAuthStateChanged.listen((event) {
      if (event != null) {
        AuthenticationService().checkPhoneNumber(event.phoneNumber).then((val) {
          setState(() {
            loggedIn = AuthenticationService.verifiedUser == null ? false : true;
          });
        });
      } else {
        setState(() {
          loggedIn = false;
        });
      }
    });
    Future.delayed(Duration(seconds: 5)).then((val) => setState(() => loggedIn = loggedIn == null ? false : loggedIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.of(context).locale,
      // <--- Add the locale
      builder: DevicePreview.appBuilder,
      // <--- Add the builder
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      home: Scaffold(
        body: loggedIn == null ? Container() : (loggedIn ? BottomNavigation() : WelcomePage()),
      ),
    );
  }
}
