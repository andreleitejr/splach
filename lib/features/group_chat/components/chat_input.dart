import 'package:flutter/material.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class ChatInput extends StatefulWidget {
  final GroupChatController controller;

  ChatInput({super.key, required this.controller});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final messageController = TextEditingController();

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = messageController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: ThemeColors.grey1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.tertiary.withOpacity(0.25),
            spreadRadius: -8,
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: messageController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          hintText: 'What\'s in your mind?',
          hintStyle: ThemeTypography.regular14.apply(
            color: ThemeColors.grey4,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isTyping)
                IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: ThemeColors.grey4,
                  ),
                  onPressed: () {
                    // Handle clear action
                  },
                ),
              if (!_isTyping)
                IconButton(
                  icon: const Icon(
                    Icons.attach_file,
                    color: ThemeColors.grey4,
                  ),
                  onPressed: () {
                    // Handle attach file action
                  },
                ),
              IconButton(
                icon: const Icon(
                  Icons.send,
                  color: ThemeColors.grey4,
                ),
                onPressed: () =>
                    widget.controller.sendMessage(messageController.text),
              ),
            ],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(96),
            borderSide: const BorderSide(
              width: 1,
              color: ThemeColors.grey2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(96),
            borderSide: const BorderSide(
              width: 1,
              color: ThemeColors.grey3,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(96),
            borderSide: const BorderSide(
              width: 1,
              color: ThemeColors.grey2,
            ),
          ),
        ),
      ),
    );
  }
}
