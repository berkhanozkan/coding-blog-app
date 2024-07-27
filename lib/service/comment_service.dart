import 'package:flutter/foundation.dart';
import '../store/comment_store.dart';

class CommentService {
  late final CommentStore _commentStore;

  CommentService() {
    _commentStore = CommentStore();
  }

  static CommentService instance = CommentService();

  CommentStore get service => _commentStore;

  ValueListenable get listen => service.listen();
}
