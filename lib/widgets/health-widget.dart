import 'package:flutter/material.dart';

class HealthStatusModel {
  final String emoji;
  final String text;
  bool isActive = false;

  HealthStatusModel({this.emoji, this.text});
}

class HealthStatusContent extends StatelessWidget {
  final HealthStatusModel healthStatusModel;

  const HealthStatusContent({Key key, this.healthStatusModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70),
        border: Border.all(
          width: 3,
          color: healthStatusModel.isActive ? Color(0xFFF93963) : Colors.white,
        ),
      ),
      height: size.width / 2.3,
      width: size.width / 2.9,
      margin: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            healthStatusModel.emoji,
            style: TextStyle(fontSize: 35),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            healthStatusModel.text,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Color(0xFFC7CAD1),
            ),
          )
        ],
      ),
    );
  }
}
