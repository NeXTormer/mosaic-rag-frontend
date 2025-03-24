sealed class ChatState {
  ChatState(
      this.conversationID, this.taskID, this.model, this.column, this.messages);

  final List<String> messages;

  final String conversationID;
  final String taskID;

  final String model;
  final String column;
}

class NoChat extends ChatState {
  NoChat(String model, String column) : super('', '', model, column, []);
}

class InitializingChat extends ChatState {
  InitializingChat(
      String conversationID, String taskID, String model, String column)
      : super(conversationID, taskID, model, column, []);
}

class LLMIsThinkingChat extends ChatState {
  LLMIsThinkingChat(String conversationID, String taskID, String model,
      String column, List<String> messages)
      : super(conversationID, taskID, model, conversationID, messages);
}

class FinishedChat extends ChatState {
  FinishedChat(String conversationID, String taskID, String model,
      String column, List<String> messages)
      : super(conversationID, taskID, model, conversationID, messages);
}

sealed class ChatEvent {}

class UserChatEvent extends ChatEvent {
  UserChatEvent(this.message);

  final String message;
}

class EditSettingsChatEvent extends ChatEvent {
  EditSettingsChatEvent(this.model, this.column);

  final String model;
  final String column;
}

class ResetChatEvent extends ChatEvent {}

class StartChatEvent extends ChatEvent {
  StartChatEvent(this.taskID, this.model, this.column);

  final String taskID;
  final String model;
  final String column;
}
