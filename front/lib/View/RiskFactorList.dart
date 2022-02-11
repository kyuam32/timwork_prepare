import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/Model/RiskControllState.dart';
import 'package:provider/provider.dart';

class RiskFactorList extends StatelessWidget {
  const RiskFactorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rskState = Provider.of<RiskControllState>(context);

    // if (rskState.factorList == null) {
    //   return Text("공정과 작업을 선택해 주세요");
    // }

    return rskState.factorList == null
        ? Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.black26),
                borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            child: Center(child: Text("공정과 작업을 선택해 주세요")),
          )
        : Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.black26),
                borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            child: _buildPanel(rskState),
            // child: Wrap(children: renderfactorList(rskState)),
          );
  }

  Widget _buildPanel(RiskControllState rskState) {
    if (rskState.factorList == null) {
      return ExpansionPanelList();
    }

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        rskState.factorExpand(rskState.factorList![index]);
      },
      children: rskState.factorList!
          .map((factor) => ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                    subtitle: Text(factor.riskRelatedLaw ?? ""),
                  );
                },
                body: Column(
                  children: factor.manageList!
                      .map((manage) => ListTile(
                          title: Text(manage.stdSafetyMeasure),
                          subtitle: const Text(
                              'To delete this panel, tap the trash can icon'),
                          trailing: const Icon(Icons.delete),
                          onTap: () {
                            // setState(() {
                            //   _data.removeWhere((Item currentItem) => factor == currentItem);
                            // });
                          }))
                      .toList(),
                ),
                isExpanded: factor.isExpanded,
              ))
          .toList(),
    );
  }
}

List<Widget> renderfactorList(RiskControllState rskState) {
  return rskState.factorList!
      .map((factor) => Card(
            child: Wrap(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onTap: () => rskState.factorExpand(factor),
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
                  subtitle: Text(factor.riskRelatedLaw ?? ""),
                  trailing: factor.isExpanded
                      ? Icon(Icons.arrow_drop_up)
                      : Icon(Icons.arrow_drop_down),
                ),
                Visibility(
                  visible: factor.isExpanded,
                  child: Wrap(children: [Text("안녕")]
                      // renderManageList(),
                      ),
                )
              ],
            ),
          ))
      .toList();
}

//
//   List<Widget> renderManageList(RiskControllState rskState) {
//     if (rskState.manageList == null) {
//       return [Container()];
//     }
//
//     var temp = rskState.manageList!.map((manages){
//       return manages.map((e) => ListTile(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(5),
//         ),
//         title: Text(e.stdSafetyMeasure),
//         trailing: IconButton(
//           icon: e.isManaged
//               ? Icon(Icons.check_box_outlined)
//               : Icon(Icons.check_box_outline_blank),
//           onPressed: () {
//             e.isManaged = !e.isManaged;
//             factorList![factorIndex].updateManagedLevel(
//                 manageList![factorIndex]);
//             if (manageList![factorIndex].isNotEmpty &&
//                 factorList![factorIndex].managedLevel == 1) {
//               _isSelectedFactor[factorIndex] =
//               !_isSelectedFactor[factorIndex];
//             }
//           }
//         ),
//       )).toList();
//     });
//
//     return manageList![factorIndex].map((e) {
//       return ListTile(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(5),
//         ),
//         title: Text(e.stdSafetyMeasure),
//         trailing: IconButton(
//           icon: e.isManaged
//               ? Icon(Icons.check_box_outlined)
//               : Icon(Icons.check_box_outline_blank),
//           onPressed: () =>
//               setState(() {
//                 e.isManaged = !e.isManaged;
//                 factorList![factorIndex]
//                     .updateManagedLevel(manageList![factorIndex]);
//                 if (manageList![factorIndex].isNotEmpty &&
//                     factorList![factorIndex].managedLevel == 1) {
//                   _isSelectedFactor[factorIndex] =
//                   !_isSelectedFactor[factorIndex];
//                 }
//               }),
//         ),
//       );
//     }).toList();
//   }
