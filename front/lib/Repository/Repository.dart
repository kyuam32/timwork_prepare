import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:front/Model/FactorModel.dart';
import 'package:front/Model/ManageModel.dart';
import 'package:front/Model/ProcModel.dart';
import 'package:front/Model/TaskModel.dart';

class Repository {
  Future<List<dynamic>> getJsonData(String path) async {
    String jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString) ?? [];
  }

  Future<List<ProcModel>> getProcData(filter) async {
    return ProcModel.fromJsonList(
        await getJsonData("assets/process_list.json"));
  }

  Future<List<TaskModel>> getTaskData(filter, ProcModel target) async {
    return TaskModel.fromJsonList(await getJsonData("assets/task_list.json"))
        .where((e) => e.isUnderProcess(target))
        .toList();
  }

  Future<List<FactorModel>> getFactorData(TaskModel target) async {
    return FactorModel.fromJsonList(
            await getJsonData("assets/factor_list.json"))
        .where((e) => e.isUnderTask(target))
        .toList();
  }

  Future<void> getManageData(List<FactorModel>? factors, TaskModel task) async {
    if (factors == null || task == null) {
      return;
    }
    List<ManageModel> dataSorted =
        ManageModel.fromJsonList(await getJsonData("assets/manage_list.json"))
            .where((e) => e.isUnderTask(task))
            .toList();
    factors.forEach((factor) {
      factor.manageList =
          dataSorted.where((e) => e.isUnderFactor(factor)).toList();
    });
  }
}
