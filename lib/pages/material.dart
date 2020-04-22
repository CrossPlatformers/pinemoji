import 'package:flutter/material.dart';
import 'package:pinemoji/widgets/material-widget.dart';

class MaterialStatus extends StatelessWidget {
  const MaterialStatus({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF32446C),
            Color(0xFF32446C).withOpacity(0.9),
            Color(0xFF32446C).withOpacity(0.7),
            Color(0xFF32446C).withOpacity(0.2),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Malzeme Durumu",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                width: 210,
                child: Divider(
                  color: Color.fromRGBO(226, 221, 221, 0.3),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: size.height - size.height / 4,
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: <Widget>[
                        MaterialStatusContent(
                          emoji: "😷",
                          text: "Tıbbi Maske",
                        ),
                        MaterialStatusContent(
                          emoji: "😷",
                          text: "N95 Maske",
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
              ],
            ),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: size.width - 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21.5),
                    border: Border.all(
                      color: Color(0xFFC7CAD1),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Durum Bildir",
                        style: TextStyle(
                          color: Color(0xFF26315F),
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
