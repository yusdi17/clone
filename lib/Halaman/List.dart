import 'package:flutter/material.dart';

class listPage extends StatefulWidget {
  const listPage({Key? key}) : super(key: key);

  @override
  State<listPage> createState() => _listPageState();
}

class _listPageState extends State<listPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text('Dyarimu', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
    );
  }
}
