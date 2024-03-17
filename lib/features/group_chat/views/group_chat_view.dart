import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/components/chat_image_input.dart';
import 'package:splach/features/group_chat/components/chat_input.dart';
import 'package:splach/features/group_chat/components/chat_sender_message.dart';
import 'package:splach/features/group_chat/components/chat_message_list.dart';
import 'package:splach/features/group_chat/components/chat_participants_list.dart';
import 'package:splach/features/group_chat/components/chat_system_message.dart';
import 'package:splach/features/group_chat/components/chat_top_navigation_bar.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/user/models/user.dart';
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
  late GroupChatController controller;

  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    controller = Get.put(GroupChatController(widget.chat));
    super.initState();
  }

  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        if (controller.isCameraOpen.isTrue && controller.image.value != null) {
          return ChatImageInput(controller: controller);
        }
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF8F2FF),
                  Color(0xFFF3F8FF),
                  Color(0xFFFFF2FF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  ChatTopNavigationBar(
                    controller: controller,
                  ),
                  ChatParticipantsList(controller: controller),
                  ChatMessageList(
                    controller: controller,
                    focus: focus,
                  ),
                  ChatInput(
                    controller: controller,
                    focus: focus,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
