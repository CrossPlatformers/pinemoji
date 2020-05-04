import 'package:flutter/material.dart';
import 'package:pinemoji/models/survey.dart';
import 'package:pinemoji/repositories/company_repository.dart';
import 'package:pinemoji/repositories/survey_repository.dart';
import 'package:pinemoji/widgets/status-title.dart';
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
    // TODO: implement initState
    SurveyRepository().getOwnData(HealthStatus.survey.id).then((map) => setState(() => resultMap = map));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StatusTitle(
            HealthStatus.survey.info,
            180,
          ),
          VerticalSlider(
            survey: HealthStatus.survey,
            result: resultMap,
          ),
          OutcomeButton(
            text: "Durum Bildir",
            action: () {
              SurveyRepository().sendSurvey(HealthStatus.survey.id, resultMap).then((onValue) => {
                    //TODO: show response
                  });
            },
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
