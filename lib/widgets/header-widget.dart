import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final bool isDarkTeheme;
  final String title;

  const HeaderWidget({
    this.title,
    this.isDarkTeheme = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: isDarkTeheme
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColorDark,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isDarkTeheme
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).primaryColor,
                isDarkTeheme
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).primaryColor,
                isDarkTeheme ? Colors.transparent : Colors.white
              ],
            ),
          ),
        ),
      ],
    );
  }
}
