import 'package:flutter/material.dart';
import 'package:front/Model/FactorModel.dart';
import 'package:front/Provider/RiskProvider.dart';
import 'package:front/View/Form_Factor.dart';
import 'package:front/View/Form_Manage.dart';
import 'package:provider/provider.dart';

class ListManages extends StatefulWidget {
  const ListManages({Key? key}) : super(key: key);

  @override
  _ListManagesState createState() => _ListManagesState();
}

class _ListManagesState extends State<ListManages> {
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
    var height = MediaQuery.of(context).size.height * 0.75;
    var framDeco = BoxDecoration(
      border: Border.all(width: 1, color: Colors.black38),
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(4.0),
      ),
    );

    if (rskState.factorList != null) {
      height = 75;
    }
    return Stack(
      children: [
        Container(
          height: height,
          width: double.infinity,
          margin: EdgeInsets.only(top: 8),
          decoration: framDeco,
          child: const Center(
            child: Text(
              // todo 완료도 추가
              "작업을 선택해 주세요",
              textScaleFactor: 1.5,
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
                  // color: Color.fromARGB(170, 0, 0, 0),
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
              ontap: () {},
              index: index,
            );

            //   Container(
            //   height: 200,
            //   color: Colors.blue,
            // );

          }
          return SizedBox.shrink();
        });
  }

  renderFactorTile({required Function ontap, required int index}) {
    final rskState = Provider.of<RiskProvider>(context);
    final factor = rskState.factorList![index];
    const styleTextMain = TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w400, fontSize: 13);
    const styleTextSub =
        TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w300, color: Colors.black54, fontSize: 11);

    return Material(
      child: InkWell(
        onTap: () => ontap(factor),
        child: Container(
          height: factor.isExpanded ? 150 : 100,
          decoration: BoxDecoration(border: boxBorder),
          child: Stack(
            children: [
              appendPositon(
                  alignment: Alignment(-0.95, 0),
                  child: CircleAvatar()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      // todo 정렬하는걸 한번 생각해보자
                      padding: const EdgeInsets.fromLTRB(60, 0, 20, 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            factor.riskFactor,
                            style: styleTextMain,
                            maxLines: factor.isExpanded ? 5 : 2,
                          ),
                          Text(
                            factor.riskRelatedLaw,
                            style: styleTextSub,
                            maxLines: factor.isExpanded ? 2 : 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // renderDeleteButton(
                  //   onpress: rskState.removeFactor,
                  //   todelete: factor,
                  // )
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: factor.isExpanded ? Icon(Icons.arrow_drop_up) : Icon(Icons.arrow_drop_down),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  renderManageTile({required Function ontap, required int index}) {
    final rskState = Provider.of<RiskProvider>(context);
    var factor = rskState.factorList![index];
    const styleTextManage = TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w300, fontSize: 12);

    var divider = Container(
      height: 10,
      decoration: BoxDecoration(border: boxBorder),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Divider(
          thickness: 3,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );

    if (factor.isExpanded) {
      var manageList = factor.manageList
          .map((manage) => appendDissmissDelete(
                key: UniqueKey(),
                swipeL: rskState.removeManage,
                para1: factor,
                para2: manage,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: boxBorder,
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.0),
                        child: CircleAvatar(
                          radius: 6,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          manage.stdSafetyMeasure,
                          style: styleTextManage,
                          maxLines: 4,
                        ),
                      ),
                      SizedBox(
                        width: 36,
                      ),
                      // Icon(Icons.delete)
                    ],
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
        onTap: () => showDialog(
            context: context,
            builder: (_) => ChangeNotifierProvider.value(
                  value: rskState,
                  child: AlertDialog(
                    content: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.8,
                      child: form,
                    ),
                  ),
                )),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            border: boxBorder,
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  renderRiskCalculater() {}

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
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).primaryColor,
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
