import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinemoji/models/answer.dart';
import 'package:pinemoji/models/question_result.dart';
import 'package:pinemoji/models/result.dart';
import 'package:pinemoji/models/survey.dart';
import 'package:pinemoji/repositories/company_repository.dart';
import 'package:pinemoji/services/authentication-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveyRepository {
  final String collectionName = 'survey_result';
  Future<Result> getSurveyResult() async {
    Survey survey = CompanyRepository().getSurvey();
    var query = await Firestore.instance.collection(collectionName).where("surveyId", isEqualTo: survey.id).getDocuments();
    var querySnapshot = query.documents.elementAt(0);
    return Result.fromMap(querySnapshot.data);
  }

  Future<void> sendSurvey(
    String surveyId,
    Map<String, String> questionAnswerMap,
  ) async {
    FirebaseUser user = await AuthenticationService.instance.currentUser();
    List<DocumentSnapshot> resultList = (await Firestore.instance.collection(collectionName).where("surveyId", isEqualTo: surveyId).getDocuments()).documents;
    DocumentSnapshot snapshot;
    if (resultList.length > 0) {
      snapshot = resultList.elementAt(0);
    }
    DocumentReference documentReference = Firestore.instance.collection(collectionName).document();
    storeOwnData(surveyId, questionAnswerMap);
    Result result;
    if (snapshot == null || !snapshot.exists) {
      Survey survey = CompanyRepository().getSurvey();
      result = Result(
          surveyId: surveyId,
          questionResultList: survey.questionList
              .map((q) => QuestionResult(
                    questionId: q.id,
                    questionText: q.description,
                    answerList: q.answerList
                        .map(
                          (answerText) => Answer(
                            answerText: answerText,
                            emojiText: q.emojiList[q.answerList.indexOf(answerText)],
                            ownerList: {user.uid: "9 Eylül Üniversitesi Hastanesi"},
                          ),
                        )
                        .toList(),
                  ))
              .toList());
      await documentReference.setData(result.toMap());
    } else {
      result = Result.fromMap(snapshot.data);
      result.questionResultList.forEach((res) => res.answerList.forEach((a) => a.ownerList.remove(user.uid)));
      result.questionResultList.forEach((res) => {
            if (questionAnswerMap[res.questionId] != null)
              res.answerList.firstWhere((a) => a.answerText == questionAnswerMap[res.questionId]).ownerList[user.uid] = "9 Eylül Üniversitesi Hastanesi"
          });
      await documentReference.updateData(result.toMap());
    }
  }

  storeOwnData(String surveyId, Map<String, String> questionAnswerMap) async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    bool added = await localstorage.setString(surveyId, jsonEncode(questionAnswerMap));
    return added;
  }

  Future<Map<String, String>> getOwnData(String surveyId) async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    Map<String, dynamic> res = jsonDecode(localstorage.getString(surveyId) ?? "{}");
    Map<String, String> result = {};
    res.forEach((key, val) => result[key] = val.toString());
    return result;
  }
}
