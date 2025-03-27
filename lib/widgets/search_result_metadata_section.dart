import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mosaic_rag_frontend/state/task_bloc.dart';
import 'package:mosaic_rag_frontend/state/task_state.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_heading.dart';

class SearchResultMetadataSection extends StatelessWidget {
  const SearchResultMetadataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
      if (state is TaskFinished && state.taskInfo.aggregated_data.isNotEmpty)
        return SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 56, right: 16, top: 16, bottom: 0),
            child: FredericCard(
              animated: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FredericHeading(
                        state.taskInfo.aggregated_data.first['title']),
                    const SizedBox(height: 8),
                    MarkdownBody(
                        shrinkWrap: true,
                        selectable: true,
                        data: state.taskInfo.aggregated_data.first['data']),
                  ],
                ),
              ),
            ),
          ),
        );
      return SliverToBoxAdapter(child: Container());
    });
  }
}
