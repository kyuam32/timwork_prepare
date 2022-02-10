import 'package:front/Model/FactorModel.dart';
import 'TaskModel.dart';

class ManageModel {
  final String stdTaskCd;
  final String stdRiskFactorSeq;
  final String stdSafetyMeasure;
  bool isManaged;

  ManageModel(this.stdTaskCd, this.stdRiskFactorSeq, this.stdSafetyMeasure, this.isManaged);

  factory ManageModel.formJson(Map<String, dynamic> json){
    return ManageModel(json["stdTaskCd"], json["stdRiskFactorSeq"].toString(), json["stdSafetyMeasure"], false);
  }

  static List<ManageModel> fromJsonList(List<dynamic> list){
    return list.map((e) => ManageModel.formJson(e)).toList();
  }

  bool isUnderFactor(FactorModel model) {
    return stdRiskFactorSeq == model.stdRiskFactorSeq;
  }

  bool isUnderTask(TaskModel model) {
    return stdTaskCd == model.stdTaskCd;
  }

  static List<List<ManageModel>> syncFactorList(List<FactorModel> factors, List<ManageModel> manages){
    return factors.map((fac) {
      List<ManageModel> temp = [];
      manages.forEach((man){
        man.isUnderFactor(fac) ? temp.add(man) : null;
      });
      return temp;
    }).toList();
  }

  @override
  String toString() => stdSafetyMeasure;
}