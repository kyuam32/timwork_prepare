import 'package:flutter/material.dart';

import '../Model/FactorModel.dart';
import '../Model/ManageModel.dart';
import '../Model/ProcModel.dart';
import '../Model/TaskModel.dart';

class RiskProvider extends ChangeNotifier {
  ProcModel? _procCurrent;
  TaskModel? _taskCurrent;
  List<FactorModel>? _factorListCurrent;

  ProcModel? get procCurrent {
    return _procCurrent;
  }

  TaskModel? get taskCurrent {
    return _taskCurrent;
  }

  set procCurrent(ProcModel? value) {
    _procCurrent = value;
    notifyListeners();
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

  void toggleFactorExpand(FactorModel factor) {
    factor.isExpanded = !factor.isExpanded;
    notifyListeners();
  }

  void toggleManaged(ManageModel manage, FactorModel factor){
    manage.isManaged = !manage.isManaged;
    setManagedLevel(factor);
    if(factor.managedLevel == 1){
      factor.isExpanded = !factor.isExpanded;
    }
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

  int getManagedFactors() {
    return factorList!.fold<int>(
        0, (prev, e) => prev + (e.managedLevel == 1 ? 1 : 0));
  }

  void addFactor(riskCate1Name, riskCate2Name, riskFactor, riskRelatedLaw) {
    var newone = FactorModel(_taskCurrent!.stdTaskCd, "null", riskCate1Name,
        riskCate2Name, riskFactor, riskRelatedLaw, [], 0, false);
    _factorListCurrent!.add(newone);
    notifyListeners();
  }

  void addManage(FactorModel factor, String toDo) {
    var newone = ManageModel(_taskCurrent!.stdTaskCd, factor.stdRiskFactorSeq, toDo, false);
    factor.manageList.add(newone);
    setManagedLevel(factor);
    notifyListeners();
  }

  void removeFactor(FactorModel factor){
    factorList!.removeAt(factorList!.indexOf(factor));
    notifyListeners();
  }

  void removeManage(FactorModel factor, ManageModel manage){
    factor.manageList.removeAt(factor.manageList.indexOf(manage));
    notifyListeners();
  }
}
