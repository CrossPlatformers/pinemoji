import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinemoji/models/request.dart';

class RequestRepository {
  final String collectionName = 'request';

  Future<List<Request>> getRequestList({
    List<String> emojiIdList,
    List<String> optionList,
    String lastSelectedId,
    int limit,
    LatLngBounds latLngBounds,
  }) async {
    List<Request> requestList = [];
    CollectionReference query = Firestore.instance.collection(collectionName);
    if (emojiIdList != null && emojiIdList.isNotEmpty) {
      query = query.where(
        'emoji',
        whereIn: emojiIdList,
      );
    }
    if (optionList != null && optionList.isNotEmpty) {
      query = query.where(
        'option',
        whereIn: optionList,
      );
    }
    if (lastSelectedId != null)
      query.startAfterDocument(await Firestore.instance
          .collection(collectionName)
          .document(lastSelectedId)
          .get());
    if (latLngBounds != null) {
      query.where(
        'location',
        isGreaterThanOrEqualTo: GeoPoint(
          latLngBounds.northeast.latitude,
          latLngBounds.northeast.longitude,
        ),
      );
      query.where(
        'location',
        isLessThanOrEqualTo: GeoPoint(
          latLngBounds.southwest.latitude,
          latLngBounds.southwest.longitude,
        ),
      );
    }
    if (limit != null) {
      query.limit(limit);
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
    CollectionReference query = Firestore.instance.collection(collectionName);
    query = query.where('ownerId');
    var querySnapshot = await query.getDocuments();
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
          Firestore.instance.collection(collectionName).document();
      await documentReference.updateData(request.toMap());
      return documentReference;
    }
  }

  Future<List<DocumentReference>> addRequestList(
    List<Request> requestList,
  ) async {
    List<DocumentReference> resultList = [];
    for (Request r in requestList) {
      resultList.add(await addRequest(r));
    }
    return resultList;
  }
}
