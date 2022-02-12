import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/Model/FactorModel.dart';
import 'package:front/Model/RiskControllState.dart';
import 'package:provider/provider.dart';

class RiskFactorList extends StatelessWidget {
  const RiskFactorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rskState = Provider.of<RiskControllState>(context);
    if (rskState.factorList == null) {
      return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.black26),
                borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            child: const Center(
              child: Text("공정과 작업을 선택해 주세요",textScaleFactor: 1.5,),
            ),
          );
    } else {
      return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.black26),
                borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            child: Column(children: renderfactorList(rskState)),
          );
    }
  }

  // infinity scroll 아닐시 ListView builder 쓰는 것도 좋을듯

  List<Widget> renderfactorList(RiskControllState rskState) {
    var list = rskState.factorList!
        .map(
          (factor) => Column(
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onTap: () => rskState.toggleFactorExpand(factor),
                tileColor: factor.managedLevel > 0.79
                    ? Colors.lightGreen[100]
                    : factor.managedLevel > 0.49
                        ? Colors.amber[100]
                        : Colors.deepOrange[100],
                leading: CircleAvatar(
                  backgroundColor: factor.managedLevel > 0.79
                      ? Colors.lightGreen
                      : factor.managedLevel > 0.49
                          ? Colors.amber
                          : Colors.deepOrange,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      factor.riskCate1Name.split(" ").first,
                      textAlign: TextAlign.center,
                      textScaleFactor: 0.7,
                    ),
                  ),
                ),
                title: Text(factor.riskFactor),
                subtitle: Text(factor.riskRelatedLaw),
                trailing: factor.isExpanded
                    ? const Icon(Icons.arrow_drop_up)
                    : const Icon(Icons.arrow_drop_down),
              ),
              Visibility(
                visible: factor.isExpanded,
                child: Column(
                  children: renderManageList(rskState, factor),
                ),
              )
            ],
          ),
        )
        .toList();

    // list.insert(0, addCustomManageButton());

    return list;
  }

  List<Widget> renderManageList(
      RiskControllState rskState, FactorModel factor) {
    return factor.manageList
        .map((manage) => ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              title: Text(manage.stdSafetyMeasure),
              trailing: IconButton(
                icon: manage.isManaged
                    ? const Icon(Icons.check_box_outlined)
                    : const Icon(Icons.check_box_outline_blank),
                onPressed: () {
                  manage.isManaged = !manage.isManaged;
                  rskState.setManagedLevel(factor);
                  if (factor.managedLevel == 1) {
                    rskState.toggleFactorExpand(factor);
                  }
                },
              ),
            ))
        .toList();
  }

  Widget addCustomManageButton() {
    // TODO: implement addCustomManageButton
    return Card(

    );
    throw UnimplementedError();
  }
  Widget addCustomFactorButton() {
    // TODO: implement addCustomFactorButton
    throw UnimplementedError();
  }

}
