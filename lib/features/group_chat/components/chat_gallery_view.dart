import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/models/message.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/image_viewer.dart';
import 'package:splach/widgets/top_navigation_bar.dart';

class ChatGalleryView extends StatelessWidget {
  final GroupChat chat;

  const ChatGalleryView({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigationBar(
        title: 'Gallery',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildChatHeader(),
            const SizedBox(height: 16.0),
            _buildMessageGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  chat.images.first,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.title,
                    style: ThemeTypography.semiBold16,
                  ),
                  const SizedBox(height: 8),
                  _buildDescriptionText(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionText() {
    final description = chat.description;
    final showAllText = description.length >
        50; // Exibir "Ver tudo" se a descrição for maior que 50 caracteres

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: description.length <= 50
                ? description
                : description.substring(0, 50) + (showAllText ? "..." : ""),
            style: ThemeTypography.regular14.apply(
              color: ThemeColors.grey4,
            ),
          ),
          if (showAllText) ...[
            TextSpan(
              text: ' Ver tudo',
              style: ThemeTypography.regular14.apply(
                color: ThemeColors.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Implemente a lógica para mostrar a descrição completa
                },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageGrid() {
    final chatImages = chat.messages.map((message) => message.image!).toList();
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: chat.messages.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final message = chat.messages[index];
                return ImageViewer(
                  images: chatImages,
                  initialIndex: index,
                  title: chat.title,
                  description: chat.description,
                );
              },
            );
          },
          child: _buildMessageItem(
            chat.messages[index],
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(Message message) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        image: DecorationImage(
          image: MemoryImage(base64Decode(message.image!)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
