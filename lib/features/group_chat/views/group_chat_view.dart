import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/utils/extensions.dart';

class ChatView extends StatefulWidget {
  final GroupChat chat;

  const ChatView({super.key, required this.chat});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late GroupChatController groupChatController;

  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    groupChatController = Get.put(GroupChatController(widget.chat));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat em Grupo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: groupChatController.messages.length,
                itemBuilder: (context, index) {
                  final message = groupChatController.messages[index];
                  return message.isFromSystem
                      ? Center(
                          child: Text(message.content),
                        )
                      : ListTile(
                          onTap: () {
                            if (message.sender != null) {
                              Get.to(
                                () => UserProfileView(
                                  user: message.sender!,
                                ),
                              );
                            }
                          },
                          title: Text(message.content),
                          subtitle: Text(
                            'Sent by: ${message.senderId} - ${message.createdAt.toTimeString()}',
                          ),
                        );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        InputDecoration(hintText: 'Digite sua mensagem...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    groupChatController.sendMessage(messageController.text);
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
