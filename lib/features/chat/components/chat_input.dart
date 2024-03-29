import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/camera/views/camera_view.dart';
import 'package:splach/features/chat/components/chat_participant_mention_list.dart';
import 'package:splach/features/chat/components/chat_reply_message.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/highlight_text.dart';

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
    )..layout(maxWidth: MediaQuery.of(context).size.width - 143);

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

    return Container(
      decoration: BoxDecoration(
        color: widget.isImageInput ? Colors.black : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(hasOtherContent ? 16 : 0),
          topRight: Radius.circular(hasOtherContent ? 16 : 0),
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
                  height: 1,
                  color: ThemeColors.grey2,
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
          Container(
            // height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () => TextField(
                style: ThemeTypography.regular14.apply(
                  color: widget.isImageInput ? Colors.white : Colors.black,
                ),
                maxLines: null,
                focusNode: widget.focus,
                controller: messageController,
                decoration: InputDecoration(
                  hintText: widget.controller.private.isTrue
                      ? 'Say something privately...'
                      : 'What\'s in your mind?',
                  hintStyle: ThemeTypography.regular14.apply(
                    color:
                        widget.isImageInput ? Colors.white : ThemeColors.grey4,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() {
                          // if (controller.replyMessage.value == null &&
                          //     controller.recipients.isEmpty) {
                          //   return Container();
                          // }
                          return _buildInputButton(
                              icon: Icons.lock_outline,
                              color: controller.private.isTrue
                                  ? ThemeColors.tertiary
                                  : ThemeColors.grey3,
                              onPressed: () {
                                if (controller.recipients.isEmpty) return;

                                controller.private(
                                  !controller.private.value,
                                );
                              });
                        }),

                        Obx(() {
                          if (widget.controller.isTyping.isTrue ||
                              widget.isImageInput) {
                            return Container();
                          }
                          return _buildInputButton(
                            icon: Icons.image_outlined,
                            color: ThemeColors.secondary,
                            onPressed: () async {
                              controller.isCameraOpen.value = true;
                              final image = await Get.to(
                                    () => CameraGalleryView(
                                  controller: controller,
                                ),
                              );
                              if (image != null) {
                                controller.image.value = image;
                              }
                            },
                          );
                        }),
                        _buildInputButton(
                          icon: Icons.send_outlined,
                          color: ThemeColors.primary,
                          onPressed: () async {
                            final result = await controller.sendMessage(
                              content: messageController.text,
                            );

                            if (result == SaveResult.success) {
                              controller.replyMessage.value = null;
                              controller.image.value = null;
                              controller.recipients.clear();
                              controller.private.value = false;
                              messageController.clear();
                              controller.scrollToBottom();
                              if (widget.isImageInput) {
                                Get.back();
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      _numberOfLines > 1 ? 12 : 48,
                    ),
                    borderSide: const BorderSide(
                      width: 1,
                      color: ThemeColors.grey2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      _numberOfLines > 1 ? 12 : 48,
                    ),
                    borderSide: const BorderSide(
                      width: 1,
                      color: ThemeColors.grey3,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      _numberOfLines > 1 ? 12 : 48.0,
                    ),
                    borderSide: const BorderSide(
                      width: 1,
                      color: ThemeColors.grey2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInputButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 38,
        height: 38,
        margin: const EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
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
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final text = value.text;
    final spans = highlightMentions(text);

    return TextSpan(
      style: style,
      children: spans,
    );
  }
}
