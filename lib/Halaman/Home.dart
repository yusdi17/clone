import 'dart:convert';
import 'package:dym/Halaman/commentPage.dart';
import 'package:dym/konstanta.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    var url = Uri.parse('${baseUrl}post'); // Ganti dengan URL API yang benar
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        posts = jsonDecode(response.body);
      });
    } else {
      // Tangani error
      print('Error fetching posts: ${response.statusCode}');
    }
  }

  Future<void> likePost(int postId) async {
    var url = Uri.parse('${baseUrl}like');
    var response = await http.post(url, body: {
      'post_id': postId.toString(),
    });

    if (response.statusCode == 201) {
      // Refresh data posts setelah memberikan like
      fetchPosts();
    } else {
      // Tangani error
      print('Error liking post: ${response.statusCode}');
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
                              child: Text(post['username'][0]),
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
                            ElevatedButton.icon(
                              onPressed: () {
                                likePost(int.parse(post['id']));
                              },
                              icon: Icon(Icons.thumb_up),
                              label: Text('Like (${post['likes_count'] ?? 0})'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentPage(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.comment),
                              label: Text(
                                  'Comment (${post['comments_count'] ?? 0})'),
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
