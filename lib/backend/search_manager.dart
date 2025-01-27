import 'package:flutter/cupertino.dart';
import 'package:mosaic_rs_application/backend/mosaic_rs.dart';
import 'package:mosaic_rs_application/backend/result_list.dart';
import 'package:mosaic_rs_application/backend/task_progress.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_step.dart';
import 'package:provider/provider.dart';

class SearchManager extends ChangeNotifier {
  static final Duration timeout = const Duration(minutes: 3);

  String query = '';

  // ResultList resultList = ResultList([]);
  TaskProgress taskProgress = TaskProgress();
  String currentTaskID = '';

  List<String> resultColumns = <String>[];
  List<String> chipColumns = <String>[];
  Map<String, List<int>> resultColumnsWordCountList = Map<String, List<int>>();
  Map<String, int> resultColumnsWordCount = Map<String, int>();

  bool showLoadingBar = false;

  ResultList get resultList {
    return taskProgress.result ?? ResultList([]);
  }

  List<Map<String, dynamic>> get metadata {
    return taskProgress.metadata ?? <Map<String, dynamic>>[];
  }

  // void performSearch(String query) async {
  //   showLoadingBar = true;
  //   notifyListeners();
  //
  //   this.query = query;
  //
  //   resultList = await MosaicRS.search(query);
  //
  //   showLoadingBar = false;
  //   notifyListeners();
  // }

  void cancelTask() async {
    await MosaicRS.cancelTask(currentTaskID);
    currentTaskID = '';
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

    String taskID = await MosaicRS.enqueueTask(parameters);
    currentTaskID = taskID;

    var stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (stopwatch.elapsed > timeout) {
        break;
      }

      taskProgress = await MosaicRS.getTaskProgress(taskID);
      notifyListeners();
      if (taskProgress.result != null) {
        break;
      }
    }

    stopwatch = Stopwatch();

    stopwatch.start();

    resultColumns.clear();
    resultColumnsWordCount.clear();
    chipColumns.clear();

    for (final result in resultList.data) {
      for (final key in result.keys) {
        if (!resultColumns.contains(key)) {
          resultColumns.add(key);
        }
      }
    }

    // only get columns that exist in every row
    for (final result in resultList.data) {
      for (final column in resultColumns) {
        if (!result.containsKey(column)) {
          resultColumns.remove(column);
        }
      }
    }

    for (final column in resultColumns) {
      resultColumnsWordCountList[column] = <int>[];
    }

    for (final result in resultList.data) {
      for (final column in resultColumns) {
        if (result[column] is String) {
          resultColumnsWordCountList[column]!.add(result[column].length);
        } else {
          resultColumnsWordCountList[column]!.add('${result[column]}'.length);
        }
      }
    }

    for (final column in resultColumns) {
      resultColumnsWordCountList[column]!.sort();
      resultColumnsWordCount[column] = resultColumnsWordCountList[column]![
          resultColumnsWordCountList[column]!.length ~/ 2];
    }

    var sortedEntries = resultColumnsWordCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final x = Map.fromEntries(sortedEntries);

    resultColumns = x.keys.toList();

    for (final column in resultColumns) {
      if (x[column]! < 6) {
        chipColumns.add(column);
      }
    }

    stopwatch.stop();
    print('Result postprocessing time: ${stopwatch.elapsedMicroseconds} us');

    currentTaskID = '';
    showLoadingBar = false;
    notifyListeners();
  }
}
