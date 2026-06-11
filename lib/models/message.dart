class Message {
  const Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.isSentByMe,
  });

  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isSentByMe;
}
