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
    Result returnData;
    if (query.documents.length > 0) {
      for (DocumentSnapshot snapshot in query.documents) {
        Result data = Result.fromMap(snapshot.data);
        if (returnData == null) {
          returnData = data;
        } else {
          data.questionResultList.forEach((element) {
            Iterable<QuestionResult> qs = returnData.questionResultList.where((e) => e.questionId == element.questionId);
            if (qs.isEmpty) {
              returnData.questionResultList.add(element);
            } else {
              element.answerList.forEach((answer) {
                Iterable<Answer> aList = qs.elementAt(0).answerList.where((e) => e.answerText == answer.answerText);
                if (aList.isEmpty) {
                  qs.elementAt(0).answerList.add(answer);
                } else {
                  aList.elementAt(0).ownerList.addAll(answer.ownerList);
                }
              });
            }
          });
        }
      }
    }
    return returnData;
  }

  Future<bool> sendSurvey(
    String surveyId,
    Map<String, String> questionAnswerMap,
  ) async {
    FirebaseUser user = await AuthenticationService.instance.currentUser();
    String documentId = await getStroedInstance(surveyId);
    DocumentSnapshot snapshot;
    if (documentId != null) {
      snapshot = await Firestore.instance.collection(collectionName).document(documentId).get();
    } else {
      List<DocumentSnapshot> resultList = (await Firestore.instance.collection(collectionName).where("surveyId", isEqualTo: surveyId).getDocuments()).documents;
      if (resultList.length > 0) {
        snapshot = resultList.elementAt(resultList.length - 1);
        Result data = Result.fromMap(snapshot.data);
        int sum = data.questionResultList.fold(0, (sum, element) => sum = sum + element.answerList.fold(0, (aSum, a) => aSum = aSum + a.ownerList.length));
        if (sum > 15000) {
          snapshot = null;
        } else {
          documentId = snapshot.documentID;
        }
      }
    }

    Result result;
    if (snapshot == null || !snapshot.exists) {
      DocumentReference documentReference = Firestore.instance.collection(collectionName).document();
      Survey survey = CompanyRepository().getSurvey();
      result = Result(
          surveyId: surveyId,
          questionResultList: survey.questionList
              .where((element) => questionAnswerMap.keys.contains(element.id))
              .map((q) => QuestionResult(
                    questionId: q.id,
                    questionText: q.description,
                    answerList: q.answerList.where((element) => questionAnswerMap[q.id] == element).isNotEmpty
                        ? q.answerList
                            .where((element) => questionAnswerMap[q.id] == element)
                            .map(
                              (answerText) => Answer(
                                answerText: answerText,
                                emojiText: q.emojiList[q.answerList.indexOf(answerText)],
                                ownerList: {user.uid: AuthenticationService.verifiedUser.extraInfo['location']},
                              ),
                            )
                            .toList()
                        : [
                            Answer(
                              answerText: questionAnswerMap[q.id],
                              emojiText: "😶",
                              ownerList: {user.uid: AuthenticationService.verifiedUser.extraInfo['location']},
                            ),
                          ],
                  ))
              .toList());
      documentId = documentReference.documentID;
      storeOwnData(surveyId, questionAnswerMap, documentId);
      await documentReference.setData(result.toMap());
    } else {
      result = Result.fromMap(snapshot.data);
      result.questionResultList.forEach((res) => res.answerList.forEach((a) => a.ownerList.remove(user.uid)));
      result.questionResultList.forEach((res) => res.answerList.removeWhere((a) => a.ownerList.isEmpty));
      result.questionResultList.forEach((res) => {
            if (questionAnswerMap[res.questionId] != null)
              if (res.answerList.where((element) => element.answerText == questionAnswerMap[res.questionId]).isEmpty)
                {
                  res.answerList.add(
                    Answer(
                      answerText: questionAnswerMap[res.questionId],
                      emojiText: "😶",
                      ownerList: {user.uid: AuthenticationService.verifiedUser.extraInfo['location']},
                    ),
                  )
                }
              else
                {res.answerList.firstWhere((a) => a.answerText == questionAnswerMap[res.questionId]).ownerList[user.uid] = AuthenticationService.verifiedUser.extraInfo['location']}
          });
      storeOwnData(surveyId, questionAnswerMap, documentId);
      await Firestore.instance.collection(collectionName).document(snapshot.documentID).setData(result.toMap());
    }
    return true;
  }

  getStroedInstance(String surveyId) async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    // if (localstorage.containsKey(surveyId + "-instance")) {
    //   return localstorage.getString(surveyId + "-instance");
    // }
    return null;
  }

  storeOwnData(String surveyId, Map<String, String> questionAnswerMap, String instanceId) async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    bool added = await localstorage.setString(surveyId, jsonEncode(questionAnswerMap));
    await localstorage.setString(surveyId + "-instance", instanceId);
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
