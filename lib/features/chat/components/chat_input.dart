import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/controllers/mention_highlight_controller.dart';
import 'package:splach/features/chat/components/chat_participant_mention_list.dart';
import 'package:splach/features/chat/components/chat_reply_message.dart';
import 'package:splach/features/chat/components/chat_text_field.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/themes/theme_colors.dart';

class ChatInput extends StatefulWidget {
  final ChatController controller;
  final FocusNode focus;
  final bool isImageInput;

  const ChatInput({
    super.key,
    required this.controller,
    required this.focus,
    this.isImageInput = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final messageController = MentionHighlightingController();

  int _numberOfLines = 1;

  @override
  void initState() {
    super.initState();
    messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    messageController.removeListener(_onTextChanged);
    messageController.clear();
    messageController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    widget.controller.isTyping.value = messageController.text.isNotEmpty;
    widget.controller.updateMentionListVisibility(
      messageController.text,
    );
    widget.controller.updateIfIsMentioning(messageController.text);
    _calculateNumberOfLines();
  }

  void _addUserToChatInput(Participant participant) {
    final String currentText = messageController.text;
    final String newUserText = participant.nickname;
    final String newText = currentText + newUserText;
    messageController.text = newText;
    messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );
  }

  void _calculateNumberOfLines() {
    final textPainter = TextPainter(
      text: TextSpan(text: messageController.text),
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: MediaQuery.of(context).size.width - 143,
      );

    final numberOfLines = textPainter.computeLineMetrics().length;
    setState(() {
      _numberOfLines = numberOfLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    final hasOtherContent = controller.replyMessage.value != null ||
        controller.isShowingMentionList.isTrue;

    final borderRadius = (hasOtherContent ? 16 : 0).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: widget.isImageInput ? Colors.black : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
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
      child: Column(
        children: [
          const SizedBox(height: 16),
          Obx(
            () {
              if (controller.replyMessage.value == null) {
                return Container();
              }

              return ChatReplyMessage(
                replyMessage: controller.replyMessage.value!,
                onClose: () {
                  controller.replyMessage.value = null;
                  controller.private.value = false;
                  controller.recipients.clear();
                },
                isPrivate: controller.private.value,
              );
            },
          ),
          Obx(() {
            if (controller.isShowingMentionList.isFalse) {
              return Container();
            }
            return ChatParticipantMentionList(
              controller: controller,
              onUserSelected: _addUserToChatInput,
              isImageInput: widget.isImageInput,
            );
          }),
          Obx(() {
            if (controller.isShowingMentionList.isTrue ||
                controller.replyMessage.value == null) {
              return Container();
            }

            return Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 0.75,
                  color: ThemeColors.grey2,
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
          Container(
            // height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ChatTextField(
              controller: widget.controller,
              focus: widget.focus,
              messageController: messageController,
              isImageInput: widget.isImageInput,
              numberOfLines: _numberOfLines,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
