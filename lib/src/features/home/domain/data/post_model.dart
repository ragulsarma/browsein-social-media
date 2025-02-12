import 'package:hive/hive.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
class PostModel extends HiveObject {
  @HiveField(1)
  final String postId;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String postUrl;

  @HiveField(5)
  final List<String> likes;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final DateTime datePublished;

  @HiveField(8)
  bool isLiked = false;

  @HiveField(9)
  final String uid;

  @HiveField(10)
  final bool isPending;

  @HiveField(11)
  final String id;

  PostModel({
    required this.id,
    required this.postId,
    required this.username,
    required this.email,
    required this.postUrl,
    required this.likes,
    required this.description,
    required this.datePublished,
    required this.uid,
    required this.isPending,
    this.isLiked = false,
  });

  factory PostModel.fromMap(Map<String, dynamic> data, String id) {
    return PostModel(
      id: id,
      postId: data['postId'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      postUrl: data['postUrl'] ?? '',
      likes: List<String>.from(data['likes'] ?? []),
      description: data['description'] ?? '',
      datePublished: data['datePublished'] != null
          ? data['datePublished'].toDate()
          : DateTime.now(),
      isLiked: false,
      uid: data['uid'] ?? '',
      isPending: data['isPending'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'username': username,
      'email': email,
      'postUrl': postUrl,
      'likes': likes,
      'description': description,
      'datePublished': datePublished,
      'isLiked': isLiked,
      'uid': uid,
      'isPending': isPending,
    };
  }
}
