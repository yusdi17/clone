import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditPostPage extends StatefulWidget {
  final int postId;
  final String judul;
  final String diary;

  const EditPostPage({
    Key? key,
    required this.postId,
    required this.judul,
    required this.diary,
  }) : super(key: key);

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late TextEditingController _judulController;
  late TextEditingController _diaryController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.judul);
    _diaryController = TextEditingController(text: widget.diary);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _diaryController.dispose();
    super.dispose();
  }

  void updatePost() async {
  setState(() {
    isLoading = true;
  });

  var uri = Uri.parse('https://932c-36-73-34-14.ngrok-free.app/post/${widget.postId}');
  var response = await http.put(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      'judul': _judulController.text,
      'diary': _diaryController.text,
    }),
  );

  setState(() {
    isLoading = false;
  });

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post berhasil diupdate')),
    );
    // Kembali ke halaman sebelumnya dengan nilai true
    Navigator.pop(context, true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal update post: ${response.statusCode}')),
    );
    // Debug untuk melihat detail respons dari server
    print('Response body: ${response.body}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _judulController,
                    decoration: InputDecoration(labelText: 'Judul'),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _diaryController,
                    maxLines: 5,
                    decoration: InputDecoration(labelText: 'Diary'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: updatePost,
                    child: Text('Update Post'),
                  ),
                ],
              ),
            ),
    );
  }
}
