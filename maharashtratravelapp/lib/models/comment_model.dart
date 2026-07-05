import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String userName;
  final String? userPhoto;
  final String comment;
  final Timestamp createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.comment,
    required this.createdAt,
  });

  factory CommentModel.fromFirestore(
      DocumentSnapshot doc) {
    final data =
        doc.data() as Map<String, dynamic>;

    return CommentModel(
      id: doc.id,
      userId: data["userId"],
      userName: data["userName"],
      userPhoto: data["userPhoto"],
      comment: data["comment"],
      createdAt: data["createdAt"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "userName": userName,
      "userPhoto": userPhoto,
      "comment": comment,
      "createdAt": createdAt,
    };
  }
}