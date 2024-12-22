import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_step.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';

class MosaicPipelineStepCard extends StatelessWidget {
  MosaicPipelineStepCard({super.key, required this.pipelineStep});

  final MosaicPipelineStep pipelineStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FredericCard(
        color: theme.mainColorLight,
        borderColor: theme.mainColor,
        height: 200,
        width: double.infinity,
        child: Center(child: Text(pipelineStep.title)),
      ),
    );
  }
}
