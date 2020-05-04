import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/widgets/material-widget.dart';

class MaterialWidgetController extends StatefulWidget {
  final List<MaterialStatusModel> materialStatusModelList;

  const MaterialWidgetController(
      {Key key, this.materialStatusModelList})
      : super(key: key);
  @override
  _MaterialWidgetControllerState createState() =>
      _MaterialWidgetControllerState();
}

class _MaterialWidgetControllerState extends State<MaterialWidgetController> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.fromLTRB(50, 55, 50, 55),
          children: materialList(widget.materialStatusModelList),
        ),
      ),
    );
  }

  List<Widget> materialList(List<MaterialStatusModel> materialStatusModelList) {
    List<Widget> widgetList =
        materialStatusModelList.map((materialModelWidget) {
      return Padding(
        padding: const EdgeInsets.all(0),
        child: GestureDetector(
          onTap: () {
            for (var current in materialStatusModelList)
              current.isActive = false;
            setState(() {
              materialModelWidget.isActive = true;
            });
          },
          child: MaterialStatusContent(
            materialStatusModel: materialModelWidget,
          ),
        ),
      );
    }).toList();
    return widgetList;
  }
}
