import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:front/Model/FactorModel.dart';
import 'package:front/Model/ProcModel.dart';
import 'package:front/Model/TaskModel.dart';

class RiskcheckDemo extends StatefulWidget {
  const RiskcheckDemo({Key? key}) : super(key: key);

  @override
  _RiskcheckDemoState createState() => _RiskcheckDemoState();
}


class _RiskcheckDemoState extends State<RiskcheckDemo> {
  ProcModel? procSelected = null;
  TaskModel? taskSelected = null;
  List<FactorModel>? factorSelected = null;

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
                factorSelected = null;
              });
              // getTaskData(null, procSelected!);
            },
            dropdownBuilder: _procDropDown,
            popupItemBuilder: _procPopupItemBuilder,
          ),
        ),

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
              List<FactorModel> temp = await getFactorData(data!);
              setState(() {
                taskSelected = data;
                factorSelected = temp;
              });
            },
            dropdownBuilder: _taskDropDown,
            popupItemBuilder: _taskPopupItemBuilder,
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
                children: toFactorList(factorSelected),
            ),
          ),
        ),
      ],
    );
  }
}

List<Widget> toFactorList(List<FactorModel>? list) {
  if (list == null) {
    return [Container()];
  }

  List<Widget> res = list.map((e) {
    return Card(
      child: ListTile(
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
        isThreeLine: true,
      ),
    );
  }).toList();

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



Widget _procDropDown(BuildContext context, ProcModel? item) {
  if (item == null) {
    return Container();
  }

  return Container(
    child: ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(),
      title: Text(item.processName),
      subtitle: const Text("건설업"),
    ),
  );
}

Widget _procPopupItemBuilder(BuildContext context, ProcModel? item,
    bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
      border: Border.all(color: Theme
          .of(context)
          .primaryColor),
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
    ),
    child: Card(
      child: ListTile(
        selected: isSelected,
        title: Text(item?.processName ?? ''),
        subtitle: const Text("건설업"),
        leading: CircleAvatar(),
      ),
    ),
  );
}

Widget _taskDropDown(BuildContext context, TaskModel? item) {
  if (item == null) {
    return Container();
  }

  return Container(
    child: Row(
      children: [
        Flexible(
          flex: 7,
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(),
            title: Text(item.taskName),
            subtitle: Text(item.taskDesc),
          ),
        ),
        Flexible(
          flex: 3,
          child: ListTile(
            title: Text("장비"),
            subtitle: Text(item.taskMachines ?? "없음"),
          ),
        ),
      ],
    ),
  );
}

Widget _taskPopupItemBuilder(BuildContext context, TaskModel? item,
    bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
      border: Border.all(color: Theme
          .of(context)
          .primaryColor),
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
    ),
    child: Card(
      child: ListTile(
        selected: isSelected,
        title: Text(item?.taskName ?? ''),
        subtitle: Text(item?.taskDesc ?? ''),
        leading: CircleAvatar(),
      ),
    ),
  );
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
