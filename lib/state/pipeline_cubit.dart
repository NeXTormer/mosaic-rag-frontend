import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaic_rag_frontend/state/mosaic_pipeline_state.dart';

import 'mosaic_pipeline_step.dart';
import '../api/mosaic_rs.dart';

class PipelineCubit extends Cubit<PipelineState> {
  PipelineCubit(super.initialState) {
    _getPipelineInfo();
  }

  void loadPipelineInfo() {}

  void _getPipelineInfo() async {
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

    emit(state.copyWith(
        allSteps: allSteps,
        currentSteps: currentSteps,
        categories: categories));
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

  void emitNewState() {
    emit(state);
  }

  void addStep(MosaicPipelineStep step) {
    emit(state.copyWith(
        currentSteps: state.currentSteps..add(MosaicPipelineStep.clone(step))));
  }

  void removeStep(MosaicPipelineStep step) {
    emit(state.copyWith(currentSteps: state.currentSteps..remove(step)));
  }
}
