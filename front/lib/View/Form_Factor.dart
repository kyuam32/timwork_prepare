import 'package:flutter/material.dart';
import 'package:front/Provider/RiskProvider.dart';
import 'package:provider/provider.dart';

class FormFactor extends StatefulWidget {
  const FormFactor({Key? key}) : super(key: key);

  @override
  _FormFactorState createState() => _FormFactorState();
}

class _FormFactorState extends State<FormFactor> {
  final formKey = GlobalKey<FormState>();

  String riskCate1Name = "";
  String riskCate2Name = "";
  String riskFactor = "";
  String riskRelatedLaw = "";

  @override
  Widget build(BuildContext context) {
    final rskState = Provider.of<RiskProvider>(context);

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
                    "[ " + rskState.taskCurrent!.taskName + " ] 작업 위험요인",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      renderTextFormField(
                          label: "위험요인 분류 1",
                          description: "위험요인이 가진 특성을 알려주세요.",
                          onSaved: (val) {
                            setState(() {
                              riskCate1Name = val;
                            });
                          },
                          validator: (val) {
                            if (val.length < 1) {
                              return "필수 항목입니다.";
                            }
                            return null;
                          }),
                      renderTextFormField(
                          label: "위험요인 분류 2",
                          description: "위험요인은 무엇으로부터 발생하는지 알려주세요.",
                          onSaved: (val) {
                            setState(() {
                              riskCate2Name = val;
                            });
                          },
                          validator: (val) {
                            if (val.length < 1) {
                              return "필수 항목입니다";
                            }
                            return null;
                          }),
                      renderTextFormField(
                          label: "상황 설명",
                          description: "위험요인을 방치하면 어떤 상황이 발생하는지 알려주세요.",
                          onSaved: (val) {
                            setState(() {
                              riskFactor = val;
                            });
                          },
                          validator: (val) {
                            if (val.length < 1) {
                              return "필수 항목입니다";
                            }
                            return null;
                          }),
                      renderTextFormField(
                          label: "위험요인 관련 규정",
                          description: "위험요인과 관련된 규정이 있나요.",
                          onSaved: (val) {
                            setState(() {
                              riskRelatedLaw = val;
                            });
                          },
                          validator: (val) {
                            return null;
                          }),
                      renderSubmitButton(),
                    ],
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
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState?.save();
          rskState.addFactor(riskCate1Name, riskCate2Name, riskFactor, riskRelatedLaw);
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
