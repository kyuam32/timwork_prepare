import 'package:flutter/material.dart';
import 'View/RiskControllPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
            child: RiskControllPage()
        ),
      ),
    );
  }
}