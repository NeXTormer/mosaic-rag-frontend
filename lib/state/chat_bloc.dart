import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaic_rs_application/api/mosaic_rs.dart';
import 'package:mosaic_rs_application/state/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(super.initialState) {
    on<UserChatEvent>(_queryModel);
    on<StartChatEvent>(_initChat);
    on<ResetChatEvent>(_resetChat);
    on<EditSettingsChatEvent>(_editSettings);
  }

  void _queryModel(UserChatEvent event, emit) async {
    assert(!(state is NoChat));

    emit(LLMIsThinkingChat(state.conversationID, state.taskID, state.model,
        state.column, List.of(state.messages..add(event.message))));

    final response = await MosaicRS.chat(state.taskID, state.conversationID,
        state.model, state.column, event.message);

    if (!(state is LLMIsThinkingChat)) {
      assert(false);
      emit(NoChat('', ''));
      return;
    }

    emit(FinishedChat(state.conversationID, state.taskID, state.model,
        state.column, List.of(state.messages..add(response))));
  }

  void _initChat(StartChatEvent event, emit) async {
    assert(state is NoChat);

    emit(InitializingChat('', event.taskID, event.model, event.column));

    final response =
        await MosaicRS.chat(state.taskID, 'new', state.model, state.column, '');

    if (!(state is InitializingChat)) {
      assert(false);
      emit(NoChat('', ''));
      return;
    }

    emit(FinishedChat(response, event.taskID, event.model, event.column, []));
  }

  void _resetChat(ResetChatEvent event, emit) {
    emit(NoChat('', ''));
  }

  void _editSettings(EditSettingsChatEvent event, emit) {
    assert(state is NoChat);

    emit(NoChat(event.model, event.column));
  }
}
