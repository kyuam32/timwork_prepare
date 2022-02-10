import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProcModel {
  final String stdProcessCd;
  final String processName;

  ProcModel(this.stdProcessCd, this.processName);

  factory ProcModel.fromJson(Map<String, dynamic> json) {
    return ProcModel(json["stdProcessCd"],json["processName"]);
  }

  static List<ProcModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => ProcModel.fromJson(item)).toList();
  }

  bool isEqual(ProcModel model) {
    return stdProcessCd == model.stdProcessCd;
  }

  @override
  String toString() => processName;


}
