import 'package:front/Model/TaskModel.dart';

import 'ManageModel.dart';

class FactorModel {
  final String stdTaskCd;
  final String stdRiskFactorSeq;
  final String riskCate1Name; // 위험분류 1
  final String riskCate2Name; // 위험분류 2
  final String riskFactor; // 위험발생 상황 및 결과
  final String riskRelatedLaw; // 관련법
  List<ManageModel> manageList;
  double managedLevel;
  bool isExpanded;

  FactorModel(
      this.stdTaskCd,
      this.stdRiskFactorSeq,
      this.riskCate1Name,
      this.riskCate2Name,
      this.riskFactor,
      this.riskRelatedLaw,
      this.manageList,
      this.managedLevel,
      this.isExpanded);

  factory FactorModel.fromJson(Map<String, dynamic> json) {
    return FactorModel(
        json["stdTaskCd"],
        json["stdRiskFactorSeq"].toString(),
        json["riskCate1Name"],
        json["riskCate2Name"],
        json["riskFactor"],
        json["riskRelatedLaw"] ?? "",
        [],
        0,
        false);
  }

  static List<FactorModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => FactorModel.fromJson(item)).toList();
  }

  bool isUnderTask(TaskModel model) {
    return stdTaskCd == model.stdTaskCd;
  }

  @override
  String toString() => riskFactor;
}
