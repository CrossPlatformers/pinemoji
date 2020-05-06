import 'package:flutter/material.dart';
import 'package:pinemoji/models/question_result.dart';

class SurveyCard extends StatelessWidget {
  const SurveyCard({
    Key key,
    @required this.selectedQuestion,
    @required this.question,
  }) : super(key: key);

  final QuestionResult selectedQuestion;
  final QuestionResult question;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:
          selectedQuestion == null || question == selectedQuestion ? 1 : 0.4,
      child: Card(
        elevation: 5,
        color: Theme.of(context).primaryColorLight.withOpacity(.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: question == selectedQuestion
                ? Theme.of(context).highlightColor
                : Theme.of(context).cardColor,
            width: 3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                question.answerList
                    .fold(0, (sum, answer) => sum + answer.ownerList.length)
                    .toString(),
                style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).primaryColorDark,
                  shadows: [
                    Shadow(
                      color: Theme.of(context).highlightColor,
                      offset: Offset.zero,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              Text(
                "Doktor Yanıtladı",
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).primaryColorDark,
                  shadows: [
                    Shadow(
                      color: Theme.of(context).highlightColor,
                      offset: Offset.zero,
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    question.questionText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).cardColor, fontSize: 12),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
