import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/backend/pipeline_manager.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_step.dart';
import 'package:provider/provider.dart';

import 'mosaic_pipeline_step_card.dart';

class AddPipelineDialog extends StatelessWidget {
  AddPipelineDialog(this.allSteps, {super.key, required this.onSelect});

  final Function(MosaicPipelineStep) onSelect;
  final List<MosaicPipelineStep> allSteps;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth * 0.4,
            height: constraints.maxHeight * 0.8,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: allSteps
                      .map((step) => Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  height: 430,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    child: IgnorePointer(
                                        child: MosaicPipelineStepCard(
                                            bottomPadding: 0,
                                            step: step,
                                            index: 1)),
                                    onTap: () {
                                      onSelect(step);
                                      Navigator.of(context).pop();
                                    },
                                  )),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
