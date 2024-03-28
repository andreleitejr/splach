import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/components/chat_image_input.dart';
import 'package:splach/features/chat/components/chat_input.dart';
import 'package:splach/features/chat/components/chat_message_list.dart';
import 'package:splach/features/chat/components/chat_participants_list.dart';
import 'package:splach/features/chat/components/chat_top_navigation_bar.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';
import 'package:splach/features/chat/models/group_chat.dart';

class ChatView extends StatefulWidget {
  final GroupChat chat;

  const ChatView({super.key, required this.chat});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  late ChatController controller;

  @override
  void initState() {
    controller = Get.put(ChatController(widget.chat));
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      controller.onClose();
    } else if (state == AppLifecycleState.resumed) {
      controller.addParticipantToChat();
    }
  }

  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
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
              ChatParticipantsList(
                controller: controller,
              ),
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
  }
}
