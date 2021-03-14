import 'dart:convert';
import 'dart:io';

import 'package:ag_viewer/constants.dart';
import 'package:ag_viewer/models/program_object.dart';

enum ProgramType { all, today, now }

class AgApi {
  final _httpClient = HttpClient();

  Future<List<List<ProgramObject>>> getProgramData({
    required ProgramType type,
  }) async {
    Uri uri;
    switch (type) {
      case ProgramType.all:
        uri = Uri.https('agqr.sun-yryr.com', '/api/all', <String, dynamic>{
          'isRepeat': 'true',
        });
        break;
      case ProgramType.today:
        uri = Uri.https('agqr.sun-yryr.com', '/api/today', <String, dynamic>{
          'isRepeat': 'true',
        });
        break;
      default:
        uri = Uri.https('agqr.sun-yryr.com', '/api/now', <String, dynamic>{
          'isRepeat': 'true',
        });
    }
    final response = await _getRequest(uri);
    final lists = (json.decode(response) as List<dynamic>)
        .map((dynamic list) => list as List<dynamic>)
        .toList();
    return lists.map((List<dynamic> list) {
      return list
          .where((dynamic e) => e['isRepeat'] != null)
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
      if (Constants.of().isPrd()) {
        request.headers.add('user-agent', 'email:mochiogaile@gmail.com');
      }
      return request.close();
    });
    return response.transform(utf8.decoder).join();
  }
}
