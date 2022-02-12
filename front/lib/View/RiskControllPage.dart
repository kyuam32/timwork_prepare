import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/Model/RiskControllState.dart';
import 'package:front/View/RiskFactorList.dart';
import 'package:provider/provider.dart';
import 'RiskSearchBar.dart';

class RiskControllPage extends StatelessWidget {
  const RiskControllPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RiskControllState>(
      create: (_) => RiskControllState(),
      child: Scaffold(
        appBar: AppBar(title: Text("Hazard Risk Factor analysis")),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
            child: Column(
              children: [
                RiskSearchBar(),
                RiskFactorList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
