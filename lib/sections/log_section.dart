import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rag_frontend/state/task_bloc.dart';
import 'package:mosaic_rag_frontend/state/task_state.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_card.dart';

class LogSection extends StatelessWidget {
  LogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(builder: (context, taskState) {
      List<String> logs = [];
      if (taskState is TaskInProgress) logs = taskState.taskProgress.logs;

      if (taskState is TaskFinished)
        logs = taskState.taskInfo.taskProgress.logs;

      return Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 24, bottom: 16, left: 56),
        child: FredericCard(
            height: double.infinity,
            width: double.infinity,
            child: CustomScrollView(
              reverse: true,
              slivers: [
                SliverList.builder(
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(left: 8, top: 4),
                          child: SelectableText(logs[index],
                              style: GoogleFonts.robotoMono(fontSize: 13)),
                        ),
                    itemCount: logs.length)
              ],
            )),
      );
    });
  }
}
