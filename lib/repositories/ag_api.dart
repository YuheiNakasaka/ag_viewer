import 'dart:convert';
import 'dart:io';

import 'package:ag_viewer/models/program_object.dart';
import 'package:flutter/material.dart';

enum ProgramType { all, today, now }

class AgApi {
  final _httpClient = HttpClient();

  Future<List<List<ProgramObject>>> getProgramData({
    @required ProgramType type,
  }) async {
    Uri uri;
    switch (type) {
      case ProgramType.all:
        uri = Uri.https('agqr.sun-yryr.com', '/api/all');
        break;
      case ProgramType.today:
        uri = Uri.https('agqr.sun-yryr.com', '/api/today');
        break;
      default:
        uri = Uri.https('agqr.sun-yryr.com', '/api/now');
    }
    final response = await _getRequest(uri);
    final lists = (json.decode(response) as List<dynamic>)
        .map((dynamic list) => list as List<dynamic>)
        .toList();
    return lists.map((List<dynamic> list) {
      return list
          .map((dynamic json) =>
              ProgramObject.fromDocument(json as Map<String, dynamic>))
          .toList();
    }).toList();
  }

  Future<String> _getRequest(Uri uri) async {
    print(uri);
    final response =
        await _httpClient.getUrl(uri).then((HttpClientRequest request) {
      request.headers.add('content-type', 'application/json; charset=utf-8');
      return request.close();
    });
    return response.transform(utf8.decoder).join();
  }
}
