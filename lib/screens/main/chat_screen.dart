import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/conversation.dart';
import 'package:i_bazaar/models/message.dart';
import 'package:i_bazaar/widgets/chat/conversation_tile.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static final List<Conversation> mockConversations = [
    Conversation(
      id: '1',
      otherUserName: 'Khazin',
      otherUserAvatar: '',
      lastMessage: 'Is the lightsaber still available?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      messages: [
        Message(
          senderId: 'them',
          receiverId: 'me',
          text: 'Hey, is the lightsaber still available?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          isSentByMe: false,
        ),
        Message(
          senderId: 'me',
          receiverId: 'them',
          text: 'Yes, it is!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          isSentByMe: true,
        ),
        Message(
          senderId: 'them',
          receiverId: 'me',
          text: 'Is the lightsaber still available?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isSentByMe: false,
        ),
      ],
    ),
    Conversation(
      id: '2',
      otherUserName: 'Ali',
      otherUserAvatar: '',
      lastMessage: 'Can you do 10 for the dragon?',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      messages: [
        Message(
          senderId: 'them',
          receiverId: 'me',
          text: 'Can you do 10 for the dragon?',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isSentByMe: false,
        ),
      ],
    ),
    Conversation(
      id: '3',
      otherUserName: 'Sara',
      otherUserAvatar: '',
      lastMessage: 'Thanks for the purchase!',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      messages: [
        Message(
          senderId: 'them',
          receiverId: 'me',
          text: 'Thanks for the purchase!',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isSentByMe: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (mockConversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.white38),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white54,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: mockConversations.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: Color(0x20FFFFFF),
        indent: 72,
      ),
      itemBuilder: (context, index) {
        final convo = mockConversations[index];
        return ConversationTile(
          conversation: convo,
          onTap: () => context.push('/chat/${convo.id}'),
        );
      },
    );
  }
}
