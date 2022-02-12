import 'package:flutter/material.dart';

import 'FactorModel.dart';
import 'ManageModel.dart';
import 'ProcModel.dart';
import 'TaskModel.dart';

class RiskControllState extends ChangeNotifier {

  ProcModel? _procCurrent;
  TaskModel? _taskCurrent;
  List<FactorModel>? _factorListCurrent;

  ProcModel? get procCurrent {
    return _procCurrent;
  }

  set procCurrent(ProcModel? value) {
    _procCurrent = value;
    notifyListeners();
  }

  TaskModel? get taskCurrent {
    return _taskCurrent;
  }

  set taskCurrent(TaskModel? value) {
    _taskCurrent = value;
    notifyListeners();
  }

  List<FactorModel>? get factorList {
    return _factorListCurrent;
  }

  set factorList(List<FactorModel>? value) {
    _factorListCurrent = value;
    notifyListeners();
  }

  void toggleFactorExpand(FactorModel factor){
    factor.isExpanded = !factor.isExpanded;
    notifyListeners();
  }

  void setManagedLevel(FactorModel factor) {
    double numberOfManaged = 0;

    for (var element in factor.manageList) {
      if (element.isManaged) {
        numberOfManaged += 1.0;
      }
    }
    factor.managedLevel = numberOfManaged / factor.manageList.length;
    notifyListeners();
  }

  static int getManagedFactors(List<FactorModel> factors) {
    return factors.fold<int>(0, (prev, e) => prev + (e.managedLevel == 1 ? 1 : 0));
  }

}