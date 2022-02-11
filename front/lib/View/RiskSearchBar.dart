import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:front/Controller/DatabaseProvider.dart';
import 'package:front/Model/ProcModel.dart';
import 'package:front/Model/RiskControllState.dart';
import 'package:front/Model/TaskModel.dart';
import 'package:provider/provider.dart';

class RiskSearchBar extends StatelessWidget {
  const RiskSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rskState = Provider.of<RiskControllState>(context);
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
            rskState.factorList?.forEach((e) => e.manageList = null);
          },
          dropdownBuilder: procDropDown,
          popupItemBuilder: procPopupItemBuilder,
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
          onFind: (String? filter) => db.getTaskData(filter, rskState.procCurrent!),
          onChanged: (data) async {
            rskState.taskCurrent = data;
            rskState.factorList = await db.getFactorData(data!);
            await db.getManageData(rskState.factorList, data);
          },
          dropdownBuilder: taskDropDown,
          popupItemBuilder: taskPopupItemBuilder,
        ),
        const Divider(),
      ],
    );
  }
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
