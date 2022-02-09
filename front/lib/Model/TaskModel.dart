import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/Model/ProcModel.dart';

class TaskModel {
  final String stdProcessCd;
  final String stdTaskCd;
  final String taskName;
  final String taskDesc;
  final String? taskMachines;


  TaskModel(this.stdProcessCd, this.stdTaskCd, this.taskName, this.taskDesc, this.taskMachines);

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(json["stdProcessCd"],json["stdTaskCd"],json["taskName"],json["taskDesc"],json["taskMachines"]);
  }

  static List<TaskModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => TaskModel.fromJson(item)).toList();
  }

  static Widget taskDropDown(BuildContext context, TaskModel? item) {
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

  static Widget taskPopupItemBuilder(BuildContext context, TaskModel? item,
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

  ///custom comparing function to check if two users are equal
  bool isEqual(TaskModel model) {
    return taskName == model.taskName;
  }

  bool isUnderProcess(ProcModel model) {
    return stdProcessCd == model.stdProcessCd;
  }

  @override
  String toString() => taskName;
}
