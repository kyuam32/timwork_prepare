import 'package:flutter/material.dart';
import 'package:front/Controller/AjaxRequest.dart';
import 'package:front/Provider/RiskProvider.dart';
import 'package:provider/provider.dart';

class AjaxButton extends StatelessWidget {
  const AjaxButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rskState = Provider.of<RiskProvider>(context);

    return FloatingActionButton(
      onPressed: () {
        AjaxRequest.postProcess(rskState);
      },
      child: Icon(Icons.post_add),
    );
  }
}
