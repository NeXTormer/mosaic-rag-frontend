import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_step.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_drop_down_text_field.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_text_field.dart';

class MosaicPipelineStepCard extends StatelessWidget {
  MosaicPipelineStepCard(
      {super.key, required this.step, this.height = 200, required this.index});

  final MosaicPipelineStep step;
  final double height;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
              Text(step.title,
                  maxLines: 1,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: theme.textColor,
                  )),
              SizedBox(height: 12),
              for (var entry in step.parameterDescriptions.entries) ...[
                Text(entry.value),
                FredericTextField(
                  entry.key,
                  icon: Icons.data_array,
                  onSubmit: (data) {
                    step.parameterData[entry.key] = data;
                  },
                ),
                SizedBox(height: 8),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
