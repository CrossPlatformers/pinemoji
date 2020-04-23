import 'package:flutter/cupertino.dart';
import 'package:pinemoji/widgets/health-widget.dart';

class HealthWidgetController extends StatefulWidget {
  final List<HealthStatusModel> healthStatusModelList;

  const HealthWidgetController({Key key, this.healthStatusModelList})
      : super(key: key);
  @override
  _HealthWidgetControllerState createState() => _HealthWidgetControllerState();
}

class _HealthWidgetControllerState extends State<HealthWidgetController> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.healthStatusModelList.map((healthModelWidget) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: GestureDetector(
              onTap: () {
                for (var current in widget.healthStatusModelList)
                  current.isActive = false;
                setState(() {
                  healthModelWidget.isActive = true;
                });
              },
              child: Padding(
                padding: widget.healthStatusModelList.indexOf(healthModelWidget) % 2 == 0 ?const EdgeInsets.fromLTRB(0,0,0,128)
                :const EdgeInsets.fromLTRB(0,128,0,0),
                child: HealthStatusContent(
                  healthStatusModel: healthModelWidget,
                ),
              ),
            ),
          );
        }).toList());
  }
}
