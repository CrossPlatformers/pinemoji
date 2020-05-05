import 'package:flutter/material.dart';
import 'package:pinemoji/pages/map_page.dart';
import 'package:pinemoji/widget-controllers/material-widget-controller.dart';
import 'package:pinemoji/repositories/company_repository.dart';
import 'package:pinemoji/widgets/material-widget.dart';
import 'package:pinemoji/widgets/status-title.dart';
import 'package:pinemoji/widgets/outcome-button.dart';

class MaterialStatus extends StatelessWidget {
  static var emojiList = CompanyRepository().getEmojiList();

  const MaterialStatus({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StatusTitle(
                "Malzeme Durumu",
                210,
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return MapPage();
                })),
                child: Image.asset(
                  "assets/map.png",
                  width: 90,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          MaterialWidgetController(
            materialStatusModelList: emojiList.map((currentElement) {
                  return MaterialStatusModel(
                    currentElement.info,
                    currentElement.description,
                    Colors.white38
                  );
                }).toList(),
              
          ),
          OutcomeButton(
            text: "Durum Bildir",
            action: () {},
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
