import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaic_rs_application/api/mosaic_rs.dart';
import 'package:mosaic_rs_application/state/result_list.dart';
import 'package:mosaic_rs_application/state/task_state.dart';
import 'package:mosaic_rs_application/state/task_progress.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(super.initialState) {
    on<CancelTaskEvent>((event, emit) async {
      print("WERNER");
      print(state);
      assert(state is TaskInProgress);
      if (state is TaskInProgress) {
        print('process CancelTaskEvent');

        await MosaicRS.cancelTask((state as TaskInProgress).currentTaskID);
        emit(TaskDoesNotExist());
      }
    });

    on<StartTaskEvent>(_startTask);
  }

  void _startTask(StartTaskEvent event, emit) async {
    if (state is TaskInProgress) return;

    emit(TaskInProgress(TaskProgress(), 'None'));

    final query = event.query;
    final steps = event.steps;

    Map<String, dynamic> parameters = {};

    parameters['pipeline'] = <String, dynamic>{
      'query': query,
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
    TaskProgress? progress;

    var stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!(state is TaskInProgress)) {
        // just in case
        emit(TaskDoesNotExist());
        return;
      }

      progress = await MosaicRS.getTaskProgress(taskID);
      emit(TaskInProgress(progress, taskID));

      if (progress.hasFinished) {
        break;
      }
    }

    final resultList = progress.result;
    stopwatch = Stopwatch()..start();

    List<String> resultColumns = [];
    List<String> chipColumns = [];
    Map<String, List<int>> resultColumnsWordCountList = {};
    Map<String, int> resultColumnsWordCount = {};

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
    assert(progress.result != null);
    emit(TaskFinished(
        currentTaskID: taskID,
        resultColumns: resultColumns,
        chipColumns: chipColumns,
        resultColumnsWordCount: resultColumnsWordCount,
        resultColumnsWordCountList: resultColumnsWordCountList,
        resultList: progress.result!));

    print('Result postprocessing time: ${stopwatch.elapsedMicroseconds} us');
  }
}
