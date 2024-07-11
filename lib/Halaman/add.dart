import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dym/konstanta.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _diaryController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();

   Future<void> _submitPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    print('userId: $userId');
    
    if (userId == null) {
      // Handle error if user is not logged in
      return;
    }

    var url = Uri.parse('${baseUrl}post');
    var response = await http.post(url, body: {
      'user_id':  userId.toString(),
      'diary': _diaryController.text,
      'judul': _judulController.text,
    });

    if (response.statusCode == 201) {
      // Post berhasil
      Navigator.of(context).pop();
    } else {
      // Handle error
      var error = jsonDecode(response.body)['messages'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text("DyariMu"),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
          iconSize: 30,
        ),
        actions: [
          IconButton(
            onPressed: _submitPost,
            icon: Icon(Icons.check),
            iconSize: 30,     
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              decoration: InputDecoration(
                hintText: 'Judul',
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _diaryController,
                decoration: InputDecoration(
                  hintText: 'Mulai mengetik diarymu...',
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
