import 'package:front/Model/TaskModel.dart';

import 'ManageModel.dart';

class FactorModel {
  final String stdTaskCd;
  final String stdRiskFactorSeq;
  final String riskCate1Name; // 위험분류 1
  final String riskCate2Name; // 위험분류 2
  final String riskFactor; // 위험발생 상황 및 결과
  final String? riskRelatedLaw; // 관련법
  double managedLevel;

  FactorModel(
      this.stdTaskCd,
      this.stdRiskFactorSeq,
      this.riskCate1Name,
      this.riskCate2Name,
      this.riskFactor,
      this.riskRelatedLaw,
      this.managedLevel);

  factory FactorModel.fromJson(Map<String, dynamic> json) {
    return FactorModel(
        json["stdTaskCd"],
        json["stdRiskFactorSeq"].toString(),
        json["riskCate1Name"],
        json["riskCate2Name"],
        json["riskFactor"],
        json["riskRelatedLaw"],
        0);
  }

  static List<FactorModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => FactorModel.fromJson(item)).toList();
  }

  bool isUnderTask(TaskModel model) {
    return stdTaskCd == model.stdTaskCd;
  }

  void updateManagedLevel(List<ManageModel> manages) {
    double numberOfManaged = 0;

    for (var element in manages) {
      if (element.isManaged) {
        numberOfManaged += 1.0;
      }
    }
    managedLevel = numberOfManaged / manages.length;
  }

  static int numberOfManagedFactors(List<FactorModel> factors){
    return factors.map((e) => e.managedLevel == 1 ? 1 : 0)
        .toList()
        .reduce((value, element) => value + element);
  }


  @override
  String toString() => riskFactor;
}
