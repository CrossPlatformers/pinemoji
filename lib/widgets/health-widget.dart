import 'package:flutter/material.dart';

class HealthStatusModel {
  String emoji;
  String text;
  String hintText;
  bool isOther = false;
  bool isActive = false;
  HealthStatusModel(String emoji, String text,
      {bool isOther = false, this.hintText}) {
    this.emoji = emoji;
    this.text = text;
    this.isOther = isOther;
  }
}

class HealthStatusContent extends StatefulWidget {
  final HealthStatusModel healthStatusModel;
  final Function textEdtingCompleted;

  HealthStatusContent(
      {Key key, this.healthStatusModel, this.textEdtingCompleted})
      : super(key: key);

  @override
  _HealthStatusContentState createState() => _HealthStatusContentState();
}

class _HealthStatusContentState extends State<HealthStatusContent> {
  final TextEditingController otherInfoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.healthStatusModel.isActive
                  ? Color(0xFFF93963)
                  : Colors.transparent,
            ),
          ),
          width: size.width,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.healthStatusModel.emoji,
                  style: TextStyle(fontSize: 35),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 4.0, 0),
                    child: Text(
                      widget.healthStatusModel.text,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFC7CAD1),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white38,
              ),
            ),
            width: size.width,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 0, 4),
              child: TextField(
                controller: otherInfoController,
                onChanged: (value) {
                  widget.textEdtingCompleted(value);
                  setState(() {});
                },
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFC7CAD1),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      widget.healthStatusModel.hintText ?? "Lütfen yazınız...",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFC7CAD1),
                  ),
                  suffixIcon: otherInfoController.text != ""
                      ? IconButton(
                          onPressed: () {
                            otherInfoController.clear();
                          },
                          icon: Icon(Icons.clear),
                        )
                      : null,
                ),
              ),
            ),
          ),
          visible: widget.healthStatusModel.isOther &&
              widget.healthStatusModel.isActive,
        )
      ],
    );
  }
}
