import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/address/components/address_inputs.dart';
import 'package:splach/features/home/views/base_view.dart';
import 'package:splach/features/user/controllers/user_edit_controller.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/widgets/avatar_image_input.dart';
import 'package:splach/widgets/flat_button.dart';
import 'package:splach/widgets/image_picker_bottom_sheet.dart';
import 'package:splach/widgets/input.dart';
import 'package:splach/widgets/top_navigation_bar.dart';

class UserEditView extends StatelessWidget {
  final controller = Get.put(UserEditController());

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode genderFocus = FocusNode();
  final FocusNode birthdayFocus = FocusNode();

  UserEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigationBar(
        title: 'Editar Perfil',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => AvatarImageInput(
                  image: controller.imageController.value,
                  onPressed: () async {
                    final source = await showImagePickerBottomSheet(context);

                    if (source != null) {
                      await controller.pickImage(source);
                      // await Future.delayed(const Duration(milliseconds: 300));
                      // focus.requestFocus(firstNameFocus);
                    }
                  },
                ),
              ),
              Input(
                controller: controller.firstNameController,
                labelText: 'Nome',
                keyboardType: TextInputType.name,
              ),
              Input(
                controller: controller.nicknameController,
                labelText: 'Apelido',
              ),
              Input(
                controller: controller.genderController,
                labelText: 'Gênero',
              ),
              Input(
                controller: controller.birthdayController,
                labelText: 'Data de Nascimento',
              ),
              Input(
                controller: controller.cityController,
                labelText: 'Cidade',
              ),
              Input(
                controller: controller.stateController,
                labelText: 'Estado',
              ),
              Input(
                controller: controller.countryController,
                labelText: 'País',
              ),
              const SizedBox(height: 16),
              FlatButton(
                onPressed: () async {
                  final result = await controller.save();
                  if (result == SaveResult.success) {
                    Get.off(() => const BaseView());
                  }
                },
                actionText: 'Criar conta',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
