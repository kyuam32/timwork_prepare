import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/Model/AjaxButton.dart';
import 'package:front/Provider/RiskProvider.dart';
import 'package:front/View/List_Factor_Manage.dart';
import 'package:provider/provider.dart';

import 'Searchbar_Proc_Task.dart';

class PageMain extends StatelessWidget {
  const PageMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RiskProvider>(
      create: (_) => RiskProvider(),
      child: Scaffold(
          appBar: AppBar(
              title: Text("Hazard Risk Factor analysis"),
              systemOverlayStyle: SystemUiOverlayStyle(
                systemStatusBarContrastEnforced: true,
                statusBarBrightness: Brightness.dark,
              ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: const [
                  SearchbarProcTask(),
                  ListFactorManage(),
                ],
              ),
            ),
          ),
        floatingActionButton: AjaxButton(),
      ),
    );
  }
}

// Sliver version
renderSliverList() {
  return CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildListDelegate([
          SearchbarProcTask(),
          ListFactorManage(),
        ]),
      ),
    ],
  );
}
