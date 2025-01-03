import 'package:flutter/cupertino.dart';
import 'package:mosaic_rs_application/backend/mosaic_rs.dart';
import 'package:mosaic_rs_application/backend/result_list.dart';
import 'package:provider/provider.dart';

class SearchManager extends ChangeNotifier {
  String query = '';

  ResultList resultList = ResultList([]);

  bool showLoadingBar = false;

  void performSearch(String query) async {
    showLoadingBar = true;
    notifyListeners();

    this.query = query;

    resultList = await MosaicRS.search(query);

    showLoadingBar = false;
    notifyListeners();
  }
}
