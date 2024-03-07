import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/components/chat_input.dart';
import 'package:splach/features/group_chat/components/chat_message_box.dart';
import 'package:splach/features/group_chat/components/chat_system_message.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/models/message.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/avatar_image.dart';
import 'package:splach/widgets/top_navigation_bar.dart';

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
      appBar: TopNavigationBar(
        title: 'Chat em Grupo',
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: groupChatController.messages.length,
                itemBuilder: (context, index) {
                  final message = groupChatController.messages[index];
                  return Column(
                    children: [
                      message.isFromSystem
                          ? ChatSystemMessage(message: message)
                          : ChatMessageBox(message: message),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ),
          ChatInput(controller: groupChatController),
        ],
      ),
    );
  }
}
