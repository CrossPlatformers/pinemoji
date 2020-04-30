import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/pages/welcome.dart';
import 'package:pinemoji/shared/custom_theme.dart';

void main() => runApp(
      MyApp(),
      // DevicePreview(
      //   builder: (context) => MyApp(),
      //   enabled: true,
      // ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: customTheme,
      home: Scaffold(
        body: WelcomePage(),
      ),
    );
  }
}
