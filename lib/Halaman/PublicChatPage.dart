import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dym/konstanta.dart'; // Pastikan konstanta.dart memiliki baseUrl yang benar
import 'package:shared_preferences/shared_preferences.dart';

class PublicChatPage extends StatefulWidget {
  const PublicChatPage({Key? key}) : super(key: key);

  @override
  State<PublicChatPage> createState() => _PublicChatPageState();
}

class _PublicChatPageState extends State<PublicChatPage> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController messageController = TextEditingController();
  late int userId;

  @override
  void initState() {
    super.initState();
    fetchUserId();
    fetchMessages();
  }

  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
  }

  void fetchMessages() async {
    var response = await http.get(Uri.parse('$baseUrl/chat'));
    if (response.statusCode == 200) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      // Handle error
      print('Failed to load messages');
    }
  }

  void sendMessage() async {
    if (messageController.text.isEmpty) return;

    var response = await http.post(
      Uri.parse('$baseUrl/chat'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'user_id': userId,
        'chat': messageController.text,
      }),
    );

    if (response.statusCode == 201) {
      fetchMessages(); // Refresh messages
      messageController.clear();
    } else {
      // Handle error
      print('Failed to send message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Public Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]['chat']),
                  subtitle: Text('User ID: ${messages[index]['user_id']}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
