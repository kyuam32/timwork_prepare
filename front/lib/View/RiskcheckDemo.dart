import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:front/Model/FactorModel.dart';
import 'package:front/Model/ManageModel.dart';
import 'package:front/Model/ProcModel.dart';
import 'package:front/Model/TaskModel.dart';
import 'package:front/View/FormView.dart';

class FactorStatus {
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
  ProcModel? procCurrent;
  TaskModel? taskCurrent;
  List<FactorModel>? factorList;
  List<List<ManageModel>>? manageList;

  late List<bool> _isSelectedFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormView(),
        Container(
          margin: EdgeInsets.fromLTRB(20, 25, 20, 10),
          child: DropdownSearch<ProcModel>(
            showSelectedItems: true,
            showSearchBox: true,
            selectedItem: procCurrent,
            compareFn: (i, s) => i?.isEqual(s!) ?? false,
            dropdownSearchDecoration: const InputDecoration(
              labelText: "작업 선택",
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              border: OutlineInputBorder(),
            ),
            onFind: (String? filter) => getProcData(filter),
            onChanged: (data) {
              setState(() {
                procCurrent = data!;
                taskCurrent = null;
                factorList = null;
                manageList = null;
              });
              // getTaskData(null, procSelected!);
            },
            dropdownBuilder: procDropDown,
            popupItemBuilder: procPopupItemBuilder,
          ),
        ),
        const Divider(),
        Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: DropdownSearch<TaskModel>(
            showSelectedItems: true,
            showSearchBox: true,
            enabled: (procCurrent != null),
            selectedItem: taskCurrent,
            compareFn: (i, s) => i?.isEqual(s!) ?? false,
            dropdownSearchDecoration: const InputDecoration(
              labelText: "세부 작업 선택",
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              border: OutlineInputBorder(),
            ),
            onFind: (String? filter) => getTaskData(filter, procCurrent!),
            onChanged: (data) async {
              List<FactorModel> factors = await getFactorData(data!);
              List<ManageModel> manages = await getManageData(data);
              setState(() {
                taskCurrent = data;
                factorList = factors;
                manageList = ManageModel.syncFactorList(factors, manages);
                _isSelectedFactor = List.generate(factors.length, (i) => false);
              });
            },
            dropdownBuilder: taskDropDown,
            popupItemBuilder: taskPopupItemBuilder,
          ),
        ),
        const Divider(),
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.black26),
                borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            child: ListView(
              children: factorListView(factorList),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> manageListView(int factorIndex) {
    if (_isSelectedFactor[factorIndex] && manageList != null) {
      return manageList![factorIndex].map((e) {
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(e.stdSafetyMeasure),
          trailing: IconButton(
            icon: e.isManaged
                ? Icon(Icons.check_box_outlined)
                : Icon(Icons.check_box_outline_blank),
            onPressed: () => setState(() {
              e.isManaged = !e.isManaged;
              factorList![factorIndex]
                  .updateManagedLevel(manageList![factorIndex]);
              if (manageList![factorIndex].isNotEmpty &&
                  factorList![factorIndex].managedLevel == 1) {
                _isSelectedFactor[factorIndex] =
                    !_isSelectedFactor[factorIndex];
              }
            }),
          ),
        );
      }).toList();
    }
    return [Container()];
  }

  List<Widget> factorListView(List<FactorModel>? factorList) {
    if (factorList == null) {
      return [Container()];
    }

    List<Widget>? res = factorList.asMap().entries.map((e) {
      return Card(
        child: Wrap(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onTap: () => setState(() {
                _isSelectedFactor[e.key] = !_isSelectedFactor[e.key];
              }),
              // tileColor: Color(0xFFFCE4C6),
              tileColor: e.value.managedLevel > 0.79
                  ? Colors.lightGreen[100]
                  : e.value.managedLevel > 0.49
                      ? Colors.amber[100]
                      : Colors.deepOrange[100],
              leading: CircleAvatar(
                backgroundColor: e.value.managedLevel > 0.79
                    ? Colors.lightGreen
                    : e.value.managedLevel > 0.49
                        ? Colors.amber
                        : Colors.deepOrange,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    e.value.riskCate1Name.split(" ").first,
                    textAlign: TextAlign.center,
                    textScaleFactor: 0.7,
                  ),
                ),
              ),
              title: Text(e.value.riskFactor),
              subtitle: Text(e.value.riskRelatedLaw ?? ""),
              trailing: _isSelectedFactor[e.key]
                  ? Icon(Icons.arrow_drop_down)
                  : Icon(Icons.arrow_drop_up),
            ),
            Wrap(
              children: manageListView(e.key),
            )
          ],
        ),
      );
    }).toList();

    res.insert(
        0,
        Card(
          child: Center(
            heightFactor: 1.5,
            child: Text(
              "위험 요소 " +
                  factorList.length.toString() +
                  "개 중 " +
                  FactorModel.numberOfManagedFactors(factorList).toString() +
                  "개 확인 완료",
              textScaleFactor: 1.5,
            ),
          ),
        ));

    res.add(Card(
      child: ListTile(
        tileColor: Colors.white70,
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

Widget procDropDown(BuildContext context, ProcModel? item) {
  if (item == null) {
    return Container();
  }

  return Container(
    child: ListTile(
      tileColor: Colors.white70,
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(
        child: Icon(Icons.apartment_rounded),
      ),
      title: Text(item.processName),
      subtitle: const Text("건설업"),
    ),
  );
}

Widget procPopupItemBuilder(
    BuildContext context, ProcModel? item, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
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

Widget taskDropDown(BuildContext context, TaskModel? item) {
  if (item == null) {
    return Container();
  }

  return Container(
    child: Row(
      children: [
        Flexible(
          flex: 7,
          child: ListTile(
            tileColor: Colors.white70,
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(
              child: Icon(Icons.construction_rounded),
            ),
            title: Text(item.taskName),
            subtitle: Text(item.taskDesc),
          ),
        ),
        Flexible(
          flex: 3,
          child: ListTile(
            tileColor: Colors.white70,
            title: Text("장비"),
            subtitle: Text(item.taskMachines ?? "없음"),
          ),
        ),
      ],
    ),
  );
}

Widget taskPopupItemBuilder(
    BuildContext context, TaskModel? item, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
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
