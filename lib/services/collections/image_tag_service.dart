import 'package:cloud_firestore/cloud_firestore.dart';

import 'image_tag.dart';

class ImageTagService {
  final _ref =
      FirebaseFirestore.instance.collection('tags');

  Future<List<ImageTag>> getAllTags() async {
    final result = await _ref
        .where("deleted", isEqualTo: false)
        .get();

    List<ImageTag> causes = result.docs
        .map((e) => ImageTag.fromMap(id: e.id, map: e.data()))
        .toList();

    return causes;
  }

  Future<ImageTag?> getTagById(String deathId) async {
    final data = await _ref
        .doc(deathId)
        .get();
    if (data.exists) {
      return ImageTag.fromMap(id: data.id, map: data.data()!);
    }
    return null;
  }

  Future<bool> addTag(
    // 1 - tạo thành công
    // 0 - that bai
    ImageTag death
  ) async {
    try {
      final countExistedName =
          await countExistingNames(death.name.trim());
      if (countExistedName > 0) {
        return false;
      }
      await _ref.add(death.toMap());
      return true;
    } catch (_) {
      return false;
    }
  }
  
  Future<int> countExistingNames(String tagName) async {
    // xóa lẫn thường, có trùng tên là lấy
    // Trả về pair, số name đã xóa, số name còn sống
    final result = await _ref
        .where("name", isEqualTo: tagName)
        .get();
    int countDeleted = 0;
    int countUndeleted = 0;
    for (var doc in result.docs) {
      if (doc['deleted'] ?? false) {
        countDeleted++;
      } else {
        countUndeleted++;
      }
    }
    return countDeleted + countUndeleted;
  }

  Future<int> updateTag(
    ImageTag tag, {
    Map<String, dynamic>? updateData,
  }) async {
    if (updateData != null) {
      await _ref.doc(tag.id).update(updateData);
    } else {
      await _ref.doc(tag.id).update(tag.toMap());
    }
    return 1;
  }

  Future<int> deleteTag(
    ImageTag tag
  ) async {
    final res = await updateTag(
      tag,
      updateData: {"deleted": true});
    return res;
  }

  Stream<List<ImageTag>> tagStream() => FirebaseFirestore.instance
      .collection('tags')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => ImageTag.fromMap(id: doc.id, map: doc.data())).toList());
}
