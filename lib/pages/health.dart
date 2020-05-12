import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/models/survey.dart';
import 'package:pinemoji/repositories/company_repository.dart';
import 'package:pinemoji/repositories/survey_repository.dart';
import 'package:pinemoji/widgets/header-widget.dart';
import 'package:pinemoji/widgets/vertical-slider.dart';
import 'package:pinemoji/widgets/outcome-button.dart';

class HealthStatus extends StatefulWidget {
  static Survey survey = CompanyRepository().getSurvey();

  HealthStatus({
    Key key,
  }) : super(key: key);

  @override
  _HealthStatusState createState() => _HealthStatusState();
}

class _HealthStatusState extends State<HealthStatus> {
  Map<String, String> resultMap;
  @override
  void initState() {
    SurveyRepository()
        .getOwnData(HealthStatus.survey.id)
        .then((map) => setState(() => resultMap = map));
    super.initState();
  }

  final _scaffOldState = GlobalKey<ScaffoldState>();
  bool hasLoading = false;

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: Scaffold(
        key: _scaffOldState,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: GestureDetector(
            onTap: ()=> FocusScope.of(context).requestFocus(FocusNode()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Container(
                    width: 180,
                    child: HeaderWidget(
                      title: "Sağlık Durumu",
                      isDarkTeheme: true,
                    ),
                  ),
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
                                "Anket Gönderiliyor...",
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
                    : VerticalSlider(
                        survey: HealthStatus.survey,
                        result: resultMap,
                      ),
                !hasLoading
                    ? OutcomeButton(
                        text: "Durum Bildir",
                        action: () async {
                          setState(() {
                            hasLoading = true;
                          });
                          var status = await SurveyRepository()
                              .sendSurvey(HealthStatus.survey.id, resultMap);
                          setState(() {
                            hasLoading = false;
                          });
                          if (status) {
                            showWarning("Anket başarıyla gönderildi");
                          } else {
                            showWarning(
                                "İşlem sırasında hata oluştu, lütfen tekrar deneyiniz");
                          }
                        },
                      )
                    : Container(),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
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
}
