import 'package:flutter/material.dart';
import 'package:pinemoji/widgets/inform-button.dart';
import 'package:pinemoji/widgets/status-title.dart';
import 'package:pinemoji/widgets/vertical-slider.dart';
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
          StatusTitle("Sağlık Durumu"),
          VerticalSlider(),
          OutcomeButton(
            text: "Durum Bildir",
            action: () {},
          ),
          SizedBox(
                height: 40,
              ),
        ],
      ),
    );
  }
}
