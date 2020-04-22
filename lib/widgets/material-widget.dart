import 'package:flutter/material.dart';

class MaterialStatusContent extends StatelessWidget {
  MaterialStatusContent({@required this.emoji, @required this.text});

  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return 
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Color(0xFFC7CAD1),
            ),
          ),
          height: size.width / 3,
          width: size.width / 3,
          margin: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                emoji,
                style: TextStyle(fontSize: 50),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFC7CAD1),
                ),
              )
            ],
          ),
    );
  }
}
