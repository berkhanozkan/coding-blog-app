import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:turff_coding/store/main_store.dart';
import '../model/blog_model.dart';

class BlogStore implements IMainStore<Blog> {
  static const _boxName = "blogBox";
  final Box<Blog> _box = Hive.box<Blog>(_boxName);

  @override
  Future<void> create(Blog item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<Blog> get(String id) {
    return Future.value(_box.get(id));
  }

  @override
  Future<List<Blog>> getAll() {
    return Future.value(_box.values.toList());
  }

  @override
  Future<void> update(Blog item) async {
    await _box.put(item.id, item);
  }

  ValueListenable<Box<Blog>> listen() {
    return _box.listenable();
  }
}
