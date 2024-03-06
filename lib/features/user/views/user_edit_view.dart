import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/address/models/brazilian_states.dart';
import 'package:splach/features/home/views/base_view.dart';
import 'package:splach/features/user/controllers/user_edit_controller.dart';
import 'package:splach/features/user/models/gender.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/avatar_image_input.dart';
import 'package:splach/widgets/custom_bottom_sheet.dart';
import 'package:splach/widgets/date_input.dart';
import 'package:splach/widgets/flat_button.dart';
import 'package:splach/widgets/image_picker_bottom_sheet.dart';
import 'package:splach/widgets/input.dart';
import 'package:splach/widgets/input_button.dart';

class UserEditView extends StatelessWidget {
  final controller = Get.put(UserEditController());

  final nameFocus = FocusNode();
  final nickNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final genderFocus = FocusNode();
  final birthdayFocus = FocusNode();
  final stateFocus = FocusNode();

  UserEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
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
                        await Future.delayed(const Duration(milliseconds: 300));
                        print(
                            'HASDUHADSUAHSDAUDSHSUHADSUAHSDAUAHAUDS QUE ISSO!!!');
                        focus.requestFocus(nameFocus);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Input(
                  controller: controller.nameController,
                  hintText: 'Nome',
                  keyboardType: TextInputType.name,
                  currentFocus: nameFocus,
                  nextFocus: nickNameFocus,
                ),
                const SizedBox(height: 16),
                Input(
                  controller: controller.nicknameController,
                  hintText: 'Nickname',
                  currentFocus: nickNameFocus,
                  nextFocus: emailFocus,
                ),
                const SizedBox(height: 16),
                Input(
                  controller: controller.emailController,
                  hintText: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  currentFocus: emailFocus,
                  onSubmit: () async {
                    emailFocus.unfocus();
                    await Future.delayed(const Duration(milliseconds: 300))
                        .then((_) => _showGenderBottomSheet(context));
                  },
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
                  onDateSelected: (date) async {
                    controller.birthday.value = date;
                    await Future.delayed(const Duration(milliseconds: 300))
                        .then((_) => _showStateBottomSheet(context));
                  },
                ),
                const SizedBox(height: 16),
                InputButton(
                  onTap: () => _showStateBottomSheet(context),
                  controller: controller.stateController,
                  hintText: 'Estado',
                ),
                const SizedBox(height: 16),
                FlatButton(
                  onPressed: () async {
                    controller.validateForm();
                    if (controller.isFormValid.isTrue) {
                      final result = await controller.save();
                      if (result == SaveResult.success) {
                        Get.off(() => const BaseView());
                      }
                    }
                  },
                  actionText: 'Create account',
                  isValid: controller.isFormValid.value,
                ),
                Obx(
                  () {
                    if (controller.isFormValid.isTrue) {
                      return Container();
                    }

                    return Text(
                      controller.errorMessage.value,
                      style: ThemeTypography.regular14.apply(
                        color: Colors.redAccent,
                      ),
                    );
                  },
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

          await Future.delayed(const Duration(milliseconds: 100));

          final birthday = await selectDateTime(
            context,
            showTime: false,
          );
          if (birthday != null) {
            controller.birthday.value = birthday;
          }
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
