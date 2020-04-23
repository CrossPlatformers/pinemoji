import 'package:flutter/material.dart';
import 'package:pinemoji/pages/health.dart';
import 'package:pinemoji/pages/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: HealthStatus(),
      ),
    );
  }
}
