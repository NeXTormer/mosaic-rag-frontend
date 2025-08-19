import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaic_rag_frontend/api/mosaic_rs.dart';
import 'package:mosaic_rag_frontend/main.dart';
import 'package:mosaic_rag_frontend/state/mosaic_pipeline_step.dart';
import 'package:mosaic_rag_frontend/state/task_state.dart';
import 'package:mosaic_rag_frontend/state/task_progress.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(super.initialState) {
    on<CancelTaskEvent>((event, emit) async {
      if (state is TaskInProgress) {
        MosaicRS.cancelTask((state as TaskInProgress).currentTaskID);
        emit(TaskDoesNotExist());
      }
    });

    on<ResetTaskEvent>((event, emit) {
      assert(state is TaskFinished ||
          state is TaskError ||
          state is TaskDoesNotExist);
      emit(TaskDoesNotExist());
    });

    on<StartTaskEvent>(_startTask);
    on<ChangeTaskDisplayEvent>(_changeTaskDisplayData);
  }

  // @override
  // void onChange(Change<TaskState> change) {
  //   super.onChange(change);
  //   print(' onChange - $change');
  // }

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
        print("state is not TaskInProgress while waiting on task");
        return;
      }

      taskInfo = await MosaicRS.getTaskProgress(taskID);
      emit(TaskInProgress(taskInfo.taskProgress, taskID));

      if (taskInfo.taskProgress.error.isNotEmpty) {
        emit(TaskError(
            taskInfo.taskProgress.error,
            taskInfo.taskProgress.errorStepIndex,
            taskInfo.taskProgress.logs,
            taskInfo.taskProgress.warnings));
        return;
      }

      if (taskInfo.hasFinished) {
        break;
      }
    }

    String textPreviewColumn = '';
    String rankColumn = '';
    List<String> activeChipColumns = [];

    //TODO: better null checking
    if ((config['defaultTextColumn'] ?? '').isNotEmpty) {
      textPreviewColumn = config['defaultTextColumn'];
    } else {
      if (taskInfo.textColumns.contains('summary')) {
        textPreviewColumn = 'summary';
      } else if (taskInfo.textColumns.contains('full-text')) {
        textPreviewColumn = 'full-text';
      } else if (taskInfo.textColumns.isNotEmpty) {
        textPreviewColumn = taskInfo.textColumns.last;
      }
    }
    if ((config['defaultRankColumn'] ?? '').isNotEmpty) {
      print('restoring rank column');
      rankColumn = config['defaultRankColumn'];
      if (taskInfo.rankColumns.isNotEmpty) {
        taskInfo.data.sort((a, b) => (a[rankColumn] - b[rankColumn]).round());
      }
    } else {
      print('finding best rank column');
      if (taskInfo.rankColumns.isNotEmpty) {
        rankColumn = taskInfo.rankColumns.last;
        taskInfo.data.sort((a, b) => (a[rankColumn] - b[rankColumn]).round());
      }
    }

    if ((config['defaultChips'] ?? []).length > 0) {
      activeChipColumns = config['defaultChips'];
    } else {
      final numberOfChipsToDisplay = min(taskInfo.chipColumns.length, 3);
      for (var i = 0; i < numberOfChipsToDisplay; i++) {
        activeChipColumns.add(taskInfo.chipColumns[i]);
      }
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
      s.taskInfo.data
          .sort((a, b) => (a[event.rankColumn] - b[event.rankColumn]).round());
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
