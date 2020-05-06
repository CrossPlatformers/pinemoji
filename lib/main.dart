import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/pages/bottom-navigation.dart';
import 'package:pinemoji/pages/welcome.dart';
import 'package:pinemoji/services/authentication-service.dart';
import 'package:pinemoji/shared/custom_theme.dart';
import 'package:connectivity/connectivity.dart';

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
  bool hasConnection = false;
  @override
  void initState() {
    // AuthenticationService().signOut();
    listen();
    AuthenticationService.instance.onAuthStateChanged.listen((event) {
      if (event != null) {
        AuthenticationService().checkPhoneNumber(event.phoneNumber).then((val) {
          setState(() {
            loggedIn =
                AuthenticationService.verifiedUser == null ? false : true;
          });
        });
      } else {
        setState(() {
          loggedIn = false;
        });
      }
    });
    super.initState();
  }

  void listen() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print("Connection Status has Changed");
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          hasConnection = true;
        });
      } else {
        setState(() {
          hasConnection = false;
        });
      }
    });
  }

  Widget getMainPage(bool loggedIn, bool hasConnection) {
    return hasConnection
        ? loggedIn == null
            ? Container()
            : (loggedIn ? BottomNavigation() : WelcomePage())
        : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Lütfen bağlantınızı kontrol ediniz...",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          );
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
        body: getMainPage(loggedIn, hasConnection),
      ),
    );
  }
}
