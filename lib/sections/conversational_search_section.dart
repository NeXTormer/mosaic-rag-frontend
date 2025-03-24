import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/state/chat_bloc.dart';
import 'package:mosaic_rs_application/state/chat_state.dart';
import 'package:mosaic_rs_application/state/task_bloc.dart';
import 'package:mosaic_rs_application/state/task_state.dart';
import 'package:mosaic_rs_application/widgets/chat_message.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_button.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_drop_down_text_field.dart';
import 'package:shimmer/shimmer.dart';

class ConversationalSearchSection extends StatefulWidget {
  ConversationalSearchSection({super.key});

  @override
  State<ConversationalSearchSection> createState() =>
      _ConversationalSearchSectionState();
}

class _ConversationalSearchSectionState
    extends State<ConversationalSearchSection> {
  final TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(builder: (context, taskState) {
      return BlocBuilder<ChatBloc, ChatState>(builder: (context, chatState) {
        return Padding(
          padding:
              const EdgeInsets.only(top: 4, right: 24, bottom: 16, left: 56),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 140,
                      child: FredericButton(
                          switch (chatState) {
                            NoChat() => 'Start chat',
                            InitializingChat() => 'Starting...',
                            _ => 'Reset chat',
                          },
                          mainColor: switch ((chatState, taskState)) {
                            (NoChat(), TaskFinished()) => theme.mainColor,
                            (InitializingChat(), _) => theme.mainColor,
                            (FinishedChat(), _) => theme.negativeColor,
                            (LLMIsThinkingChat(), _) => theme.negativeColor,
                            (_, _) => theme.disabledGreyColor,
                          }, onPressed: () {
                        if (chatState is NoChat) {
                          if (taskState is TaskFinished) {
                            BlocProvider.of<ChatBloc>(context).add(
                                StartChatEvent(taskState.currentTaskID,
                                    'gemma2', 'full-text'));
                          }
                        } else if (chatState is InitializingChat) {
                        } else {
                          BlocProvider.of<ChatBloc>(context)
                              .add(ResetChatEvent());
                        }
                      })),
                  Expanded(child: Container()),
                  SizedBox(
                    width: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Language model',
                          style: TextStyle(
                              fontSize: 11, color: theme.greyTextColor),
                        ),
                        IgnorePointer(
                          ignoring: true, //!(chatState is NoChat),
                          child: FredericDropDownTextField(
                              onSubmit: (s) => null,
                              defaultValue: 'gemma2',
                              suggestedValues: [
                                'gemma2',
                                'qwen2.5',
                                'llama3.1'
                              ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Text column',
                          style: TextStyle(
                              fontSize: 11, color: theme.greyTextColor),
                        ),
                        const SizedBox(height: 2),
                        IgnorePointer(
                          ignoring: true, //!(chatState is NoChat),
                          child: FredericDropDownTextField(
                              onSubmit: (s) => null,
                              defaultValue: 'full-text',
                              suggestedValues: [
                                'full-text',
                                'summary',
                                'filtered-text'
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: FredericCard(
                  padding: const EdgeInsets.all(10),
                  child: switch ((chatState, taskState)) {
                    (NoChat(), TaskDoesNotExist()) => Center(
                        child: Text(
                            'Make a search request and press \'Start chat\' to have a conversation about the search results.'),
                      ),
                    (NoChat(), TaskInProgress()) => Center(
                        child: Text(
                            'Wait until the current task is completed before starting a conversation.'),
                      ),
                    (NoChat(), TaskFinished()) => Center(
                        child: Text(
                            'Press \'Start chat\' to have a conversation about the current search results.'),
                      ),
                    (InitializingChat(), _) => Center(
                          child: SizedBox(
                        height: 200,
                        width: 200,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballClipRotateMultiple,
                          colors: [theme.mainColor, theme.accentColor],
                        ),
                      )),
                    (FinishedChat() || LLMIsThinkingChat(), _) => Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              reverse: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...chatState.messages
                                      .asMap()
                                      .entries
                                      .map<Widget>((entry) => ChatMessage(
                                          message: entry.value,
                                          isUser: entry.key % 2 == 0))
                                      .toList(),
                                  if (chatState is LLMIsThinkingChat)
                                    ChatMessage(message: '', shimmer: true)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: chatController,
                            textInputAction: TextInputAction.none,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.textColor,
                            ),
                            onSubmitted: (query) {
                              if (chatState is FinishedChat) {
                                BlocProvider.of<ChatBloc>(context)
                                    .add(UserChatEvent(query));
                                chatController.clear();
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hoverColor: null,
                              hintStyle: TextStyle(color: theme.greyTextColor),
                              prefixIcon: Icon(
                                Icons.question_answer_outlined,
                                color: theme.mainColorInText,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    right: 8, top: 4, bottom: 4),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: theme.mainColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              hintText:
                                  'Ask anything about the search results...',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    width: 0.6, color: theme.mainColor),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    width: 0.6, color: theme.greyColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    width: 0.6, color: theme.greyColor),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(width: 0.6)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      width: 0.6, color: theme.greyColor)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      width: 0.6, color: theme.greyColor)),
                            ),
                          )
                        ],
                      )
                  },
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
