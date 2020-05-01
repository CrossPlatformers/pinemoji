import 'package:flutter/material.dart';

class StatusTitle extends StatelessWidget {
  String text;
  StatusTitle(String text){
    this.text = text;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: 180,
              child: Divider(
                color: Theme.of(context).primaryColor.withOpacity(.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
