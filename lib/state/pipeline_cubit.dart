import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaic_rag_frontend/main.dart';
import 'package:mosaic_rag_frontend/state/mosaic_pipeline_state.dart';
import 'package:mosaic_rag_frontend/study_logger.dart';

import 'mosaic_pipeline_step.dart';
import '../api/mosaic_rs.dart';

class PipelineCubit extends Cubit<PipelineState> {
  PipelineCubit(super.initialState) {}

  @override
  void emit(PipelineState state) {
    // --- YOUR CUSTOM TRACING LOGIC GOES HERE ---

    // Optional: Only run this logic in debug mode to avoid performance
    // impact in your production app.
    if (false) {
      print('--- CUBIT EMIT TRACE ---');
      print('(${this.runtimeType}) Emitting new state: $state');
      print(StackTrace.current);
      print('--------------------------');
    }

    // --- END OF CUSTOM LOGIC ---

    // CRITICAL: You MUST call super.emit(state).
    // If you forget this line, the state will not actually be updated
    // and no listeners or observers will be notified.
    super.emit(state);
  }

  void loadInitialConfiguration() async {
    List<MosaicPipelineStep> allSteps = <MosaicPipelineStep>[];
    List<MosaicPipelineStep> currentSteps = <MosaicPipelineStep>[];

    List<String> categories = <String>[];

    final data = await MosaicRS.getPipelineInfo();
    data.keys.forEach((key) {
      final parameters = Map.from(data[key]['parameters']);
      final parameterDescriptions = <String, MosaicPipelineStepParameter>{};
      for (final parameter in parameters.entries) {
        final p = MosaicPipelineStepParameter(
            title: parameter.value['title'], type: parameter.value['type']);

        if (parameter.value.containsKey('description'))
          p.description = parameter.value['description'];

        if (parameter.value.containsKey('enforce-limit'))
          p.enforceLimit = parameter.value['enforce-limit'];

        if (parameter.value.containsKey('required'))
          p.required = parameter.value['required'];

        if (parameter.value.containsKey('supported-values'))
          p.supportedValues =
              List<String>.from(parameter.value['supported-values']);

        if (parameter.value.containsKey('default'))
          p.defaultValue = parameter.value['default'];

        parameterDescriptions[parameter.key] = p;
      }

      final category = data[key]['category'];
      final step = MosaicPipelineStep(data[key]['name'], category,
          data[key]['description'], key, parameterDescriptions);

      if (!categories.contains(category)) {
        categories.add(category);
      }

      allSteps.add(step);

      if (step.id == 'mosaic_datasource') {
        currentSteps.add(MosaicPipelineStep.clone(step));
      }
    });

    // TODO: error handling
    if (Uri.base.queryParameters['id'] != null) {
      final pipelineID = Uri.base.queryParameters['id']!;
      currentSteps = await MosaicRS.getPipelineStateFromID(pipelineID);
    } else if (config['pipeline'] != null) {
      currentSteps = await MosaicRS.getPipelineStateFromJSON(
          jsonEncode({'pipeline': config['pipeline']}));
    }

    emit(state.copyWith(
        allSteps: allSteps,
        currentSteps: currentSteps,
        categories: categories));
  }

  void restorePipeline(List<MosaicPipelineStep> steps) {
    emit(state.copyWith(currentSteps: steps));
  }

  void reorderStep(int oldIndex, int newIndex) {
    // final steps = List<MosaicPipelineStep>.from(state.currentSteps);
    final steps = state.currentSteps;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = steps.removeAt(oldIndex);
    steps.insert(newIndex, item);

    emit(state.copyWith(currentSteps: steps));
  }

  void addStep(MosaicPipelineStep step) {
    StudyLogger().logAddPipelineStep(
        stepName: step.id,
        pipelineState: MosaicRS.getPipelineJSON(state.currentSteps, {}));
    emit(state.copyWith(
        currentSteps: state.currentSteps..add(MosaicPipelineStep.clone(step))));
  }

  void removeStep(MosaicPipelineStep step) {
    StudyLogger().logRemovePipelineStep(
        stepName: step.id,
        pipelineState: MosaicRS.getPipelineJSON(state.currentSteps, {}));
    emit(state.copyWith(currentSteps: state.currentSteps..remove(step)));
  }
}
