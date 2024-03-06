import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/controllers/group_chat_edit_controller.dart';
import 'package:splach/models/chat_category.dart';
import 'package:splach/widgets/custom_bottom_sheet.dart';
import 'package:splach/widgets/input.dart';
import 'package:splach/widgets/input_button.dart';

class GroupChatEditView extends StatelessWidget {
  final controller = Get.put(GroupChatEditController());

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
              controller: controller.titleController,
              hintText: 'Título',
            ),
            Input(
              controller: controller.descriptionController,
              hintText: 'Descrição',
            ),
            Input(
              controller: controller.descriptionController,
              hintText: 'Descrição',
            ),
            // Obx(
            //   () => InputButton(
            //     onPressed: () => showCategoryBottomSheet(context),
            //     value: controller.category.value,
            //     hint: 'Categoria',
            //   ),
            // ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.save();
              },
              child: const Text('Criar Chat em Grupo'),
            ),
          ],
        ),
      ),
    );
  }

  void showCategoryBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);

    categories.removeWhere((category) => category.category == ChatCategory.all);

    Get.bottomSheet(
      CustomBottomSheet<ChatCategory>(
        items: categories,
        title: 'Qual a categoria?',
        onItemSelected: (selectedItem) async {
          controller.category.value = selectedItem.title;
          focus.unfocus();
        },
      ),
      enableDrag: true,
    );
  }
}
