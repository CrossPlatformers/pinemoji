import 'package:flutter/material.dart';
import 'package:pinemoji/widget-controllers/health-widget-controller.dart';
import 'package:pinemoji/widgets/health-widget.dart';
import 'package:pinemoji/widgets/outcome-button.dart';

class HealthStatus extends StatelessWidget {
  const HealthStatus({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SingleChildScrollView(
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
                ],
              ),
            ),
          ),
          OutcomeButton(
            text: "Durum Bildir",
            action: () {},
          ),
          SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
