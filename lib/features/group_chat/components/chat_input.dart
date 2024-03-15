import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/components/chat_highlight_mention.dart';
import 'package:splach/features/group_chat/components/chat_image.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
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
                      onPressed: () => Get.to(
                        () => CameraView(
                          controller: controller,
                        ),
                      ),
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

class CameraView extends StatefulWidget {
  final GroupChatController controller;

  const CameraView({
    super.key,
    required this.controller,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(
              () {
                if (controller.cameraController.value == null) {
                  return Container();
                }
                print(
                    ' ###################### CONTORLLER IMAGE ${controller.image.value == null}');
                if (controller.image.value != null) {
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
                }
                return Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: CameraPreview(
                      controller.cameraController.value!,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            if (controller.galleryImages.isNotEmpty &&
                controller.image.value == null)
              SizedBox(
                height: 80,
                width: double.infinity,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: controller.galleryImages.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final galleryImage = controller.galleryImages[index];
                    return GestureDetector(
                      onTap: () => controller.image(galleryImage),
                      child: Container(
                        height: 80,
                        width: 80,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: MemoryImage(
                              base64Decode(
                                controller.galleryImages[index],
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            if (controller.image.value == null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          controller.pickImageFromGallery();
                        },
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image: MemoryImage(
                                base64Decode(
                                  controller.galleryImages.first,
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        widget.controller.pickImage();
                      },
                      child: Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 6,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          await controller.toggleCameraLens();
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.change_circle_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  // focusNode: widget.focus,
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
                                Get.back();
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
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

// Future<void> _sendMessage() async {
//   if (controller.image.value != null) {
//     await controller.sendMessage();
//     Get.back();
//   }
// }
}
