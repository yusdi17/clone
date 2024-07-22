import 'dart:convert';
import 'package:dym/Halaman/EditPostPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dym/konstanta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List posts = [];
  late int userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? 0;
    });
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    var url = Uri.parse('${baseUrl}postsByUser/$userId');
    print('Fetching posts from: $url');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        posts = jsonDecode(response.body);
      });
    } else {
      print('Error fetching posts: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> deletePost(int postId) async {
    var url = Uri.parse('${baseUrl}post/$postId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      setState(() {
        posts.removeWhere((post) => post['id'] == postId);
      });
    } else {
      print('Error deleting post: ${response.statusCode}');
    }
  }

  Future<void> navigateToEditPage(Map post) async {
  var postId = int.parse(post['id']); // Pastikan postId adalah Integer
  bool? result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditPostPage(
        postId: postId,
        judul: post['judul'],
        diary: post['diary'],
      ),
    ),
  );

  if (result == true) {
    fetchPosts();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dyarimu"),
        automaticallyImplyLeading: false,
      ),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var post = posts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Text(post['username'][0]), // Inisial username
                            ),
                            SizedBox(width: 10),
                            Text(
                              post['username'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          post['judul'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(post['diary']),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                navigateToEditPage(post);
                              },
                              child: Text('Edit'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                deletePost(int.parse(post['id']));
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
