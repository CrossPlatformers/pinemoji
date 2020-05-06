import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/enums/marker-type-enum.dart';
import 'package:pinemoji/models/request.dart';
import 'package:pinemoji/pages/map_page.dart';
import 'package:pinemoji/repositories/request_repository.dart';
import 'package:pinemoji/services/authentication-service.dart';
import 'package:pinemoji/widget-controllers/material-widget-controller.dart';
import 'package:pinemoji/repositories/company_repository.dart';
import 'package:pinemoji/widgets/header-widget.dart';
import 'package:pinemoji/widgets/material-widget.dart';
import 'package:pinemoji/widgets/status-title.dart';
import 'package:pinemoji/widgets/outcome-button.dart';
import 'package:pinemoji/repositories/user_repository.dart';

class MaterialStatus extends StatefulWidget {
  static var emojiList = CompanyRepository().getEmojiList();
  static var materialModelList = emojiList.map((currentElement) {
    return MaterialStatusModel(
      emoji: currentElement.info,
      text: currentElement.description,
      color: Colors.white38,
      id: currentElement.id,
    );
  }).toList();
  MaterialStatus({
    Key key,
  }) : super(key: key);

  @override
  _MaterialStatusState createState() => _MaterialStatusState();
}

class _MaterialStatusState extends State<MaterialStatus> {
  final _scaffOldState = GlobalKey<ScaffoldState>();
  bool hasLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffOldState,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Container(
                    width: 210,
                    child: HeaderWidget(
                      title: "Malzeme Durumu",
                      isDarkTeheme: true,
                    ),
                  ),
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
            hasLoading
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: Colors.white70,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Durum Bildiriliyor...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : MaterialWidgetController(
                    materialStatusModelList: MaterialStatus.materialModelList,
                  ),
            !hasLoading
                ? OutcomeButton(
                    text: "Durum Bildir",
                    action: () async {
                      setState(() {
                        hasLoading = true;
                      });
                      List<Request> requestList = await RequestRepository()
                          .getMyRequests()
                          .then((requestList) {
                        return requestList;
                      });
                      FirebaseUser firebaseUser =
                          await AuthenticationService.instance.currentUser();
                      var user =
                          await UserRepository().getUser(firebaseUser.uid);

                      for (var materialModel
                          in MaterialStatus.materialModelList) {
                        if (materialModel.markerType != null) {
                          var req = requestList
                              .where((x) => x.emoji == materialModel.id);
                          if (req.length > 0) {
                            req.first.emoji = materialModel.id;
                            req.first.option =
                                getOption(materialModel.markerType);
                            req.first.date = DateTime.now();
                            req.first.locationName = user.extraInfo["location"];
                          } else
                            requestList.add(Request(
                              ownerId: user.id,
                              location: user.location,
                              companyId: CompanyRepository().getCompany().id,
                              emoji: materialModel.id,
                              option: getOption(materialModel.markerType),
                              date: DateTime.now(),
                              locationName: user.extraInfo["location"],
                            ));
                        }
                      }
                      bool status =
                          await RequestRepository().addRequestList(requestList);
                      setState(() {
                        hasLoading = false;
                      });
                      if (status) {
                        showWarning(
                            "Durum bildirme işleminiz başarıyla kaydedildi");
                      } else {
                        showWarning(
                            "İşlem sırasında hata oluştu, lütfen tekrar deneyiniz");
                      }
                      for (var current in MaterialStatus.materialModelList) {
                        current.isBlur = false;
                      }
                      setState(() {});
                    },
                  )
                : Container(),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  showWarning(String text) {
    _scaffOldState.currentState.showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        backgroundColor: Colors.white,
        duration: Duration(milliseconds: 1500),
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
