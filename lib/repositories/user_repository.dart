import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinemoji/models/user-info.dart';
import 'package:pinemoji/models/user.dart';

class UserRepository {
  final String collectionName = 'user';

  Future<DocumentReference> addUser(
    User user,
  ) async {
    if (await isUserNotExist(user.phoneNumber)) {
      DocumentReference documentReference =
          Firestore.instance.collection(collectionName).document();
      documentReference.setData(user.toMap());
      return documentReference;
    }
    UserInfo().init(user);
    return null;
  }

  Future<bool> isUserNotExist(String phoneNumber) async {
    var query = await Firestore.instance
        .collection(collectionName)
        .where("phoneNumber", isEqualTo: phoneNumber)
        .getDocuments();
    return query.documents.length == 0;
  }

  Future<DocumentReference> updateUser(
    User user,
  ) async {
    DocumentReference documentReference =
        Firestore.instance.collection(collectionName).document(user.id);
    documentReference.setData(user.toMap());
    return documentReference;
  }

  Future<User> getUser(String userId) async {
    var query = await Firestore.instance
        .collection(collectionName)
        .where("id", isEqualTo: userId)
        .getDocuments();
    if (query.documents.length > 0) {
      var querySnapshot = query.documents.first;
      return User.fromSnapshot(querySnapshot);
    }
    return null;
  }

  Future<User> getUserByPhone(String phoneNo) async {
    var query = await Firestore.instance
        .collection(collectionName)
        .where("phoneNumber", isEqualTo: phoneNo)
        .getDocuments();
    if (query.documents.length > 0) {
      var querySnapshot = query.documents.first;
      return User.fromSnapshot(querySnapshot);
    }
    return null;
  }
}
