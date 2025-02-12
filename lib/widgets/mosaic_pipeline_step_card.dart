import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rs_application/state/pipeline_cubit.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_step.dart';
import 'package:mosaic_rs_application/state/task_bloc.dart';
import 'package:mosaic_rs_application/state/task_state.dart';
import 'package:mosaic_rs_application/widgets/mosaic_pipeline_step_parameter_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/hover_icon_button.dart';
import 'package:zo_animated_border/widget/zo_dual_border.dart';

enum PipelineExecutionState { Idle, Running, Success, Error }

class MosaicPipelineStepCard extends StatelessWidget {
  MosaicPipelineStepCard(
      {super.key,
      required this.step,
      required this.index,
      this.activeStepIndex = -1,
      this.showDescription = false,
      this.bottomPadding = 16});

  final bool showDescription;
  final MosaicPipelineStep step;
  final int index;
  final int activeStepIndex;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final animateBorder = index == activeStepIndex;

    final restOfCard = FredericCard(
        // margin: EdgeInsets.only(bottom: 16),
        color: theme.mainColorLight,
        borderColor: theme.mainColor,
        borderWidth: animateBorder ? 0 : 1,
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
                if (!showDescription)
                  HoverIconButton(() {
                    BlocProvider.of<PipelineCubit>(context, listen: false)
                        .removeStep(step);
                  }),
              ],
            ),
            SizedBox(height: 12),
            if (showDescription) ...[
              Text(
                step.description,
                style: GoogleFonts.montserrat(
                    color: theme.textColor, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),
              Text(
                'Parameters',
                style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: theme.textColor,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                step.parameterDescriptions.values
                    .map((v) => v.title)
                    .toList()
                    .join(", "),
                style: GoogleFonts.montserrat(
                    color: theme.textColor, fontWeight: FontWeight.w400),
              ),
            ],
            if (!showDescription)
              Wrap(
                spacing: 16,
                children: [
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
          ],
        ));

    if (animateBorder)
      return ReorderableDragStartListener(
        index: index,
        child: ZoDualBorder(
          trackBorderColor: theme.greyColor,
          borderWidth: 1,
          // snakeHeadColor: theme.accentColor,
          // snakeTailColor: theme.mainColor,
          // duration: 3,
          duration: const Duration(seconds: 3),
          firstBorderColor: theme.mainColor,
          secondBorderColor: theme.mainColor,
          borderRadius: BorderRadius.circular(14),
          child: restOfCard,
        ),
      );

    return ReorderableDragStartListener(
      index: index,
      child: restOfCard,
    );
  }
}
