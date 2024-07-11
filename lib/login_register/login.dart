import 'dart:convert';

import 'package:dym/Navigation.dart';
import 'package:dym/konstanta.dart';
import 'package:dym/login_register/register.dart';
import 'package:dym/login_register/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    var url = Uri.parse('${baseUrl}user/login');

    var response = await http.post(url, body: {
      'username': usernameController.text,
      'password': passwordController.text,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var user = responseData['data'];

      // Simpan data pengguna ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = int.parse(user['id'] ?? '0');
      print('user_id: $userId'); // Tambahkan print statement
      await prefs.setInt('userId', userId);
      await prefs.setString('username', user['username']);
      await prefs.setString('namaDepan', user['nama_depan']);
      await prefs.setString('namaBelakang', user['nama_belakang']);
      await prefs.setString('bio', user['bio']);

      // Login berhasil, navigasi ke halaman home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navigation()),
      );
    } else {
      // Handle error jika login gagal
      var responseData = jsonDecode(response.body);
      var errorMessage =
          responseData['message'] ?? 'Login gagal. Silakan coba lagi.';

      // Tampilkan dialog dengan pesan error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Gagal'),
            content: Text(errorMessage),
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
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              "Welcome\nBack,\nScribbler!",
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.4,
                  right: 35,
                  left: 35),
              child: Column(
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "Username",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber),
                      onPressed: loginUser,
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ),
                        );
                      },
                      child: Text("Create New Account"),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
