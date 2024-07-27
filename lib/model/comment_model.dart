import 'package:hive_flutter/adapters.dart';

part 'comment_model.g.dart';

@HiveType(typeId: 1)
class Comment {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? comment;
  @HiveField(2)
  DateTime? insertTime;
  @HiveField(3)
  String? blogId;

  Comment({this.id, this.comment, this.insertTime, this.blogId});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    insertTime = json['insertTime'];
    blogId = json['blogId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['insertTime'] = insertTime;
    data['blogId'] = blogId;
    return data;
  }
}
