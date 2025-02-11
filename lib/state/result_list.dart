import 'dart:convert';

class ResultList {
  ResultList(this.data, this.metadata);

  ResultList.fromJSON(dynamic dataJSON, dynamic metadataJSON)
      : data = [],
        metadata = [] {
    data = jsonDecode(dataJSON).cast<Map<String, dynamic>>();
    metadata = jsonDecode(metadataJSON).cast<Map<String, dynamic>>();
  }

  List<Map<String, dynamic>> data;
  List<Map<String, dynamic>> metadata;
}
