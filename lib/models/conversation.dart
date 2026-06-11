import 'message.dart';

class Conversation {
  const Conversation({
    required this.id,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.messages,
  });

  final String id;
  final String otherUserName;
  final String otherUserAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<Message> messages;
}
