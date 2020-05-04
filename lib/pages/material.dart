import 'package:flutter/material.dart';
import 'package:pinemoji/pages/map_page.dart';
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
          Expanded(
            child: Container(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.fromLTRB(50, 55, 50, 55),
                children: emojiList.map((currentElement) {
                  return MaterialStatusContent(
                    emoji: currentElement.info,
                    text: currentElement.description,
                  );
                }).toList(),
              ),
            ),
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
