import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class ChatImageInput extends StatelessWidget {
  final ChatController controller;

  ChatImageInput({super.key, required this.controller});

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(
              () {
                return Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(
                          base64Decode(
                            controller.image.value!,
                          ),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                // focusNode: widget.focus,
                style: ThemeTypography.regular14.apply(
                  color: ThemeColors.light,
                ),
                controller: messageController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  hintText: 'What\'s in your mind?',
                  hintStyle: ThemeTypography.regular14.apply(
                    color: ThemeColors.light,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                              controller.image.value = null;
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
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
