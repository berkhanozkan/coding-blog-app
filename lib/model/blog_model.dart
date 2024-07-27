import 'package:hive_flutter/adapters.dart';

part 'blog_model.g.dart';

@HiveType(typeId: 0)
class Blog {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? author;
  @HiveField(3)
  DateTime? insertDateTime;
  @HiveField(4)
  String? id;

  Blog(
      {this.title,
      this.description,
      this.author,
      this.insertDateTime,
      required this.id});

  Blog.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    author = json['author'];
    insertDateTime = json['insertDateTime'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['author'] = author;
    data['insertDateTime'] = insertDateTime;
    data['id'] = id;
    return data;
  }
}
