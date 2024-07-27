import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:turff_coding/model/blog_model.dart';
import 'package:turff_coding/model/comment_model.dart';
import 'package:uuid/uuid.dart';

import '../service/comment_service.dart';

class BlogView extends StatefulWidget {
  const BlogView({Key? key, required this.blog}) : super(key: key);

  final Blog blog;

  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, box, child) {
        if (box is Box<Comment>) {
          var comments = box.values
              .toList()
              .where((element) => element.blogId == widget.blog.id)
              .toList();

          comments.sort((a, b) => b.insertTime!.compareTo(a.insertTime!));

          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Article Detail'),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SizedBox(
                      height: 700,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildTitle(),
                          Text(widget.blog.description!),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildAuthorAndDateTime(),
                          const SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                              controller: controller,
                              maxLines: 6,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Add Comment",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                CommentService.instance.service.create(Comment(
                                    comment: controller.text,
                                    id: const Uuid().v1(),
                                    blogId: widget.blog.id,
                                    insertTime: DateTime.now()));
                              },
                              child: const Text("Send")),
                          const SizedBox(
                            height: 20,
                          ),

                          /// article comments
                          Expanded(
                            child: comments.isNotEmpty
                                ? ListView.builder(
                                    itemCount: comments.length,
                                    itemBuilder: (context, index) {
                                      var com = comments[index];
                                      return ListTile(
                                        title: Text(com.comment!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                        subtitle: Text(
                                            DateFormat('yyyy-MM-dd kk:mm:ss')
                                                .format(com.insertTime!)),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text(
                                      "No comments",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      valueListenable: CommentService.instance.listen,
    );
  }

  Row _buildAuthorAndDateTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.blog.author!,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        Text(
          DateFormat('yyyy-MM-dd kk:mm:ss').format(widget.blog.insertDateTime!),
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
        ),
      ],
    );
  }

  Text _buildTitle() {
    return Text(
      widget.blog.title!,
      style: const TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
    );
  }
}
