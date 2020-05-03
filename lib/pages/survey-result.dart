import 'package:flutter/material.dart';
import 'package:pinemoji/models/answer.dart';
import 'package:pinemoji/models/question_result.dart';
import 'package:pinemoji/models/result.dart';
import 'package:pinemoji/widgets/header-widget.dart';
import 'package:pinemoji/widgets/survey-card.dart';
import 'package:pinemoji/widgets/survey-filter-item.dart';

class SurveyResultPage extends StatefulWidget {
  @override
  _SurveyResultPageState createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends State<SurveyResultPage> {
  QuestionResult selectedQuestion;
  final Result result = Result(surveyId: "", questionResultList: [
    QuestionResult(
        questionText: "Şu ana kadar COVID-19 tanısı aldınız mı?",
        answerList: [
          Answer(
            answerText: "Hayır",
            emojiText: "😊",
            ownerList: {
              "1": "location_1",
              "2": "location_2",
              "3": "location_1",
              "4": "location_3",
              "5": "location_1",
              "6": "location_3",
              "7": "location_1",
              "8": "location_2"
            },
          ),
          Answer(
            answerText: "Evet, test sonucum pozitif çıktı",
            emojiText: "😒",
            ownerList: {"1": "location_1", "2": "location_2"},
          ),
          Answer(
            answerText: "Evet, test sonucum negatifti ama BT sonucuma göre",
            emojiText: "😐",
            ownerList: {"1": "location_1", "3": "location_1"},
          )
        ]),
    QuestionResult(
        questionText: "COVID-19 nedeniyle uygulanan tedavi",
        answerList: [
          Answer(
            answerText: "Tanı Almadım",
            emojiText: "😊",
            ownerList: {"1": "location_1", "2": "location_1"},
          ),
          Answer(
            answerText: "Hastalığı evde ilaç alarak geçirdim",
            emojiText: "😷",
            ownerList: {"1": "location_1", "2": "location_1"},
          ),
          Answer(
            answerText: "Serviste yatarak tedavi gördüm",
            emojiText: "🤒",
            ownerList: {"1": "location_2", "2": "location_2"},
          ),
          Answer(
            answerText: "Yoğun bakımda yatarak tedavi gördüm",
            emojiText: "😶",
            ownerList: {"1": "location_1", "2": "location_2"},
          ),
          Answer(
            answerText: "Entübe edildim",
            emojiText: "🤢",
            ownerList: {"1": "location_1", "2": "location_2"},
          ),
        ]),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Container(
                width: 120,
                child: HeaderWidget(
                  title: "Anketler",
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                  maxHeight: selectedQuestion != null
                      ? MediaQuery.of(context).size.height / 2 - 50
                      : MediaQuery.of(context).size.height - 50),
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                mainAxisSpacing: 40,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                children: result.questionResultList.map((question) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedQuestion == question) {
                          selectedQuestion = null;
                        } else {
                          selectedQuestion = question;
                        }
                      });
                    },
                    child: SurveyCard(
                      selectedQuestion: selectedQuestion,
                      question: question,
                    ),
                  );
                }).toList(),
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
      ),
    );
  }

  List<Answer> groupByAnswer(List<Answer> answerList) {
    Map<String, Map<String, Answer>> resultMap = {};
    List<Answer> reslutList = [];
    answerList.forEach((answer) {
      if(resultMap[answer.answerText] == null) {
        resultMap[answer.answerText] = {};
      }
      answer.ownerList.forEach((owner, location) {
        if (resultMap[location] == null) {
          resultMap[answer.answerText][location] = answerFromJson(answerToJson(answer));
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
