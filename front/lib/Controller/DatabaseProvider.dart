import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:front/Model/FactorModel.dart';
import 'package:front/Model/ManageModel.dart';
import 'package:front/Model/ProcModel.dart';
import 'package:front/Model/TaskModel.dart';

class DatabaseProvider {
  Future<List<ProcModel>> getProcData(filter) async {
    String jsonString = await rootBundle.loadString("assets/process_list.json");
    List<dynamic> data = json.decode(jsonString);
    if (data != null) {
      return ProcModel.fromJsonList(data);
    }
    return [];
  }

  Future<List<TaskModel>> getTaskData(filter, ProcModel? target) async {
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

  Future<void> getManageData(List<FactorModel>? factors, TaskModel task) async {
    if (factors == null) {
      return;
    }
    String jsonString = await rootBundle.loadString("assets/manage_list.json");
    List<dynamic> data = json.decode(jsonString);
    if (data != null && task != null) {
      List<ManageModel> dataSorted = ManageModel.fromJsonList(data)
          .where((e) => e.isUnderTask(task))
          .toList();
      factors.forEach((factor) {
        factor.manageList = dataSorted
            .where((e) => e.isUnderFactor(factor))
            .toList();
      });
    }
  }
}
