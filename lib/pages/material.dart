import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/models/request.dart';
import 'package:pinemoji/pages/map_page.dart';
import 'package:pinemoji/services/authentication-service.dart';
import 'package:pinemoji/widget-controllers/material-widget-controller.dart';
import 'package:pinemoji/repositories/company_repository.dart';
import 'package:pinemoji/widgets/material-widget.dart';
import 'package:pinemoji/widgets/status-title.dart';
import 'package:pinemoji/widgets/outcome-button.dart';
import 'package:pinemoji/repositories/user_repository.dart';

class MaterialStatus extends StatelessWidget {
  static var emojiList = CompanyRepository().getEmojiList();
  static var materialModelList = emojiList.map((currentElement) {
                  return MaterialStatusModel(
                    currentElement.info,
                    currentElement.description,
                    Colors.white38
                  );
                }).toList();

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
            materialStatusModelList: materialModelList,
              
          ),
          OutcomeButton(
            text: "Durum Bildir",
            action: () async {
              var a = materialModelList;
              FirebaseUser firebaseUser = await AuthenticationService.instance.currentUser();
              var user = await UserRepository().getUser(firebaseUser.uid);
              Request request = Request(ownerId: user.id, location: user.location, companyId: user.os, emoji: null, image: null, state: null, responseList: null, option: null, date: null);
              print(user);
            },
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
