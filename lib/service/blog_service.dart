import 'package:flutter/foundation.dart';
import '../store/blog_store.dart';

class BlogService {
  late final BlogStore _blogStore;

  BlogService() {
    _blogStore = BlogStore();
  }

  static BlogService instance = BlogService();

  BlogStore get service => _blogStore;

  ValueListenable get listen => service.listen();
}
