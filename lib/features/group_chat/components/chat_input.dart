import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
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
  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
  );
  final int _sizePerPage = 50;

  AssetPathEntity? _path;
  List<AssetEntity>? _entities;
  final _images = <File>[];
  File? _lastImage;
  int _totalEntitiesCount = 0;

  int _page = 0;

  Future<void> _requestAssets() async {
    final PermissionStatus status = await Permission.photos.request();
    // Request permissions.
    // final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!mounted) {
      return;
    }

    if (status.isDenied) {
      print('Permission is not accessible. $status');
      return;
    }
    // Obtain assets using the path entity.
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      filterOption: _filterOptionGroup,
    );
    if (!mounted) {
      return;
    }
    // Return if not paths found.
    if (paths.isEmpty) {
      print('No paths found.');
      return;
    }
    setState(() {
      _path = paths.first;
    });
    _totalEntitiesCount = await _path!.assetCountAsync;
    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: 0,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }
    for (final entity in entities) {
      final file = await entity.file;
      _images.add(file!);
    }
    setState(() {});
    print('asdhuhsdausah my assets ${_images.length}');
  }

  @override
  void initState() {
    _requestAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () {
                if (widget.controller.cameraController.value == null) {
                  return Container();
                }
               return Container(
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: CameraPreview(
                    widget.controller.cameraController.value!,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            if (_images.isNotEmpty)
              SizedBox(
                height: 80,
                width: double.infinity,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: _images.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 80,
                      width: 80,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        _pickImage(context);
                      },
                      child: const Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      _captureImage(context);
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
                      onPressed: () {
                        widget.controller.toggleCamera();
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _captureImage(BuildContext context) async {
    await widget.controller.pickImage();
    _sendMessage();
  }

  Future<void> _pickImage(BuildContext context) async {
    await widget.controller.pickImageFromGallery();
    _sendMessage();
  }

  Future<void> _sendMessage() async {
    if (widget.controller.image.value != null) {
      await widget.controller.sendMessage();
      Get.back();
    }
  }
}
