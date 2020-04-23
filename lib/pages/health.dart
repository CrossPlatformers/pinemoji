import 'package:flutter/material.dart';
import 'package:pinemoji/widget-controllers/health-widget-controller.dart';
import 'package:pinemoji/widgets/health-widget.dart';

class HealthStatus extends StatelessWidget {
  const HealthStatus({
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
                "Sağlık Durumu",
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
                width: 180,
                child: Divider(
                  color: Color.fromRGBO(226, 221, 221, 0.3),
                ),
              ),
            ),
            Container(
                height: size.height - size.height / 4,
                child: HealthWidgetController(
                  healthStatusModelList: [
                    HealthStatusModel(
                      emoji: "  🤢\n🤒 😷",
                      text: "Test Sonucum \n      Pozitif",
                    ),
                    HealthStatusModel(
                      emoji: "  😊\n✌💪",
                      text: "Test Sonucum \n      Negatif",
                    ),
                  ],
                )),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: size.width - 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21.5),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF394EA8), Color(0xFFC7CAD1)]),
                    border: Border.all(
                      color: Color(0xFF394EA8),
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
