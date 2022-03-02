import 'dart:convert';
import 'dart:developer';

import 'package:front/Controller/RiskDto.dart';
import 'package:front/Provider/RiskProvider.dart';
import 'package:http/http.dart' as http;

class AjaxRequest {
  static const String uri = "http://localhost:8080/api/v1/";

  static Future<dynamic> postProcess(RiskProvider riskProvider) async {
    String endPoint = "process";

    final response = await http.post(
      Uri.parse(uri + endPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(Process.fromModel(riskProvider)),
    );
    Map<String, dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));

    //todo log check
    final pretty = JsonEncoder.withIndent('    ').convert(responseJson);
    log("res: $pretty");
  }
}