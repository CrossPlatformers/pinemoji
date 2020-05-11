import 'package:flutter/material.dart';
import 'package:pinemoji/models/answer.dart';

class SurveyFilterItem extends StatelessWidget {
  SurveyFilterItem({@required this.surveyAnswer});
  final Answer surveyAnswer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.asset(
                        "assets/red-pin.png",
                        width: 24,
                      ),
                      Positioned(
                        top: 2,
                        left: 7,
                        child: Text(
                          "H",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 160,
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      surveyAnswer.ownerList.values.first,
                      softWrap: true,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      surveyAnswer.emojiText.isNotEmpty
                          ? surveyAnswer.emojiText
                          : " ",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          surveyAnswer.answerText,
                          softWrap: true,
                          textWidthBasis: TextWidthBasis.parent,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: <Widget>[
                    Text(
                      surveyAnswer.ownerList.length.toString(),
                      style: TextStyle(
                        fontSize: 28,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    Text(
                      "Doktor",
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
