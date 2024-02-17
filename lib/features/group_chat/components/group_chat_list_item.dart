import 'package:flutter/material.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';

class GroupChatListItem extends StatelessWidget {
  final GroupChat chat;
  final VoidCallback onPressed;

  const GroupChatListItem({
    super.key,
    required this.chat,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    chat.images.first,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(chat.title),
            const SizedBox(height: 4),
            Text(chat.description),
            const SizedBox(height: 4),
            // Text(chat.distance!.toString()),
            // const SizedBox(height: 4),
            Text(
              'Total participants: ${chat.participants.length.toString()}',
            ),
            // const SizedBox(height: 4),
            // Text(
            //     'Coordinates: ${chat.location.latitude}, ${chat.location.longitude}'),
          ],
        ),
      ),
    );
  }
}
