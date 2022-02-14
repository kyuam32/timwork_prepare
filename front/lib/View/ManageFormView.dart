import 'package:flutter/material.dart';
import 'package:front/Model/FactorModel.dart';
import 'package:front/Model/RiskProvider.dart';
import 'package:provider/provider.dart';

class ManageFormView extends StatefulWidget {
  const ManageFormView({Key? key, required this.factor}) : super(key: key);
  final FactorModel factor;

  @override
  _ManageFormViewState createState() => _ManageFormViewState();
}

class _ManageFormViewState extends State<ManageFormView> {
  final formKey = GlobalKey<FormState>();

  String stdRiskFactorSeq = "";

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 75,
                  child: Text(
                    "[ " + widget.factor.riskFactor + " ] 대처방안",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        renderTextFormField(
                            label: "위험요인 대처방안",
                            description: "위험요인을 어떻게 예방할 수 있을지 알려주세요.",
                            onSaved: (val) {
                              setState(() {
                                stdRiskFactorSeq = val;
                              });
                            },
                            validator: (val) {
                              if (val.length < 1) {
                                return "필수 항목입니다.";
                              }
                              return null;
                            }),
                        renderSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  renderSubmitButton() {
    final rskState = Provider.of<RiskProvider>(context);

    return ElevatedButton(
      child: Text("목록에 추가"),
      onPressed: (){
        if (formKey.currentState!.validate()){
          formKey.currentState?.save();
          rskState.addManage(widget.factor, stdRiskFactorSeq);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("새 항목이 추가됐습니다"),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      },
    );
  }

  renderTextFormField({
    required String label,
    required String description,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          TextFormField(
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: description,
            ),
          ),
        ],
      ),
    );
  }

}