
import 'dart:convert';

import 'package:front/Controller/SubmitDto.dart';
import 'package:front/Provider/RiskProvider.dart';
import 'package:http/http.dart' as http;

class AjaxRequest {


  static Future<dynamic> postProcess(RiskProvider riskProvider) async {
    String uri = "http://localhost:8080/api/v1/process";

    final response = await http.post(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(Process.fromModel(riskProvider)),
    );
    Map<String, dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
    print(responseJson);
  }

  static Future<dynamic> getProcessList() async {
    String uri = "http://localhost:8080/api/v1/process";

    final response = await http.get(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );


    print(response.body);
  }
}