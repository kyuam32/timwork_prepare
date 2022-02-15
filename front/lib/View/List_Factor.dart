import 'package:flutter/material.dart';
import 'package:front/Model/FactorModel.dart';
import 'package:front/Provider/RiskProvider.dart';
import 'package:front/View/Form_Factor.dart';
import 'package:front/View/Form_Manage.dart';
import 'package:provider/provider.dart';

class ListFactor extends StatefulWidget {
  const ListFactor({Key? key}) : super(key: key);

  @override
  State<ListFactor> createState() => _ListFactorState();
}

class _ListFactorState extends State<ListFactor> {
  @override
  Widget build(BuildContext context) {
    final rskState = Provider.of<RiskProvider>(context);
    final label = Positioned(
      top: 0,
      left: 8,
      child: Container(
        padding: const EdgeInsets.only(left: 3, right: 3),
        color: Colors.white,
        child: const Text(
          "위험 요인",
          style: TextStyle(
            color: Color.fromARGB(170, 0, 0, 0),
            fontSize: 12,
            fontWeight: FontWeight.w100
          ),
        ),
      ),
    );

    if (rskState.factorList == null) {
      return Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black26),
                borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            child: const Center(
              child: Text(
                "작업을 선택해 주세요",
                textScaleFactor: 1.5,
              ),
            ),
          ),
          label,
        ],
      );
    } else {
      return Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black26),
                borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            child: renderFactorList(),
          ),
          label,
        ],
      );
    }
  }

  renderFactorList() {
    final rskState = Provider.of<RiskProvider>(context);
    final factors = rskState.factorList;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: factors!.length + 1,
      itemBuilder: (context, index) {
        if (index < factors.length) {
          var factor = factors[index];

          return Column(
            children: [
              renderTileBox(
                onTapFn: rskState.toggleFactorExpand,
                onTapPara: factor,
                child: Stack(
                  children: [
                    ListTile(
                      // onTap: () => rskState.toggleFactorExpand(factor),
                      leading: renderFactorAvatar(factor: factor),
                      title: Text(factor.riskFactor),
                      subtitle: Text(factor.riskRelatedLaw),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: renderUtilityBox(factor: factor),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: factor.isExpanded
                            ? const Icon(Icons.expand_less)
                            : const Icon(Icons.expand_more),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: factor.isExpanded, child: renderManageList(factor)),
            ],
          );
        }
        return renderAddButton(const FormFactor());
      },
    );
  }

  renderTileBox({required Function onTapFn, required dynamic onTapPara, required Widget child}) {

    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => onTapPara != null ? onTapFn(onTapPara): onTapFn(),
        // onTap: () => rskState.toggleFactorExpand(factor),
        child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                width: 1,
                color: Colors.black26,
              ),
            ),
            child: child
        ),
      ),
    );
  }

  renderManageList(factor) {
    final rskState = Provider.of<RiskProvider>(context);

    return ListView.builder(
        shrinkWrap: true,
        itemCount: factor.manageList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < factor.manageList.length) {
            var manage = factor.manageList[index];

            return Column(
              children: [
                renderTileBox(
                  onTapFn: (){},
                  onTapPara: null,
                  child: ListTile(
                    title: Text(manage.stdSafetyMeasure),
                    trailing: IconButton(
                      icon: manage.isManaged
                          ? const Icon(Icons.check_box_outlined)
                          : const Icon(Icons.check_box_outline_blank),
                      onPressed: () {
                        manage.isManaged = !manage.isManaged;
                        rskState.setManagedLevel(factor);
                        if (factor.managedLevel == 1) {
                          rskState.toggleFactorExpand(factor);
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              renderAddButton(FormManage(factor: factor)),
              const SizedBox(
                height: 20,
              )
            ],
          );
        });
  }

  renderFactorAvatar({required FactorModel factor}) {
    return CircleAvatar(
      backgroundColor: factor.managedLevel > 0.79
          ? Colors.lightGreen
          : factor.managedLevel > 0.49
              ? Colors.amber
              : Colors.deepOrange,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          factor.riskCate1Name.split(" ").first,
          textAlign: TextAlign.center,
          textScaleFactor: 0.7,
        ),
      ),
    );
  }

  renderUtilityBox({required FactorModel factor}) {
    final rskState = Provider.of<RiskProvider>(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          width: constraints.maxWidth * 0.1,
          child: IconButton(
            onPressed: () => rskState.removeFactor(factor),
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }

  renderAddButton(formView) {
    final rskState = Provider.of<RiskProvider>(context);

    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: renderTileBox(
        onTapPara: null,
          onTapFn: () => showDialog(
            context: context,
            builder: (_) => ChangeNotifierProvider<RiskProvider>.value(
              value: rskState,
              child: AlertDialog(
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: formView,
                ),
              ),
            ),
          ),
          child: Icon(Icons.add),
      ),
    );
  }
}

