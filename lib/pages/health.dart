import 'package:flutter/material.dart';
import 'package:pinemoji/widgets/inform-button.dart';
import 'package:pinemoji/widgets/status-title.dart';
import 'package:pinemoji/widgets/vertical-slider.dart';

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
          StatusTitle("Sağlık Durumu"),
          VerticalSlider(),
          InformButton(),
          SizedBox(
                height: 40,
              ),
        ],
      ),
    );
  }
}
