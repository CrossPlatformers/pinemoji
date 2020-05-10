import 'package:flutter/material.dart';
import 'package:pinemoji/models/answer.dart';
import 'package:pinemoji/models/question_result.dart';
import 'package:pinemoji/models/result.dart';
import 'package:pinemoji/repositories/survey_repository.dart';
import 'package:pinemoji/widgets/header-widget.dart';
import 'package:pinemoji/widgets/survey-card.dart';
import 'package:pinemoji/widgets/survey-filter-item.dart';

class SurveyResultPage extends StatefulWidget {
  @override
  _SurveyResultPageState createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends State<SurveyResultPage> {
  QuestionResult selectedQuestion;
  Result result;

  @override
  void initState() {
    SurveyRepository()
        .getSurveyResult()
        .then((value) => setState(() => result = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Container(
              width: 200,
              child: HeaderWidget(
                title: "Anket Sonuçları",
                isDarkTeheme: true,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
                maxHeight: selectedQuestion != null
                    ? MediaQuery.of(context).size.height * .34
                    : MediaQuery.of(context).size.height * .65),
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
              mainAxisSpacing: 40,
              crossAxisSpacing: 10,
              childAspectRatio: .7,
              shrinkWrap: true,
              children: [
                if (result != null)
                  ...result.questionResultList.map((question) {
                    final GlobalKey _currentQuestionKey = GlobalKey();
                    return GestureDetector(
                      key: _currentQuestionKey,
                      onTap: () {
                        setState(() {
                          if (selectedQuestion == question) {
                            selectedQuestion = null;
                          } else {
                            selectedQuestion = question;
                            Scrollable.ensureVisible(
                              _currentQuestionKey.currentContext,
                              curve: Curves.easeIn,
                              duration: Duration(
                                milliseconds: 300,
                              ),
                            );
                          }
                        });
                      },
                      child: SurveyCard(
                        selectedQuestion: selectedQuestion,
                        question: question,
                      ),
                    );
                  }).toList()
              ],
            ),
          ),
          if (selectedQuestion != null)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Hastane",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Sağlık Durumu",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Doktor",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: groupByAnswer(selectedQuestion.answerList)
                              .map((answer) => SurveyFilterItem(
                                    surveyAnswer: answer,
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  List<Answer> groupByAnswer(List<Answer> answerList) {
    Map<String, Map<String, Answer>> resultMap = {};
    List<Answer> reslutList = [];
    answerList.forEach((answer) {
      if (resultMap[answer.answerText] == null) {
        resultMap[answer.answerText] = {};
      }
      answer.ownerList.forEach((owner, location) {
        if (resultMap[location] == null) {
          resultMap[answer.answerText][location] =
              answerFromJson(answerToJson(answer));
        }
      });
    });
    resultMap.forEach((ansT, map) {
      map.forEach((loca, answer) {
        answer.ownerList.removeWhere((owner, loc) => loc != loca);
        reslutList.add(answer);
      });
    });
    return reslutList;
  }
}
