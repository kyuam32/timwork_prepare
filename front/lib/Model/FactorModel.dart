import 'package:front/Model/TaskModel.dart';

class FactorModel {

  final String stdTaskCd;
  final String stdRiskFactorSeq;
  final String riskCate1Name;   // 위험분류 1
  final String riskCate2Name;   // 위험분류 2
  final String riskFactor;      // 위험발생 상황 및 결과
  final String? riskRelatedLaw; // 관련법

  FactorModel(this.stdTaskCd, this.stdRiskFactorSeq, this.riskCate1Name,
      this.riskCate2Name, this.riskFactor, this.riskRelatedLaw);


  factory FactorModel.fromJson(Map<String, dynamic> json){
    return FactorModel(json["stdTaskCd"], json["stdRiskFactorSeq"].toString(), json["riskCate1Name"], json["riskCate2Name"], json["riskFactor"], json["riskRelatedLaw"]);
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