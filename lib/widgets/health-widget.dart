import 'package:flutter/material.dart';

class HealthStatusModel {
  String emoji;
  String text;
  bool isOther = false;
  bool isActive = false;
  HealthStatusModel(String emoji, String text, {bool isOther = false}) {
    this.emoji = emoji;
    this.text = text;
    this.isOther = isOther;
  }
}

class HealthStatusContent extends StatelessWidget {
  final HealthStatusModel healthStatusModel;

  const HealthStatusContent({Key key, this.healthStatusModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 3,
              color: healthStatusModel.isActive
                  ? Color(0xFFF93963)
                  : Colors.transparent,
            ),
          ),
          width: size.width,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  healthStatusModel.emoji,
                  style: TextStyle(fontSize: 35),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                    child: Text(
                      healthStatusModel.text,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFC7CAD1),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 3,
                color: Colors.white38,
              ),
            ),
            width: size.width,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFC7CAD1),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Lütfen yazınız...",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFC7CAD1),
                  ),
                ),
              ),
            ),
          ),
          visible: healthStatusModel.isOther && healthStatusModel.isActive,
        )
      ],
    );
  }
}
