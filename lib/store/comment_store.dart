import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:turff_coding/store/main_store.dart';
import '../model/comment_model.dart';

class CommentStore implements IMainStore {
  static const _boxName = "commentBox";
  final Box<Comment> _box = Hive.box<Comment>(_boxName);

  @override
  Future<void> create(item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future get(String id) async {
    return Future.value(_box.get(id));
  }

  @override
  Future<List<Comment>> getAll() async {
    return Future.value(_box.values.toList());
  }

  @override
  Future<void> update(item) async {
    return await _box.put(item.id, item);
  }

  ValueListenable<Box<Comment>> listen() {
    return _box.listenable();
  }
}
