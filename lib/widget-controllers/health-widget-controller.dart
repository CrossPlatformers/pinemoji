import 'package:after_layout/after_layout.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:pinemoji/widgets/health-widget.dart';

class HealthWidgetController extends StatefulWidget {
  final String questionId;
  final Map<String, String> resultMap;
  final List<HealthStatusModel> healthStatusModelList;

  const HealthWidgetController({
    Key key,
    this.healthStatusModelList,
    this.resultMap,
    this.questionId,
  }) : super(key: key);

  @override
  _HealthWidgetControllerState createState() => _HealthWidgetControllerState();
}

class _HealthWidgetControllerState extends State<HealthWidgetController>
    with AfterLayoutMixin {

  @override
  void afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 300));
    FeatureDiscovery.discoverFeatures(context, ['anket']);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: answerList(widget.healthStatusModelList),
    );
  }

  List<Widget> answerList(List<HealthStatusModel> healthStatusModelList) {
    if (widget.resultMap != null) {
      healthStatusModelList.forEach((healthModelWidget) {
        if (healthModelWidget.text == widget.resultMap[widget.questionId] ||
            (widget.resultMap[widget.questionId] != null &&
                healthModelWidget.hintText ==
                    widget.resultMap[widget.questionId])) {
          healthModelWidget.isActive = true;
        }
      });
    }
    List<Widget> widgetList = healthStatusModelList.map((healthModelWidget) {
      return Padding(
        padding: const EdgeInsets.all(0),
        child: GestureDetector(
          onTap: () {
            for (var current in healthStatusModelList) current.isActive = false;
            setState(() {
              if (!healthModelWidget.isOther ||
                  widget.resultMap[widget.questionId] == null ||
                  healthStatusModelList
                      .map((f) => f.text)
                      .contains(widget.resultMap[widget.questionId])) {
                widget.resultMap[widget.questionId] = healthModelWidget.text;
                healthModelWidget.isActive = true;
              }
            });
          },
          child: HealthStatusContent(
            healthStatusModel: healthModelWidget,
            textEdtingCompleted: (text) {
              widget.resultMap[widget.questionId] = text;
              healthModelWidget.hintText = text;
            },
          ),
        ),
      );
    }).toList();
    return widgetList;
  }
}
