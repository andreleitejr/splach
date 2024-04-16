import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/components/chat_input.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';

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
                if (controller.image.value == null) {
                  return Container();
                }
                return Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(controller.image.value!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            // const SizedBox(height: 16),
            ChatInput(
              controller: controller,
              focus: FocusNode(),
              isImageInput: true,
            ),
            // const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
