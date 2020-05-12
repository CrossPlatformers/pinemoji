import 'package:after_layout/after_layout.dart';
import 'package:feature_discovery/feature_discovery.dart';
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
import 'package:pinemoji/widgets/outcome-button.dart';
import 'package:pinemoji/repositories/user_repository.dart';
import 'package:pinemoji/widgets/feature_shower.dart';

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

class _MaterialStatusState extends State<MaterialStatus> with AfterLayoutMixin {
  final _scaffOldState = GlobalKey<ScaffoldState>();
  bool hasLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffOldState,
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FeatureDiscovery.completeCurrentStep(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FeatureDiscovery(
                        child: MapPage(
                          isNormalUser: !(AuthenticationService
                                  .verifiedUser.extraInfo['status'] ==
                              "TTBA"),
                        ),
                      )));
        },
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(60)),
            child: Image.asset(
              "assets/icon.png",
              width: 90,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ).showFeature(
        context,
        title: 'Harita',
        description:
            'Harita üzerinde, etrafınızdaki malzeme durum bildirim pinlerini görebilirsiniz',
        featureId: 'map',
      ),
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
                  onTap: () async {
                    FeatureDiscovery.completeCurrentStep(context);
                    var x = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          content: Profile(size: size),
                        );
                      },
                    );
                    FeatureDiscovery.discoverFeatures(
                      context,
                      const <String>{
                        'emoji',
                      },
                    );
//                    FeatureDiscovery.clearPreferences(context, ['profile','map']);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/default-profile.png"),
                    ),
                  ),
                ).showFeature(
                  context,
                  title: 'Profil',
                  description: 'Buradan profil bilgilerinizi görebilirsiniz',
                  featureId: 'profile',
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
                              fontStyle: FontStyle.italic,
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
                            req.first.location = user.location;
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
                        current.hasBorder = true;
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
        duration: Duration(milliseconds: 3000),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    FeatureDiscovery.discoverFeatures(
      context,
      const <String>{
        'profile',
      },
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final widgetSize = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: widgetSize.height / 6,
            width: widgetSize.height / 6,
            child: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/default-profile.png",
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          (AuthenticationService.verifiedUser.extraInfo['unvan'] ?? "") +
              " " +
              (AuthenticationService.verifiedUser.name ?? "") +
              " " +
              (AuthenticationService.verifiedUser.surname ?? ""),
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).primaryColorDark,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Stack(
              children: <Widget>[
                Image.asset(
                  "assets/red-pin.png",
                  width: 30,
                ),
                Positioned(
                  top: 3,
                  left: 8,
                  child: Text(
                    "H",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Flexible(
              child: Text(
                AuthenticationService.verifiedUser.extraInfo['location'] ??
                    "Lütfen güncel kurum bilginizi TTB ile paylaşınız",
                style: TextStyle(fontSize: 18, color: Color(0xFF6FCF97)),
              ),
            )
          ],
        ),
      ],
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
