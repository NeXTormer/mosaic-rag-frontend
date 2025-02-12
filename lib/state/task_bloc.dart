import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaic_rs_application/api/mosaic_rs.dart';
import 'package:mosaic_rs_application/state/task_state.dart';
import 'package:mosaic_rs_application/state/task_progress.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(super.initialState) {
    on<CancelTaskEvent>((event, emit) async {
      assert(state is TaskInProgress);
      if (state is TaskInProgress) {
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
    TaskInfo? taskInfo;

    var stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));

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

    emit(TaskFinished(currentTaskID: taskID, taskInfo: taskInfo));

    print('Result postprocessing time: ${stopwatch.elapsedMicroseconds} us');
  }
}
