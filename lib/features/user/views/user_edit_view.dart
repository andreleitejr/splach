import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/address/models/brazilian_states.dart';
import 'package:splach/features/home/views/base_view.dart';
import 'package:splach/features/user/controllers/user_edit_controller.dart';
import 'package:splach/features/user/models/gender.dart';
import 'package:splach/repositories/firestore_repository.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Obx(
                () => AvatarImageInput(
                  image: controller.image.value,
                  onPressed: () async {
                    focus.unfocus();
                    await _getImage(context);
                    focus.requestFocus(nameFocus);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Input(
                controller: controller.name,
                hintText: 'Name',
                keyboardType: TextInputType.name,
                currentFocus: nameFocus,
                nextFocus: nickNameFocus,
              ),
              const SizedBox(height: 16),
              Input(
                controller: controller.nickname,
                hintText: 'Nickname',
                currentFocus: nickNameFocus,
                nextFocus: emailFocus,
              ),
              const SizedBox(height: 16),
              Input(
                controller: controller.email,
                hintText: 'E-mail',
                keyboardType: TextInputType.emailAddress,
                currentFocus: emailFocus,
                onSubmit: () async {
                  emailFocus.unfocus();
                  await Future.delayed(
                    const Duration(milliseconds: 300),
                  ).then(
                    (_) => _showGenderBottomSheet(context),
                  );
                },
              ),
              const SizedBox(height: 16),
              InputButton(
                onTap: () => _showGenderBottomSheet(context),
                controller: controller.gender,
                hintText: 'Gender',
              ),
              const SizedBox(height: 16),
              DateInput(
                date: controller.birthday.value,
                hintText: 'Birthday',
                onDateSelected: (date) async {
                  controller.birthday.value = date;

                  await Future.delayed(
                    const Duration(milliseconds: 500),
                  ).then(
                    (_) => _showStateBottomSheet(context),
                  );
                },
              ),
              const SizedBox(height: 16),
              InputButton(
                onTap: () => _showStateBottomSheet(context),
                controller: controller.state,
                hintText: 'State',
              ),
              const SizedBox(height: 16),
              FlatButton(
                onPressed: () => _createAccount(),
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
    );
  }

  Future<void> _getImage(BuildContext context) async {
    final source = await showImageSourceBottomSheet(context);

    if (source != null) {
      await controller.pickImage(source);
    }
  }

  void _showGenderBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);

    Get.bottomSheet(
      CustomBottomSheet<Gender>(
        items: genders,
        title: 'Tell us your gender',
        onItemSelected: (selectedItem) async {
          controller.gender.text = selectedItem.title;
          focus.unfocus();

          await Future.delayed(
            const Duration(milliseconds: 100),
          ).then((_) async {
            final birthday = await selectDateTime(
              context,
              showTime: false,
            );
            if (birthday != null) {
              controller.birthday.value = birthday;
            }
          });
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
        title: "What state do you live?",
        onItemSelected: (selectedItem) {
          controller.state.text = selectedItem.title;
          focus.unfocus();
        },
      ),
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  Future<void> _createAccount() async {
    controller.validateForm();
    if (controller.isFormValid.isTrue) {
      final result = await controller.save();
      if (result == SaveResult.success) {
        Get.off(() => const BaseView());
      }
    }
  }
}
