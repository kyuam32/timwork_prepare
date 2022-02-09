import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:front/Model/FactorModel.dart';
import 'package:front/Model/ManageModel.dart';
import 'package:front/Model/ProcModel.dart';
import 'package:front/Model/TaskModel.dart';

class FactorStatus{
  bool isSelected = false;
  int managedLevel = 0;
  List<bool> isCheckedManage;

  FactorStatus(this.isCheckedManage);
}

class RiskcheckDemo extends StatefulWidget {
  const RiskcheckDemo({Key? key}) : super(key: key);

  @override
  _RiskcheckDemoState createState() => _RiskcheckDemoState();
}


class _RiskcheckDemoState extends State<RiskcheckDemo> {
  ProcModel? procSelected;
  TaskModel? taskSelected;
  List<FactorModel>? factorList;
  List<ManageModel>? manageList;

  late List<FactorStatus> _factorStatus;
  late List<bool> _isSelectedFactor;
  late List<bool> _isManaged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(

          margin: EdgeInsets.fromLTRB(20, 25, 20, 10),
          child: DropdownSearch<ProcModel>(
            showSelectedItems: true,
            showSearchBox: true,
            selectedItem: procSelected,
            compareFn: (i, s) => i?.isEqual(s!) ?? false,
            dropdownSearchDecoration: const InputDecoration(
              labelText: "작업 선택",
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              border: OutlineInputBorder(),
            ),
            onFind: (String? filter) => getProcData(filter),
            onChanged: (data) {
              setState(() {
                procSelected = data!;
                taskSelected = null;
                factorList = null;
                manageList = null;
              });
              // getTaskData(null, procSelected!);
            },
            dropdownBuilder: ProcModel.procDropDown,
            popupItemBuilder: ProcModel.procPopupItemBuilder,
          ),
        ),

        // todo State 관리 수정
        const Divider(),

        Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: DropdownSearch<TaskModel>(
            showSelectedItems: true,
            showSearchBox: true,
            enabled: (procSelected != null),
            selectedItem: taskSelected,
            compareFn: (i, s) => i?.isEqual(s!) ?? false,
            dropdownSearchDecoration: const InputDecoration(
              labelText: "세부 작업 선택",
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              border: OutlineInputBorder(),
            ),
            onFind: (String? filter) => getTaskData(filter, procSelected!),
            onChanged: (data) async {
              List<FactorModel> factors = await getFactorData(data!);
              List<ManageModel> manages = await getManageData(data);
              setState(() {
                taskSelected = data;
                factorList = factors;
                manageList = manages;
                _isSelectedFactor = List.generate(factors.length, (i) => false);
                _isManaged = List.generate(manages.length, (i) => false);
                _factorStatus = List.generate(factors.length, (i) {
                  List<bool> temp = [];
                  manageList?.forEach((element) {element.isUnderFactor(factorList![i]) ? temp.add(false) : null;});
                  return FactorStatus(temp);
                });
              });
            },
            dropdownBuilder: TaskModel.taskDropDown,
            popupItemBuilder: TaskModel.taskPopupItemBuilder,
          ),
        ),

        const Divider(),

        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1.5,
                    color: Colors.black26
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(4.0)
                )
            ),
            child: ListView(
                children: factorListView(factorList),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> manageListView(int factorIndex) {
    return manageList?.asMap().entries.map((e) {
      if (_isSelectedFactor[factorIndex] && e.value.isUnderFactor(factorList![factorIndex])) {
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(e.value.stdSafetyMeasure),
          tileColor: Colors.orange.shade50,
          trailing: IconButton(
            icon: _isManaged[e.key] ? Icon(Icons.check_box_outlined) : Icon(Icons.check_box_outline_blank),
            onPressed: () => setState(() {
              _isManaged[e.key] = !_isManaged[e.key];
            }),
          ),
        );
      }
      return const SizedBox.shrink();
    }).toList() as List<Widget>;
  }

List<Widget> factorListView(List<FactorModel>? factorList) {
  if (factorList == null) {
    return [Container()];
  }
  List<Widget> res = factorList.asMap().map((i, e) => MapEntry(i, Card(
    child: Wrap(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          tileColor: _isSelectedFactor[i] ? Colors.amberAccent: null,
          onTap: () => setState(() {
            _isSelectedFactor[i] = !_isSelectedFactor[i];
          }),
          leading: CircleAvatar(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(e.riskCate1Name.split(" ").first + "\n  요인",
                textAlign: TextAlign.center,
                textScaleFactor: 0.7,
              ),
            ),
          ),
          title: Text(e.riskFactor),
          subtitle: Text(e.riskRelatedLaw ?? ""),
          trailing: _isSelectedFactor[i] ? Icon(Icons.arrow_drop_down) : Icon(Icons.arrow_drop_up),
          isThreeLine: true,
        ),
        Wrap(
          children: manageListView(i)
          )
      ],
    ),
  ))).values.toList();

  res.insert(0, const Card(
    child: ListTile(
      leading: Icon(
        Icons.add,
        size: 30,
      ),
      // onTap: (){},
    ),
  ));
  return res;
}



}

Future<List<ProcModel>> getProcData(filter) async {
  String jsonString = await rootBundle.loadString("assets/process_list.json");
  List<dynamic> data = json.decode(jsonString);
  if (data != null) {
    return ProcModel.fromJsonList(data);
  }
  return [];
}

Future<List<TaskModel>> getTaskData(filter, ProcModel target) async {
  String jsonString = await rootBundle.loadString("assets/task_list.json");
  List<dynamic> data = json.decode(jsonString);
  if (data != null && target != null) {
    return TaskModel.fromJsonList(data)
        .where((e) => e.isUnderProcess(target))
        .toList();
  }
  return [];
}

Future<List<FactorModel>> getFactorData(TaskModel target) async {
  String jsonString = await rootBundle.loadString("assets/factor_list.json");
  List<dynamic> data = json.decode(jsonString);
  if (data != null && target != null) {
    return FactorModel.fromJsonList(data)
        .where((e) => e.isUnderTask(target))
        .toList();
  }
  return [];
}

Future<List<ManageModel>> getManageData(TaskModel target) async {
  String jsonString = await rootBundle.loadString("assets/manage_list.json");
  List<dynamic> data = json.decode(jsonString);
  if (data != null && target != null) {
    return ManageModel.fromJsonList(data)
        .where((e) => e.isUnderTask(target))
        .toList();
  }
  return [];
}
