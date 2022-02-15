import 'package:flutter/material.dart';
import 'package:front/Provider/RiskProvider.dart';
import 'package:front/View/List_Factor.dart';
import 'package:front/View/List_mine.dart';
import 'package:provider/provider.dart';
import 'Searchbar_Proc_Task.dart';

class PageMain extends StatelessWidget {
  const PageMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RiskProvider>(
      create: (_) => RiskProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text("Hazard Risk Factor analysis")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(
            slivers: [
              renderSliverList(),
            ],
          ),
        )
      ),
    );
  }
}

renderSliverList(){
  return SliverList(
    delegate: SliverChildListDelegate(
        [
          SearchbarProcTask(),
          ListManages(),
          // ListFactor(),
        ]
    ),
  );
}