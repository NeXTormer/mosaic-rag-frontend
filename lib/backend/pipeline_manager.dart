import 'package:flutter/cupertino.dart';

import '../state/mosaic_pipeline_step.dart';
import 'mosaic_rs.dart';

class PipelineManager extends ChangeNotifier {
  PipelineManager() {
    _getPipelineInfo();
  }

  List<MosaicPipelineStep> pipelineSteps = <MosaicPipelineStep>[];

  void _getPipelineInfo() async {
    final data = await MosaicRS.getPipelineInfo();
    data.keys.forEach((key) {
      final parameters = data[key]['parameters'];
      final step =
          MosaicPipelineStep(data[key]['name'], key, Map.from(parameters));

      pipelineSteps.add(step);
    });
  }

  void init() {}
}
