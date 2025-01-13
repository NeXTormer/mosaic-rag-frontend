import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rs_application/backend/pipeline_manager.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_step.dart';
import 'package:mosaic_rs_application/widgets/mosaic_pipeline_step_parameter_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_drop_down_text_field.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_text_field.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/hover_icon_button.dart';
import 'package:provider/provider.dart';

class MosaicPipelineStepCard extends StatelessWidget {
  MosaicPipelineStepCard(
      {super.key,
      required this.step,
      this.height = 200,
      required this.index,
      this.bottomPadding = 16});

  final MosaicPipelineStep step;
  final double height;
  final int index;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: ReorderableDragStartListener(
        index: index,
        child: FredericCard(
          color: theme.mainColorLight,
          borderColor: theme.mainColor,
          height: height,
          width: double.infinity,
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(step.title,
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: theme.textColor,
                        )),
                  ),
                  HoverIconButton(() {
                    Provider.of<PipelineManager>(context, listen: false)
                        .removeStep(step);
                  }),
                ],
              ),
              SizedBox(height: 12),
              for (var entry in step.parameterDescriptions.entries) ...[
                MosaicPipelineStepParameterCard(
                  parameter: entry.value,
                  onChanged: (data) {
                    step.parameterData[entry.key] = data;
                  },
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
