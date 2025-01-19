import 'dart:convert';

class ResultList {
  ResultList(this.data);

  ResultList.fromJSON(dynamic json) : data = [] {
    data = jsonDecode(json).cast<Map<String, dynamic>>();
  }

  List<Map<String, dynamic>> data;
}
