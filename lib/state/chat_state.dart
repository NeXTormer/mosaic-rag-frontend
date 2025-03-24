sealed class ChatState {}

class EmptyChat extends ChatState {}

class LLMIsThinkingChat extends ChatState {}

class FinishedChat extends ChatState {}

sealed class ChatEvent {}

class UserChatEvent extends ChatEvent {}

class LLMChatEvent extends ChatEvent {}

class ResetChatEvent extends ChatEvent {}
