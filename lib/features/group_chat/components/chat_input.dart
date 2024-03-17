import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/camera/views/camera_view.dart';
import 'package:splach/features/group_chat/components/chat_highlight_mention.dart';
import 'package:splach/features/group_chat/components/chat_image.dart';
import 'package:splach/features/group_chat/components/chat_image_input.dart';
import 'package:splach/features/group_chat/components/chat_participant_mention_list.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class ChatInput extends StatefulWidget {
  final GroupChatController controller;
  final FocusNode focus;

  const ChatInput({
    super.key,
    required this.controller,
    required this.focus,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final messageController = MentionHighlightingController();

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = messageController.text.isNotEmpty;
      widget.controller.updateMentionListVisibility(messageController.text);
    });
  }

  void _addUserToChatInput(User user) {
    final String currentText = messageController.text;
    final String newUserText = user.nickname;
    final String newText = currentText + newUserText;
    messageController.text = newText;
    messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Obx(() {
            if (controller.replyMessage.value == null) {
              return Container();
            }

            final replyMessage = controller.replyMessage.value!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (replyMessage.sender != null) ...[
                      // AvatarImage(
                      //   image: replyMessage.sender!.image,
                      //   width: 32,
                      //   height: 32,
                      // ),
                      // const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: ThemeTypography.regular14.apply(
                              color: Colors.black,
                            ),
                            children: highlightMentions(
                              'Asnwering @${replyMessage.sender!.nickname}',
                            ),
                          ),
                        ),
                      ),
                    ],
                    IconButton(
                      onPressed: () {
                        controller.replyMessage.value = null;
                      },
                      constraints: const BoxConstraints(
                        maxHeight: 30,
                      ),
                      icon: const Icon(
                        size: 20,
                        Icons.close,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (replyMessage.image != null &&
                    replyMessage.image!.isNotEmpty) ...[
                  ChatImage(
                    image: replyMessage.image!,
                    maxHeight: 200,
                    maxWidth: double.infinity,
                  ),
                ],
                if (replyMessage.content != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ThemeColors.grey1,
                      border: Border.all(
                        color: ThemeColors.grey2,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 75,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.65 -
                                        32,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: ThemeTypography.regular14.apply(
                                    color: Colors.black,
                                  ),
                                  children: highlightMentions(
                                    replyMessage.content!,
                                  ),
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            );
          }),
          if (controller.isShowingMentionList.isTrue) ...[
            ChatParticipantMentionList(
              controller: controller,
              onUserSelected: _addUserToChatInput,
            ),
          ],
          TextField(
            focusNode: widget.focus,
            controller: messageController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
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
                        Icons.image_outlined,
                        color: ThemeColors.grey4,
                      ),
                      onPressed: () async {
                        controller.isCameraOpen.value = true;
                        final image = await Get.to(
                          () => const CameraGalleryView(),
                        );
                        if (image != null) {
                          controller.image.value = image;
                        }
                      },
                    ),
                  Container(
                    // height: 48,
                    margin: const EdgeInsets.only(right: 6),
                    width: 36,
                    decoration: const BoxDecoration(
                      color: ThemeColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final result = await controller.sendMessage(
                          content: messageController.text,
                        );

                        if (result == SaveResult.success) {
                          controller.replyMessage.value = null;
                          messageController.clear();
                          controller.scrollToBottom();
                        }
                      },
                    ),
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}


class MentionHighlightingController extends TextEditingController {
  MentionHighlightingController({String? text}) : super(text: text);

  @override
  set text(String newText) {
    value = TextEditingValue(
      text: newText,
      selection: selection,
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final text = value.text;
    final spans = highlightMentions(text);

    return TextSpan(style: style, children: spans);
  }
}
