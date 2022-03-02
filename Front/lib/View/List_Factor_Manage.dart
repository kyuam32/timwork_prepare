import 'package:flutter/material.dart';
import 'package:front/Model/FactorModel.dart';
import 'package:front/Provider/RiskProvider.dart';
import 'package:front/View/Form_Factor.dart';
import 'package:front/View/Form_Manage.dart';
import 'package:provider/provider.dart';
import 'package:front/Style/CustomText.dart';

class ListFactorManage extends StatefulWidget {
  const ListFactorManage({Key? key}) : super(key: key);

  @override
  _ListFactorManageState createState() => _ListFactorManageState();
}

class _ListFactorManageState extends State<ListFactorManage> {
  Border boxBorder = Border.all(width: 1, color: Colors.black38);
  Decoration roundBox = BoxDecoration(
      border: Border.all(width: 1, color: Colors.black38), borderRadius: const BorderRadius.all(Radius.circular(4.0)));

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        renderFrame(),
        renderList(),
      ],
    );
  }

  renderFrame() {
    final rskState = Provider.of<RiskProvider>(context);
    var height = MediaQuery
        .of(context)
        .size
        .height * 0.75;
    var framDeco = BoxDecoration(
      border: Border.all(width: 1, color: Colors.black38),
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(4.0),
      ),
    );
    var titleString = "작업을 선택해 주세요";
    if (rskState.factorList != null) {
      height = 75;
      titleString = rskState.factorList!.length.toString() + " 개 요소 중 "  + rskState.getManagedFactors().toString() + " 개 확인 완료";
    }

    return Stack(
      children: [
        Container(
          height: height,
          width: double.infinity,
          margin: EdgeInsets.only(top: 8),
          decoration: framDeco,
          child: Center(
            child: Text(
              titleString,
              style: Theme.of(context).textTheme.myTitle,
            ),
          ),
        ),
        Positioned(
          top: 1,
          left: 8,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 3, right: 3),
            child: const Text(
              "위험 요인",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
    );
  }

  renderList() {
    final rskState = Provider.of<RiskProvider>(context);

    if (rskState.factorList == null) {
      return const SizedBox.shrink();
    }
    final factors = rskState.factorList;

    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: rskState.factorList!.length + 1,
        itemBuilder: (context, index) {
          if (index < factors!.length) {
            return appendDissmissDelete(
                key: UniqueKey(),
                swipeL: rskState.removeFactor,
                para1: factors[index],
                child: renderFactorTile(
                  index: index,
                  ontap: rskState.toggleFactorExpand,
                ));
          }
          return renderAddTile(form: FormFactor());
        },
        separatorBuilder: (context, index) {
          if (index < rskState.factorList!.length) {
            return renderManageTile(
              ontap: rskState.toggleManaged,
              index: index,
            );
          }
          return SizedBox.shrink();
        });
  }

  renderFactorTile({required Function ontap, required int index}) {
    final rskState = Provider.of<RiskProvider>(context);
    final factor = rskState.factorList![index];

    return Material(
      child: InkWell(
        onTap: () => ontap(factor),
        child: Container(
          height: factor.isExpanded ? 150 : 100,
          decoration: BoxDecoration(border: boxBorder),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: renderFactorAvatar(factor: factor),),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              factor.riskFactor,
                              style: Theme.of(context).textTheme.myRiskBodyMain,
                              maxLines: factor.isExpanded ? 5 : 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              appendPositon(alignment: Alignment.bottomCenter, child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  factor.riskRelatedLaw,
                  style: Theme.of(context).textTheme.myRiskBodySub,
                  maxLines: factor.isExpanded ? 2 : 1,
                ),
              ),
              ),
              appendPositon(alignment: Alignment.bottomCenter,
                  child: factor.isExpanded ? Icon(Icons.arrow_drop_up) : Icon(Icons.arrow_drop_down)),
            ],
          ),
        ),
      ),
    );
  }

  renderManageTile({required Function ontap, required int index}) {
    final rskState = Provider.of<RiskProvider>(context);
    var factor = rskState.factorList![index];
    var checkTrue = Icon(
      Icons.check_circle,
      color: Colors.green,
    );
    var checkFalse = Icon(
      Icons.circle,
      color: Colors.red,
    );

    var divider = Container(
      height: 10,
      decoration: BoxDecoration(border: boxBorder),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Divider(
          thickness: 3,
          color: Theme
              .of(context)
              .primaryColor,
        ),
      ),
    );

    if (factor.isExpanded) {
      var manageList = factor.manageList
          .map((manage) =>
          appendDissmissDelete(
            key: UniqueKey(),
            swipeL: rskState.removeManage,
            para1: factor,
            para2: manage,
            child: Material(
              child: InkWell(
                onTap: () => ontap(manage, factor),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: boxBorder,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: manage.isManaged ? checkTrue : checkFalse,
                      ),
                      Expanded(
                        child: Text(
                          manage.stdSafetyMeasure,
                          style: Theme.of(context).textTheme.myRiskBodyMain2,
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ))
          .toList();
      return Column(
        children: [
          ...manageList,
          renderAddTile(
            form: FormManage(
              factor: factor,
            ),
          ),
          divider,
        ],
      );
    }

    return divider;
  }

  renderAddTile({required Widget form}) {
    final rskState = Provider.of<RiskProvider>(context);

    return Material(
      child: InkWell(
        onTap: () =>
            showDialog(
                context: context,
                builder: (_) =>
                    ChangeNotifierProvider.value(
                      value: rskState,
                      child: AlertDialog(
                        content: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.6,
                          height: MediaQuery
                              .of(context)
                              .size
                              .width * 0.8,
                          child: form,
                        ),
                      ),
                    )),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              border: boxBorder, borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0), top: Radius.zero)),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  renderFactorAvatar({required FactorModel factor}) {
    var icon = factor.managedLevel > 0.79
        ? Icons.check_circle
        : Icons.circle;
    var color = factor.managedLevel > 0.79
        ? Colors.lightGreen
        : factor.managedLevel > 0.49
        ? Colors.amber
        : Colors.deepOrange;

    return Icon(
      icon,
      color: color,
      // todo "Avatar with Somthing" version Legacy
      // child: FittedBox(
      //   fit: BoxFit.fitWidth,
      //   child: Text(
      //     factor.riskCate1Name
      //         .split(" ")
      //         .first,
      //     textAlign: TextAlign.center,
      //     textScaleFactor: 0.7,
      //   ),
      // ),
    );
  }

  renderSnackBar({required String text}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  appendDissmissDelete({required Widget child, required Key key, required Function swipeL, para1, para2}) {
    return Dismissible(
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (para2 == null) {
          swipeL(para1);
        } else {
          swipeL(para1, para2);
        }
        renderSnackBar(text: "항목이 삭제되었습니다.");
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme
            .of(context)
            .primaryColor,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.delete),
        ),
      ),
      child: child,
    );
  }

  appendPositon({required Alignment alignment, required Widget child}) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: child,
      ),
    );
  }
}
