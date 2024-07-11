
import 'dart:convert';

import 'package:dym/konstanta.dart';
import 'package:dym/login_register/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController namaDepanController = TextEditingController();
  TextEditingController namaBelakangController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  Future<void> registerUser() async {
    var url = Uri.parse('${baseUrl}user');

    var response = await http.post(url, body: {
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'nama_depan': namaDepanController.text,
      'nama_belakang': namaBelakangController.text,
      'bio': bioController.text,
    });

    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else if (response.statusCode == 422) {
      var responseData = jsonDecode(response.body);
      var errors = responseData['messages'];
      String errorMessage = "";
      errors.forEach((key, value) {
        errorMessage += key + ": " + value.join(", ") + "\n";
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registrasi Gagal'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registrasi Gagal'),
            content: Text('Terjadi kesalahan saat melakukan registrasi.'),
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
              "Creat Your\nAccount",
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.3,
                right: 35,
                left: 35),
            child: Wrap(
              runSpacing: 30,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email Address",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                TextField(
                  controller: namaDepanController,
                  decoration: InputDecoration(
                    hintText: "Nama Depan",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                TextField(
                  controller: namaBelakangController,
                  decoration: InputDecoration(
                    hintText: "Nama Belakang",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                TextField(
                  controller: bioController,
                  decoration: InputDecoration(
                    hintText: "Bio",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(300, 50),
                    ),
                    onPressed: registerUser,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
