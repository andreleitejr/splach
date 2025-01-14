import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/controllers/mention_highlight_controller.dart';
import 'package:splach/features/camera/views/camera_view.dart';
import 'package:splach/features/chat/components/chat_image_input.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_icons.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/connection_status.dart';
import 'package:splach/widgets/custom_icon.dart';

class ChatTextField extends StatelessWidget {
  final ChatController controller;
  final FocusNode focus;
  final bool isImageInput;
  final MentionHighlightingController messageController;
  final int numberOfLines;

  const ChatTextField({
    super.key,
    required this.controller,
    required this.focus,
    required this.isImageInput,
    required this.messageController,
    required this.numberOfLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: ThemeTypography.regular14.apply(
        color: isImageInput ? Colors.white : Colors.black,
      ),
      maxLines: null,
      focusNode: focus,
      controller: messageController,
      decoration: InputDecoration(
        hintText: controller.private.isTrue
            ? 'Say something privately...'
            : 'What\'s in your mind?',
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Gilroy',
          color: isImageInput ? Colors.white : ThemeColors.grey4,
        ),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        suffixIcon: _buildSuffixIcon(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            numberOfLines > 1 ? 12 : 48,
          ),
          borderSide: const BorderSide(
            width: 0.5,
            color: ThemeColors.grey2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            numberOfLines > 1 ? 12 : 48,
          ),
          borderSide: const BorderSide(
            width: 1,
            color: ThemeColors.grey3,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            numberOfLines > 1 ? 12 : 48.0,
          ),
          borderSide: const BorderSide(
            width: 1,
            color: ThemeColors.grey2,
          ),
        ),
      ),
    );
  }

  Widget _buildSuffixIcon() {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ConnectionStatus(
        connected: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              return _buildInputButton(
                icon: ThemeIcons.lock,
                color: controller.private.isTrue
                    ? ThemeColors.tertiary
                    : ThemeColors.grey3,
                onPressed: () {
                  if (controller.recipients.isEmpty) return;

                  controller.private(
                    !controller.private.value,
                  );
                },
              );
            }),
            Obx(() {
              if (controller.isTyping.isTrue || isImageInput) {
                return Container();
              }
              return _buildInputButton(
                icon: ThemeIcons.image,
                color: ThemeColors.secondary,
                onPressed: () async {
                  controller.isCameraOpen.value = true;
                  final image = await Get.to(
                    () => CameraGalleryView(
                      image: controller.image.value,
                    ),
                  );
                  if (image != null) {
                    controller.image.value = image;
                    Get.to(
                      () => ChatImageInput(
                        controller: controller,
                      ),
                    );
                  }
                },
              );
            }),
            _buildInputButton(
              icon: ThemeIcons.send,
              color: ThemeColors.primary,
              onPressed: () => _sendMessage(),
            ),
          ],
        ),
        disconnected: _buildInputButton(
          icon: ThemeIcons.send,
          color: ThemeColors.grey2,
          onPressed: () {
            Get.snackbar(
              'You are offline',
              'Connect to internet and try again',
            );
          },
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    controller.sendTemporaryMessage(
      content: messageController.text,
    );

    final content = messageController.text;
    messageController.clear();

    if (isImageInput) {
      Get.back();
    }

    final result = await controller.sendMessage(
      content: content,
    );

    if (result == SaveResult.success) {
      controller.replyMessage.value = null;
      controller.image.value = null;
      controller.recipients.clear();
      controller.private.value = false;
      controller.scrollToBottom();
    }
  }

  Widget _buildInputButton({
    required String icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 38,
        height: 38,
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: CustomIcon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
