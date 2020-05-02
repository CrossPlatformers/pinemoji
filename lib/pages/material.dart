import 'package:flutter/material.dart';
import 'package:pinemoji/widgets/material-widget.dart';
import 'package:pinemoji/widgets/status-title.dart';
import 'package:pinemoji/widgets/outcome-button.dart';

class MaterialStatus extends StatelessWidget {
  const MaterialStatus({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StatusTitle("Malzeme Durumu"),
          Expanded(
            child: Container(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.fromLTRB(50, 55, 50, 55),
                children: <Widget>[
                  MaterialStatusContent(
                    emoji: "😷",
                    text: " Tıbbi\nMaske",
                  ),
                  MaterialStatusContent(
                    emoji: "😷",
                    text: "  N95\nMaske",
                  ),
                  MaterialStatusContent(
                    emoji: "🥽",
                    text: "Siperlik /\n Gözlük",
                  ),
                  MaterialStatusContent(
                    emoji: "🧤",
                    text: "Eldiven",
                  ),
                  MaterialStatusContent(
                    emoji: "🥼",
                    text: "Önlük",
                  ),
                  MaterialStatusContent(
                    emoji: "⚗",
                    text: "Solunum\n Cihazı",
                  ),
                ],
              ),
            ),
          ),
          OutcomeButton(
            text: "Durum Bildir",
            action: () {},
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
