import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/controllers/group_chat_edit_controller.dart';
import 'package:splach/widgets/input.dart';

class GroupChatEditView extends StatelessWidget {
  final groupChatController = Get.put(GroupChatEditController());

  GroupChatEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Chat em Grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Input(
              controller: groupChatController.titleController,
              labelText: 'Título',
            ),
            Input(
                controller: groupChatController.descriptionController,
                labelText: 'Descrição'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                groupChatController.save();
              },
              child: const Text('Criar Chat em Grupo'),
            ),
          ],
        ),
      ),
    );
  }
}
