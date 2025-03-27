import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaic_rs_application/api/mosaic_rs.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_step.dart';
import 'package:mosaic_rs_application/state/task_state.dart';
import 'package:mosaic_rs_application/state/task_progress.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(super.initialState) {
    on<CancelTaskEvent>((event, emit) async {
      if (state is TaskInProgress) {
        MosaicRS.cancelTask((state as TaskInProgress).currentTaskID);
        emit(TaskDoesNotExist());
      }
    });

    on<ResetTaskEvent>((event, emit) {
      assert(state is TaskFinished);
      emit(TaskDoesNotExist());
    });

    on<StartTaskEvent>(_startTask);
    on<ChangeTaskDisplayEvent>(_changeTaskDisplayData);
  }

  void _startTask(StartTaskEvent event, emit) async {
    if (state is TaskInProgress) return;

    emit(TaskInProgress(TaskProgress(), 'None'));

    final parameters = MosaicRS.getPipelineParameters(event.steps, event.query);

    String taskID = await MosaicRS.enqueueTask(parameters);
    TaskInfo? taskInfo;

    var stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(milliseconds: 200));

      if (!(state is TaskInProgress)) {
        // just in case
        emit(TaskDoesNotExist());
        return;
      }

      taskInfo = await MosaicRS.getTaskProgress(taskID);
      emit(TaskInProgress(taskInfo.taskProgress, taskID));

      if (taskInfo.hasFinished) {
        break;
      }
    }

    String textPreviewColumn = '';
    String rankColumn = '';
    List<String> activeChipColumns = [];

    if (taskInfo.textColumns.contains('summary')) {
      textPreviewColumn = 'summary';
    } else if (taskInfo.textColumns.contains('full-text')) {
      textPreviewColumn = 'full-text';
    } else if (taskInfo.textColumns.isNotEmpty) {
      textPreviewColumn = taskInfo.textColumns.last;
    }

    if (taskInfo.rankColumns.isNotEmpty) {
      rankColumn = taskInfo.rankColumns.last;
      taskInfo.data.sort((a, b) => a[rankColumn] - b[rankColumn]);
    }

    final numberOfChipsToDisplay = min(taskInfo.chipColumns.length, 3);
    for (var i = 0; i < numberOfChipsToDisplay; i++) {
      activeChipColumns.add(taskInfo.chipColumns[i]);
    }

    emit(TaskFinished(
      currentTaskID: taskID,
      taskInfo: taskInfo,
      activeChipColumns: activeChipColumns,
      rankColumn: rankColumn,
      textPreviewColumn: textPreviewColumn,
    ));

    print('Result postprocessing time: ${stopwatch.elapsedMicroseconds} us');
  }

  void _changeTaskDisplayData(ChangeTaskDisplayEvent event, emit) {
    assert(state is TaskFinished);
    final s = state as TaskFinished;

    if (event.rankColumn != null) {
      s.taskInfo.data.sort((a, b) => a[event.rankColumn] - b[event.rankColumn]);
    }

    emit(TaskFinished(
      currentTaskID: s.currentTaskID,
      taskInfo: s.taskInfo,
      rankColumn: event.rankColumn ?? s.rankColumn,
      textPreviewColumn: event.textPreviewColumn ?? s.textPreviewColumn,
      activeChipColumns: event.activeChipColumns ?? s.activeChipColumns,
    ));
  }
}
