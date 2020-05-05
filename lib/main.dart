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

  @override
  void initState() {
    AuthenticationService.instance.onAuthStateChanged.listen((event) {
      // TODO: event'in tipine göre kontrollerle istediğimizi yapabiliriz
    });
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
        body: StreamBuilder(
            stream: AuthenticationService.instance.onAuthStateChanged,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                // AuthenticationService.instance.signOut();
                return BottomNavigation(
                  isAdminUser: true,
                );
              }
              return WelcomePage();
            }),
      ),
    );
  }
}
