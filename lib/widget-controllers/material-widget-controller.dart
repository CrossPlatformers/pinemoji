import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/pages/map_page.dart';
import 'package:pinemoji/widgets/material-widget.dart';

class MaterialWidgetController extends StatefulWidget {
  final List<MaterialStatusModel> materialStatusModelList;

  const MaterialWidgetController({Key key, this.materialStatusModelList})
      : super(key: key);
  @override
  _MaterialWidgetControllerState createState() =>
      _MaterialWidgetControllerState();
}

class _MaterialWidgetControllerState extends State<MaterialWidgetController> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: materialList(
                    widget.materialStatusModelList.take(2).toList()),
              ),
              VisibilityCondition(
                isVisible: getIndex() == 0 || getIndex() == 1,
                onFilterChange: (name) {
                  setEmojiBorder(name);
                },
                state: getState(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: materialList(
                    widget.materialStatusModelList.skip(2).take(2).toList()),
              ),
              VisibilityCondition(
                isVisible: getIndex() == 2 || getIndex() == 3,
                onFilterChange: (name) {
                  setEmojiBorder(name);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: materialList(
                    widget.materialStatusModelList.skip(4).take(2).toList()),
              ),
              VisibilityCondition(
                isVisible: getIndex() == 4 || getIndex() == 5,
                onFilterChange: (name) {
                  setEmojiBorder(name);
                },
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
          // child: gridList(materialList(widget.materialStatusModelList)),
        ),
      ),
    );
  }

  void setEmojiBorder(name) {
    var currentWidget = widget.materialStatusModelList.elementAt(getIndex());
    setState(() {
      switch (name) {
        case "Acil Destek":
          currentWidget.color = Color(0xFFF93963);
          break;
        case "Azalıyor !":
          currentWidget.color = Color(0xFFEBEE51);
          break;
        case "Yeterli":
          currentWidget.color = Color(0xFF1CABCB);
          break;
        default:
          currentWidget.color = Colors.white38;
      }
    });
  }

  int getIndex() {
    return widget.materialStatusModelList.indexWhere((e) => e.isActive);
  }

  String getState() {
    if (getIndex() != -1) {
      var current = widget.materialStatusModelList[getIndex()];
      if (current.color == Color(0xFFF93963)) {
        return "Acil Destek";
      } else if (current.color == Color(0xFFEBEE51)) {
        return "Azalıyor !";
      } else if (current.color == Color(0xFF1CABCB)) {
        return "Yeterli";
      }
    }
    return null;
  }

  List<Widget> materialList(List<MaterialStatusModel> materialStatusModelList) {
    List<Widget> widgetList =
        materialStatusModelList.map((materialModelWidget) {
      return Padding(
        padding: const EdgeInsets.all(0),
        child: GestureDetector(
          onTap: () {
            if (!materialModelWidget.isActive) {
              for (var current in widget.materialStatusModelList)
                current.isActive = false;
            }
            setState(() {
              materialModelWidget.isActive = !materialModelWidget.isActive;
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

  Widget gridList(List<Widget> widgetList) {
    List<Widget> rowList = new List<Widget>();
    for (var current in widgetList) {
      if (widgetList.indexOf(current) % 2 == 0) {
        rowList.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              current,
              widgetList.asMap().containsKey(widgetList.indexOf(current) + 1)
                  ? widgetList[widgetList.indexOf(current) + 1]
                  : null
            ],
          ),
        );
      }
    }
    return Column(
      children: rowList,
    );
  }
}

class VisibilityCondition extends StatelessWidget {
  final bool isVisible;
  final Function(String) onFilterChange;
  final String state;
  VisibilityCondition(
      {this.isVisible = false, this.onFilterChange, this.state});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConditionFilter(onFilterChange: onFilterChange, state: state),
        ],
      ),
    );
  }
}
