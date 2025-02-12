import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserModel {
  final String email;
  final String uid;
  final String username;

  const MyUserModel(
      {required this.username, required this.uid, required this.email});

  static MyUserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MyUserModel(
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"]);
  }

  Map<String, dynamic> toJson() =>
      {"username": username, "uid": uid, "email": email};
}
