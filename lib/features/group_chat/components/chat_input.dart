import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/components/chat_highlight_mention.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/avatar_image.dart';

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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (replyMessage.sender != null) ...[
                      AvatarImage(
                        image: replyMessage.sender!.image,
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (replyMessage.sender != null) ...[
                      Expanded(
                        child: Text(
                          '@${replyMessage.sender!.nickname}',
                          style: ThemeTypography.semiBold12.apply(
                            color: ThemeColors.primary,
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
                                  MediaQuery.of(context).size.width * 0.65 - 32,
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: ThemeTypography.regular14.apply(
                                  color: Colors.black,
                                ),
                                children: highlightMentions(
                                  replyMessage.content,
                                ),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // const SizedBox(height: 8),
                          // Text(
                          //   '${replyMessage.createdAt.toTimeString()} ago',
                          //   style: ThemeTypography.regular9.apply(
                          //     color: ThemeColors.grey4,
                          //   ),
                          //   textAlign: TextAlign.right,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
          TextField(
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
                      onPressed: () {
                        // Handle attach file action
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
                          messageController.text,
                        );

                        if (result == SaveResult.success) {

                          controller.replyMessage.value = null;
                          messageController.clear();
                          controller.scrollToBottom();
                        }
                      },
                    ),
                  )
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
