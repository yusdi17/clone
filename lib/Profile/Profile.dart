import 'package:dym/login_register/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HalamanProfile(),
    );
  }
}

class HalamanProfile extends StatefulWidget {
  @override
  _HalamanProfileState createState() => _HalamanProfileState();
}

class _HalamanProfileState extends State<HalamanProfile> {
  String username = '';
  String namaDepan = '';
  String namaBelakang = '';
  String bio = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      namaDepan = prefs.getString('namaDepan') ?? '';
      namaBelakang = prefs.getString('namaBelakang') ?? '';
      bio = prefs.getString('bio') ?? '';
    });
  }

  Future<void> _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (Route<dynamic> route) => false,
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Sign Out'),
          content: Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop(); 
                _signOut(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Text(
                  namaDepan.isNotEmpty ? namaDepan[0] : '',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '$namaDepan $namaBelakang',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                bio,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _confirmSignOut(); 
                },
                child: Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}