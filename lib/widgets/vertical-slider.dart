import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/models/survey.dart';
import 'package:pinemoji/widget-controllers/health-widget-controller.dart';

import 'health-widget.dart';

class VerticalSlider extends StatelessWidget {
  final Survey survey;
  final Map<String, String> result;
  VerticalSlider({this.survey, this.result});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: CarouselSlider(
        carouselController: CarouselController(),
        options: CarouselOptions(
          height: size.height - 240,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
        ),
        items: survey.questionList
            .map((question) => Padding(
                  padding: const EdgeInsets.fromLTRB(4, 45, 4, 20),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 3,
                          color: Colors.white38,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 15, 18, 18),
                            child: Text(
                              question.description,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          SingleChildScrollView(
                            child: HealthWidgetController(
                              questionId: question.id,
                              resultMap: result,
                              healthStatusModelList: [
                                ...question.answerList
                                    .map((answer) => HealthStatusModel(
                                          question.emojiList[question.answerList
                                              .indexOf(answer)],
                                          answer,
                                        )),
                                if (question.type == "TEXT" &&
                                    question.answerList.isNotEmpty)
                                  HealthStatusModel(
                                    "😶",
                                    "Diğer",
                                    hintText: result != null && !question.answerList.contains(result[question.id]) ? result[question.id] : null,
                                    isOther: true,
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
