import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/blog_model.dart';
import '../../models/comment_model.dart';
class BlogService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String collection = "blogs";

  /// Publish Blog
  Future<void> publishBlog(
      BlogModel blog) async {
    await _firestore
        .collection(collection)
        .doc(blog.id)
        .set(blog.toMap());
  }
Future<bool> isLiked(
  String blogId,
  String userId,
) async {
  final doc = await _firestore
      .collection(collection)
      .doc(blogId)
      .collection("likes")
      .doc(userId)
      .get();

  return doc.exists;
}

Future<void> toggleLike(
  String blogId,
  String userId,
) async {

  final blogRef =
      _firestore.collection(collection).doc(blogId);

  final likeRef =
      blogRef.collection("likes").doc(userId);

  final like =
      await likeRef.get();

  if (like.exists) {

    await likeRef.delete();

    await blogRef.update({
      "likes": FieldValue.increment(-1),
    });

  } else {

    await likeRef.set({
      "likedAt": Timestamp.now(),
    });

    await blogRef.update({
      "likes": FieldValue.increment(1),
    });

  }
}
Stream<List<CommentModel>> getComments(
    String blogId) {
  return _firestore
      .collection(collection)
      .doc(blogId)
      .collection("comments")
      .orderBy(
        "createdAt",
        descending: true,
      )
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (e) =>
                  CommentModel.fromFirestore(e),
            )
            .toList(),
      );
}

Future<void> addComment({
  required String blogId,
  required CommentModel comment,
}) async {
  await _firestore
      .collection(collection)
      .doc(blogId)
      .collection("comments")
      .doc(comment.id)
      .set(comment.toMap());

  await _firestore
      .collection(collection)
      .doc(blogId)
      .update({
    "comments":
        FieldValue.increment(1),
  });
}

Future<void> deleteComment({
  required String blogId,
  required String commentId,
}) async {
  await _firestore
      .collection(collection)
      .doc(blogId)
      .collection("comments")
      .doc(commentId)
      .delete();

  await _firestore
      .collection(collection)
      .doc(blogId)
      .update({
    "comments":
        FieldValue.increment(-1),
  });
}
  /// Update Blog
  Future<void> updateBlog(
      BlogModel blog) async {
    await _firestore
        .collection(collection)
        .doc(blog.id)
        .update(blog.toMap());
  }

  /// Delete Blog
  Future<void> deleteBlog(
      String blogId) async {
    await _firestore
        .collection(collection)
        .doc(blogId)
        .delete();
  }

  /// All Blogs
  Stream<List<BlogModel>> getBlogs() {
    return _firestore
        .collection(collection)
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) =>
                  BlogModel.fromFirestore(doc),
            )
            .toList();
      },
    );
  }

  /// Related Blogs
  Stream<List<BlogModel>> getRelatedBlogs(
      String placeId) {
    return _firestore
        .collection(collection)
        .where(
          "relatedPlaceId",
          isEqualTo: placeId,
        )
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) =>
                  BlogModel.fromFirestore(doc),
            )
            .toList();
      },
    );
  }

  /// Single Blog
  Future<BlogModel> getBlog(
      String id) async {
    final doc = await _firestore
        .collection(collection)
        .doc(id)
        .get();

    return BlogModel.fromFirestore(doc);
  }
}