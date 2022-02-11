import 'package:flutter/material.dart';

import 'FactorModel.dart';
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

  void factorExpand(FactorModel factor){
    factor.isExpanded = !factor.isExpanded;
    notifyListeners();

  }
}