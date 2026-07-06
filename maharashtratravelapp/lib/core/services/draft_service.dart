import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/blog_model.dart';

class DraftService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> saveDraft(BlogModel draft) async {
    await firestore
        .collection("drafts")
        .doc(draft.id)
        .set(draft.toMap(), SetOptions(merge: true));
  }

  Future<void> updateDraft(BlogModel draft) async {
    await firestore
        .collection("drafts")
        .doc(draft.id)
        .update(draft.toMap());
  }

  Future<void> deleteDraft(String draftId) async {
    await firestore
        .collection("drafts")
        .doc(draftId)
        .delete();
  }

  Future<void> publishDraft(
    BlogModel draft,
  ) async {
    final batch = firestore.batch();

    final blogRef = firestore
        .collection("blogs")
        .doc(draft.id);

    final draftRef = firestore
        .collection("drafts")
        .doc(draft.id);

    batch.set(blogRef, draft.toMap());

    batch.delete(draftRef);

    await batch.commit();
  }
}