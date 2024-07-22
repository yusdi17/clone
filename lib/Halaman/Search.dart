import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  List _searchResults = [];

  Future<void> _searchUsers(String username) async {
    var uri = Uri.parse('https://932c-36-73-34-14.ngrok-free.app/users/search?username=$username');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      setState(() {
        _searchResults = responseData;
      });
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _searchUsers(_controller.text);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  var user = _searchResults[index];
                  return ListTile(
                    title: Text('@${user['username']}'),
                    subtitle: Text('${user['nama_depan']} ${user['nama_belakang']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
