import 'package:flutter/material.dart';
import 'package:pinemoji/enums/marker-type-enum.dart';

class MaterialStatusModel {
  String emoji;
  String text;
  bool isActive = false;
  MarkerType markerType;
  Color color;
  MaterialStatusModel(String emoji, String text, Color color) {
    this.emoji = emoji;
    this.text = text;
    this.color = color;
  }
}

class MaterialStatusContent extends StatelessWidget {
  final MaterialStatusModel materialStatusModel;

  const MaterialStatusContent({Key key, this.materialStatusModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              materialStatusModel.color,
        ),
      ),
      height: size.width / 3,
      width: size.width / 3,
      margin: EdgeInsets.all(size.height / 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            materialStatusModel.emoji,
            style: TextStyle(fontSize: size.height / 18),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            materialStatusModel.text,
            style: TextStyle(
              fontSize: size.height / 45,
              fontStyle: FontStyle.italic,
              color: Color(0xFFC7CAD1),
            ),
          )
        ],
      ),
    );
  }
}
