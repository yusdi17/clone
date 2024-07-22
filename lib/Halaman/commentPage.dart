import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentPage extends StatefulWidget {
  final int postId;

  const CommentPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();
  List _comments = [];
  late int userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserId();
    fetchComments();
  }

  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? 0;
    });
    fetchComments(); // Pindahkan fetchComments ke sini agar userId sudah di-fetch terlebih dahulu
  }

  Future<void> fetchComments() async {
    var uri = Uri.parse('https://932c-36-73-34-14.ngrok-free.app/comment');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      setState(() {
        _comments = responseData;
        _isLoading = false;
      });

      print(_comments);
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> postComment() async {
    var uri = Uri.parse('https://932c-36-73-34-14.ngrok-free.app/comment');
    var response = await http.post(
      uri,
      body: jsonEncode({
        'created_by_user_id': userId,
        'post_id': widget.postId,
        'comment': commentController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Komentar Berhasil Dikirim')),
      );
      // Kosongkan field komentar
      commentController.clear();

      // Ambil ulang daftar komentar setelah menambah komentar baru
      fetchComments();
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Komentar'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        var comment = _comments[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment['comment'],
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 8.0),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: commentController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    hintText: 'Tulis Komentar Anda',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: postComment,
                                tooltip: 'Simpan',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}