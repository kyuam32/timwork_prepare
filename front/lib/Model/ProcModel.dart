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

  static Widget procDropDown(BuildContext context, ProcModel? item) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: CircleAvatar(),
        title: Text(item.processName),
        subtitle: const Text("건설업"),
      ),
    );
  }

  static Widget procPopupItemBuilder(BuildContext context, ProcModel? item,
      bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme
            .of(context)
            .primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Card(
        child: ListTile(
          selected: isSelected,
          title: Text(item?.processName ?? ''),
          subtitle: const Text("건설업"),
          leading: CircleAvatar(),
        ),
      ),
    );
  }

  bool isEqual(ProcModel model) {
    return stdProcessCd == model.stdProcessCd;
  }

  @override
  String toString() => processName;


}
