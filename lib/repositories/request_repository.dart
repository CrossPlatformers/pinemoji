import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinemoji/models/request.dart';
import 'package:pinemoji/services/authentication-service.dart';

class RequestRepository {
  final String collectionName = 'request';

  Future<List<Request>> getRequestList({
    List<String> emojiIdList,
    String option,
    String lastSelectedId,
    int limit = 15,
    LatLngBounds latLngBounds,
  }) async {
    List<Request> requestList = [];
    Query query = Firestore.instance.collection(collectionName).limit(limit);
    if (emojiIdList != null && emojiIdList.isNotEmpty) {
      query = query.where(
        'emoji',
        whereIn: emojiIdList,
      );
    }
    if (option != null) {
      query = query.where(
        'option',
        isEqualTo: option,
      );
    }
    if (lastSelectedId != null)
      query = query.startAfterDocument(await Firestore.instance
          .collection(collectionName)
          .document(lastSelectedId)
          .get());
    if (latLngBounds != null) {
      query = query
          .where(
            'location',
            isLessThanOrEqualTo: GeoPoint(
              latLngBounds.northeast.latitude,
              latLngBounds.northeast.longitude,
            ),
          )
          .where(
            'location',
            isGreaterThanOrEqualTo: GeoPoint(
              latLngBounds.southwest.latitude,
              latLngBounds.southwest.longitude,
            ),
          );
    }
    var querySnapshot = await query.getDocuments();
    if (querySnapshot != null && querySnapshot.documents.isNotEmpty) {
      for (DocumentSnapshot snapshot in querySnapshot.documents) {
        requestList.add(Request.fromSnapshot(snapshot));
      }
    }
    return requestList;
  }

  Future<List<Request>> getMyRequests() async {
    List<Request> requestList = [];
    var querySnapshot = await Firestore.instance
        .collection(collectionName)
        .where('ownerId', isEqualTo: AuthenticationService.verifiedUser.id)
        .getDocuments();
    if (querySnapshot != null && querySnapshot.documents.isNotEmpty) {
      for (DocumentSnapshot snapshot in querySnapshot.documents) {
        requestList.add(Request.fromSnapshot(snapshot));
      }
    }
    return requestList;
  }

  Future<DocumentReference> addRequest(
    Request request,
  ) async {
    if (request.id == null) {
      DocumentReference documentReference =
          Firestore.instance.collection(collectionName).document();
      request.id = documentReference.documentID;
      await documentReference.setData(request.toMap());
      return documentReference;
    } else {
      DocumentReference documentReference =
          Firestore.instance.collection(collectionName).document(request.id);
      await documentReference.setData(request.toMap());
      return documentReference;
    }
  }

  Future<bool> addRequestList(
    List<Request> requestList,
  ) async {
    List<DocumentReference> resultList = [];
    for (Request r in requestList) {
      resultList.add(await addRequest(r));
    }
    return resultList.length > 0;
  }
}
