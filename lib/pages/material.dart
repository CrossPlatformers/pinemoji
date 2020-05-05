import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/enums/marker-type-enum.dart';
import 'package:pinemoji/models/request.dart';
import 'package:pinemoji/pages/map_page.dart';
import 'package:pinemoji/repositories/request_repository.dart';
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
      emoji: currentElement.info,
      text: currentElement.description,
      color: Colors.white38,
      id: currentElement.id,
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
              List<Request> requestList = await RequestRepository().getMyRequests().then((requestList) {
                return requestList;
              });
              FirebaseUser firebaseUser = await AuthenticationService.instance.currentUser();
              var user = await UserRepository().getUser(firebaseUser.uid);
              
              for (var materialModel in materialModelList) {
                if (materialModel.markerType != null){
                  var req = requestList.where((x) => x.emoji == materialModel.id);
                  if (req.length > 0 ) {
                    req.first.emoji = materialModel.id;
                    req.first.option = getOption(materialModel.markerType);
                    req.first.date =  DateTime.now();
                  }
                  else
                    requestList.add(Request(
                      ownerId: user.id,
                      location: user.location,
                      companyId: CompanyRepository().getCompany().id,
                      emoji: materialModel.id,
                      option: getOption(materialModel.markerType),
                      date: DateTime.now()));
                }
              }
              RequestRepository().addRequestList(requestList);
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

String getOption(MarkerType markerType) {
  switch (markerType) {
    case MarkerType.red:
      return "Acil Destek";
    case MarkerType.yellow:
      return "Azalıyor !";
    case MarkerType.blue:
      return "Yeterli";
    default:
      return "";
  }
}
