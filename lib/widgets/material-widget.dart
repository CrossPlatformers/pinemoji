import 'package:flutter/material.dart';

class MaterialStatusContent extends StatelessWidget {
  MaterialStatusContent({
    @required this.emoji,
    @required this.text,
    this.isActive = false,
    this.disabledColor = const Color(0xFFC7CAD1),
    this.activeColor = const Color(0xffD71773),
  });

  final String emoji;
  final String text;
  final bool isActive;
  final Color disabledColor;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isActive ? Color(0xffD71773) : Color(0xFFC7CAD1),
        ),
      ),
      height: size.width / 3,
      width: size.width / 3,
      margin: EdgeInsets.all(size.height / 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            emoji,
            style: TextStyle(fontSize: size.height / 18),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
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
