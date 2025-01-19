import 'package:flutter/cupertino.dart';

import '../state/mosaic_pipeline_step.dart';
import 'mosaic_rs.dart';

class PipelineManager extends ChangeNotifier {
  PipelineManager() {
    _getPipelineInfo();
  }

  List<MosaicPipelineStep> allPipelineSteps = <MosaicPipelineStep>[];
  List<MosaicPipelineStep> pipelineSteps = <MosaicPipelineStep>[];

  void _getPipelineInfo() async {
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
      final step =
          MosaicPipelineStep(data[key]['name'], key, parameterDescriptions);

      allPipelineSteps.add(step);

      if (step.id == 'mosaic_datasource') {
        pipelineSteps.add(MosaicPipelineStep.clone(step));
      }

      notifyListeners();
    });
  }

  void addStep(MosaicPipelineStep step) {
    pipelineSteps.add(MosaicPipelineStep.clone(step));
    notifyListeners();
  }

  void removeStep(MosaicPipelineStep step) {
    pipelineSteps.remove(step);
    notifyListeners();
  }

  void init() {}
}
