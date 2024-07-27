import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:turff_coding/service/blog_service.dart';
import 'package:uuid/uuid.dart';
import '../model/blog_model.dart';
import '../service/dio_service.dart';
import 'blog_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<void> getAndSaveBlogInit() async {
    var blogResult = await DioService.instance.service
        .get('api/?type=meat-and-filler&paras=10');
    List<dynamic> jsonList = blogResult.data;
    List<String> blogList = jsonList.map((item) => item.toString()).toList();

    List<Blog> blogs = blogList.map((item) {
      return Blog(
        id: Uuid().v1(),
        title: item.split(' ').take(3).join(' '),
        description: item,
        author:
            '${RandomNames(Zone.us).name()} ${RandomNames(Zone.us).surname()}',
        insertDateTime: DateTime.now(),
      );
    }).toList();

    blogs.forEach((blog) async {
      await BlogService.instance.service.create(blog);
    });
  }

  @override
  void initState() {
    getAndSaveBlogInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: BlogService.instance.listen,
        builder: (context, box, child) {
          if (box is Box<Blog>) {
            var blogs = box.values.toList();

            blogs
                .sort((a, b) => b.insertDateTime!.compareTo(a.insertDateTime!));

            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      getAndSaveBlogInit();
                    },
                  ),
                  title: const Text('Turff Blog'),
                ),
                body: _buildBody(blogs));
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Turff Blog'),
              ),
              body: const Center(
                child: Text('Error'),
              ),
            );
          }
        });
  }

  SizedBox _buildBody(List<Blog> blogs) {
    return SizedBox(
      height: 700,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: blogs.length,
        itemBuilder: blogs.isNotEmpty
            ? (context, index) {
                var blog = blogs[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => BlogView(blog: blog))),
                  child: Dismissible(
                    key: Key(blog.id!),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      BlogService.instance.service.delete(blog.id!);
                    },
                    background: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10),
                        Text("Swipe to delete",
                            style: TextStyle(color: Colors.grey))
                      ],
                    ),
                    child: _buildArticleCard(blog),
                  ),
                );
              }
            : (context, index) => const Center(
                  child: Text('No Data'),
                ),
      ),
    );
  }

  Padding _buildArticleCard(Blog blog) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.blue.shade50),
        child: ListTile(
          title: Text(
            blog.title!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            children: [
              Text("${blog.description!.split('.').take(2).join('. ')}."),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(blog.author!),
                  Text(
                    DateFormat('yyyy-MM-dd kk:mm:ss')
                        .format(blog.insertDateTime!),
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 10),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
