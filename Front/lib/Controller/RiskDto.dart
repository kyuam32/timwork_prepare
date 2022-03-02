import 'package:front/Provider/RiskProvider.dart';

class Process {
  String name;
  String? stdCode;
  List<Task> taskList;

  Process(this.name, this.stdCode, this.taskList);

  Map<String, dynamic> toJson() => {
    'name': name,
    'stdCode': stdCode,
    'taskList': taskList
  };

  static Process fromModel(RiskProvider risk) {
    var procCurrent = risk.procCurrent;
    var taskCurrent = risk.taskCurrent;
    List<Task> taskList = [];

    List<Evaluate>? evaluateList = risk.factorList
        ?.map((f) => Evaluate(Factor(f.riskFactor, f.riskRelatedLaw, f.stdRiskFactorSeq,
            f.manageList.map((m) => Control(Manage(m.stdSafetyMeasure))).toList())))
        .toList();

    Task task = Task(taskCurrent!.taskName, taskCurrent.taskDesc, taskCurrent.stdTaskCd, evaluateList!);
    taskList.add(task);

    return Process(procCurrent!.processName, procCurrent.stdProcessCd, taskList);
  }
}

class Task {
  String name;
  String description;
  String? stdCode;
  List<Evaluate> evaluateList;

  Task(this.name, this.description, this.stdCode, this.evaluateList);

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'stdCode': stdCode,
    'evaluateList': evaluateList
  };

}

class Evaluate {
  Factor factor;

  Evaluate(this.factor);

  Map<String, dynamic> toJson() => {
    'factor': factor
  };
}

class Factor {
  String name;
  String law;
  String? stdCode;
  List<Control> controlList;

  Factor(this.name, this.law, this.stdCode, this.controlList);

  Map<String, dynamic> toJson() => {
    'name': name,
    'law': law,
    'stdCode': stdCode,
    'controlList': controlList
  };
}

class Control {
  Manage _manage;

  Control(this._manage);

  Map<String, dynamic> toJson() => {
    'manage': _manage
  };
}

class Manage {
  String _name;

  Manage(this._name);

  Map<String, dynamic> toJson() => {
    'name': _name
  };
}
