import 'package:flutter/cupertino.dart';
import 'package:mosaic_rs_application/backend/mosaic_rs.dart';
import 'package:mosaic_rs_application/backend/result_list.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_step.dart';
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

  void runPipeline(String query, List<MosaicPipelineStep> steps) async {
    showLoadingBar = true;
    notifyListeners();

    this.query = query;

    Map<String, dynamic> parameters = {};

    parameters['pipeline'] = <String, dynamic>{
      'query': query,
      // 'arguments': {},
    };

    for (int i = 0; i < steps.length; i++) {
      final index = i + 1;
      final step = steps[i];

      final parameterData = step.parameterData;
      List<String> parametersToRemove = [];
      for (final entry in parameterData.entries) {
        if (entry.value.isEmpty) parametersToRemove.add(entry.key);
      }
      for (final param in parametersToRemove) parameterData.remove(param);

      parameters['pipeline']['$index'] = <String, dynamic>{
        'id': step.id,
        'parameters': step.parameterData
      };
    }

    resultList = await MosaicRS.runPipeline(parameters);

    showLoadingBar = false;
    notifyListeners();
  }
}
