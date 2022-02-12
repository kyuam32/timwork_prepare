import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormView extends StatefulWidget {
  const FormView({Key? key}) : super(key: key);

  @override
  _FormViewState createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  final formKey = GlobalKey<FormState>();

  String riskCate1Name = "";
  String riskFactor = "";
  String riskRelatedLaw = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            renderTextFormField(
                label: "위험 요인의 종류",
                onSaved: (val) {
                  setState(() {
                    riskCate1Name = val;
                  });
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "필수 필드입니다.";
                  }
                  return null;
                }),
            renderTextFormField(
                label: "위험 요인 설명",
                onSaved: (val) {
                  setState(() {
                    riskFactor = val;
                  });
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "필수 필드입니다.";
                  }
                  return null;
                }),
            renderTextFormField(
                label: "위험 요인 관련 규정",
                onSaved: (val) {
                  setState(() {
                    riskRelatedLaw = val;
                  });
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "필수 필드입니다.";
                  }
                  return null;
                }),
            renderSubmitButton(),
            renderStates(),
          ],
        ),
      ),
    );
  }

  renderStates() {
    return Column(
      children: [
        Text("riskCate1Name :$riskCate1Name"),
        Text("riskFactor :$riskFactor"),
        Text("riskRelatedLaw :$riskRelatedLaw"),
      ],
    );
  }

  renderSubmitButton() {
    return ElevatedButton(
      child: Text("작업 추가"),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState?.save();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("저장 성공"),
              backgroundColor: Colors.amberAccent,
            ),
          );
        }
      },
    );
  }

  renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {
    assert(label != null);
    assert(onSaved != null);
    assert(validator != null);

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
              )
            ],
          ),
          TextFormField(
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: AutovalidateMode.always,
          ),
        ],
      ),
    );
  }
}
