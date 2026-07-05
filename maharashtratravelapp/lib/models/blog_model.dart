import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String id;
  final String title;
  final String coverImage;
  final List<dynamic> content;
  final String category;
  final String? relatedPlaceId;
  final String authorId;
  final String authorName;
  final String? authorPhoto;
  final int likes;
  final int comments;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  BlogModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.content,
    required this.category,
    required this.relatedPlaceId,
    required this.authorId,
    required this.authorName,
    required this.authorPhoto,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BlogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data();
    final map = data is Map<String, dynamic> ? data : <String, dynamic>{};

    Timestamp parseTimestamp(dynamic value) {
      if (value is Timestamp) return value;
      if (value is DateTime) return Timestamp.fromDate(value);
      if (value is String) {
        final parsedDate = DateTime.tryParse(value);
        if (parsedDate != null) {
          return Timestamp.fromDate(parsedDate);
        }
      }
      return Timestamp.now();
    }

    return BlogModel(
      id: doc.id,
      title: (map['title'] ?? '').toString(),
      coverImage: (map['coverImage'] ?? '').toString(),
      content: map['content'] is List ? List<dynamic>.from(map['content']) : [],
      category: (map['category'] ?? '').toString(),
      relatedPlaceId: map['relatedPlaceId']?.toString(),
      authorId: (map['authorId'] ?? '').toString(),
      authorName: (map['authorName'] ?? '').toString(),
      authorPhoto: map['authorPhoto']?.toString(),
      likes: int.tryParse(map['likes']?.toString() ?? '') ?? 0,
      comments: int.tryParse(map['comments']?.toString() ?? '') ?? 0,
      createdAt: parseTimestamp(map['createdAt']),
      updatedAt: parseTimestamp(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'coverImage': coverImage,
      'content': content,
      'category': category,
      'relatedPlaceId': relatedPlaceId,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhoto': authorPhoto,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}