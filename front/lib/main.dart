import 'package:flutter/material.dart';
import './View/RiskcheckDemo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Process Risk Check',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: MyHomePage(title: "Process Risk Check Demo"));

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print("hello")
      //   },
      // ),
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
          child: RiskcheckDemo()
      ),
    );
  }
}