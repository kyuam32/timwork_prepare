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
