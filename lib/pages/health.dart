import 'package:flutter/material.dart';
import 'package:pinemoji/shared/custom-box-shadow.dart';
import 'package:pinemoji/widget-controllers/health-widget-controller.dart';
import 'package:pinemoji/widgets/health-widget.dart';

class HealthStatus extends StatelessWidget {
  const HealthStatus({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Text(
              "Sağlık Durumu",
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: size.height * .7,
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
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: size.width - 100,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(21.5),
                          boxShadow: [
                            CustomBoxShadow(
                                color: Theme.of(context).primaryColorDark,
                                offset: new Offset(3, 3),
                                blurRadius: 2.0,
                                blurStyle: BlurStyle.outer),
                            CustomBoxShadow(
                                color: Theme.of(context).primaryColorDark,
                                offset: new Offset(-1, 3),
                                blurRadius: 2.0,
                                blurStyle: BlurStyle.outer),
                            CustomBoxShadow(
                                color: Colors.white,
                                offset: new Offset(1, -0.2),
                                blurRadius: 5.0,
                                blurStyle: BlurStyle.outer),
                          ],
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
