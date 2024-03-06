import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/address/components/address_inputs.dart';
import 'package:splach/features/address/models/brazilian_states.dart';
import 'package:splach/features/home/views/base_view.dart';
import 'package:splach/features/user/controllers/user_edit_controller.dart';
import 'package:splach/features/user/models/gender.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/widgets/avatar_image_input.dart';
import 'package:splach/widgets/custom_bottom_sheet.dart';
import 'package:splach/widgets/date_input.dart';
import 'package:splach/widgets/flat_button.dart';
import 'package:splach/widgets/image_picker_bottom_sheet.dart';
import 'package:splach/widgets/input.dart';
import 'package:splach/widgets/input_button.dart';
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
      // appBar: const TopNavigationBar(
      //   title: 'Editar Perfil',
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                Input(
                  controller: controller.firstNameController,
                  hintText: 'Nome',
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                Input(
                  controller: controller.nicknameController,
                  hintText: 'Nickname',
                ),
                const SizedBox(height: 16),
                InputButton(
                  onTap: () => _showGenderBottomSheet(context),
                  controller: controller.genderController,
                  hintText: 'Gênero',
                ),
                const SizedBox(height: 16),
                DateInput(
                  date: controller.birthday.value,
                  hintText: 'Data de Nascimento',
                  onDateSelected: controller.birthday,
                ),
                // const SizedBox(height: 16),
                // Input(
                //   controller: controller.cityController,
                //   hintText: 'Cidade',
                // ),
                // const SizedBox(height: 16),
                // Input(
                //   controller: controller.countryController,
                //   hintText: 'País',
                //   enabled: false,
                // ),
                const SizedBox(height: 16),
                InputButton(
                  onTap: () => _showStateBottomSheet(context),
                  controller: controller.stateController,
                  hintText: 'Estado',
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
      ),
    );
  }

  void _showGenderBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);

    Get.bottomSheet(
      CustomBottomSheet<Gender>(
        items: genders,
        title: 'Qual seu gênero?',
        onItemSelected: (selectedItem) async {
          controller.genderController.text = selectedItem.title;
          focus.unfocus();

          // await Future.delayed(const Duration(milliseconds: 100));
          //
          // if (controller.currentUser.value == null) {
          //   final birthday = await selectDateTime(
          //     context,
          //     DateInputType.birthday,
          //     showTime: false,
          //   );
          //   if (birthday != null) {
          //     controller.birthday.value = birthday;
          //   }
          // }
        },
      ),
      enableDrag: true,
    );
  }

  void _showStateBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);
    Get.bottomSheet(
      CustomBottomSheet<BrazilianState>(
        items: statesList,
        title: "Selecione o estado de registro",
        onItemSelected: (selectedItem) {
          controller.stateController.text = selectedItem.title;
          focus.unfocus();
        },
      ),
      enableDrag: true,
      isScrollControlled: true,
    );
  }
}
