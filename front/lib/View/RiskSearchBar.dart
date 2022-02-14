import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:front/Controller/DatabaseProvider.dart';
import 'package:front/Model/ProcModel.dart';
import 'package:front/Model/RiskProvider.dart';
import 'package:front/Model/TaskModel.dart';
import 'package:provider/provider.dart';

class RiskSearchBar extends StatelessWidget {
  const RiskSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rskState = Provider.of<RiskProvider>(context);
    final db = DatabaseProvider();

    return Column(
      children: [
        // FormView(),
        DropdownSearch<ProcModel>(
          showSelectedItems: true,
          showSearchBox: true,
          // selectedItem: procCurrent,
          compareFn: (i, s) => i?.isEqual(s!) ?? false,
          dropdownSearchDecoration: const InputDecoration(
            labelText: "작업 선택",
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          onFind: (String? filter) => db.getProcData(filter),
          onChanged: (data) {
            rskState.procCurrent = data;
            rskState.taskCurrent = null;
            rskState.factorList = null;
            rskState.factorList?.forEach((e) => e.manageList = []);
          },
          dropdownBuilder: dropDown,
          popupItemBuilder: popupItemBuilder,
        ),
        const Divider(),
        DropdownSearch<TaskModel>(
          showSelectedItems: true,
          showSearchBox: true,
          enabled: (rskState.procCurrent != null),
          selectedItem: rskState.taskCurrent,
          compareFn: (i, s) => i?.isEqual(s!) ?? false,
          dropdownSearchDecoration: const InputDecoration(
            labelText: "세부 작업 선택",
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          onFind: (String? filter) =>
              db.getTaskData(filter, rskState.procCurrent!),
          onChanged: (data) async {
            rskState.taskCurrent = data;
            rskState.factorList = await db.getFactorData(data!);
            await db.getManageData(rskState.factorList, data);
          },
          dropdownBuilder: dropDown,
          popupItemBuilder: popupItemBuilder,
        ),
        const Divider(),
      ],
    );
  }
}

Widget dropDown(BuildContext context, dynamic item) {
  final String title;
  final String subtitle;
  final Widget machineContainer;
  final Widget icon;

  if (item == null) {
    return Container();
  }
  if(item is ProcModel){
    title = item.processName;
    subtitle = "건설업";
    machineContainer = const SizedBox.shrink();
    icon = Icon(Icons.apartment_rounded);
  }
  else if (item is TaskModel){
    title = item.taskName;
    subtitle = item.taskDesc;
    machineContainer = Flexible(
      flex: 3,
      child: ListTile(
        tileColor: Colors.white70,
        title: const Text("사용 장비"),
        subtitle: Text(item.taskMachines ?? "없음"),
      ),
    );
    icon = Icon(Icons.construction_rounded);
  }
  else {
    assert(false);
    return Text("data error");
  }

  return Row(
    children: [
      Flexible(
        flex: 7,
        child: ListTile(
          tileColor: Colors.white70,
          contentPadding: EdgeInsets.all(0),
          leading: CircleAvatar(
            child: icon,
          ),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
      machineContainer,
    ],
  );
}

Widget popupItemBuilder(
    BuildContext context, dynamic item, bool isSelected) {
  final String title;
  final String subtitle;
  if(item is ProcModel){
    title = item.processName;
    subtitle = "건설업";
  }
  else if (item is TaskModel){
    title = item.taskName;
    subtitle = item.taskDesc;
  }
  else {
    assert(false);
    return const Text("data error");
  }

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
        title: Text(title),
        subtitle: Text(subtitle),
        leading: CircleAvatar(),
      ),
    ),
  );
}


