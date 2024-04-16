import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/auth/controllers/login_controller.dart';
import 'package:splach/features/legal/terms_and_conditions.dart';
import 'package:splach/features/user/views/user_edit_view.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/flat_button.dart';
import 'package:splach/widgets/phone_input.dart';

import 'code_verification_view.dart';

abstract class LoginNavigator {
  void verification();

  void home();

  void register();
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> implements LoginNavigator {
  late LoginController controller;
  final _loginFocus = FocusNode();

  @override
  void initState() {
    controller = Get.put(LoginController(this));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loginFocus.requestFocus();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Center(),
              ),
              Text(
                'Welcome to Splach,',
                style: ThemeTypography.semiBold16.apply(
                  color: ThemeColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Enter with your phone number',
                style: ThemeTypography.regular14,
              ),
              const SizedBox(height: 16),
              PhoneInput(
                focus: _loginFocus,
                controller: controller.phoneController,
                onSubmit: () async {
                  await controller.sendVerificationCode();
                  _loginFocus.unfocus();
                },
              ),
              const SizedBox(height: 16),
              Obx(
                () => FlatButton(
                  actionText: 'Enter',
                  onPressed: () async {
                    if (controller.isLoginValid.isTrue) {
                      await controller.sendVerificationCode();
                    } else {
                      Get.snackbar(
                        'Authentication error',
                        controller.inputError,
                      );
                    }
                  },
                  isValid: controller.isLoginValid.value,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      activeColor: ThemeColors.primary,
                      value: controller.termsAndConditions.value,
                      onChanged: controller.termsAndConditions,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text:
                            'Ao clicar em enviar, você concorda com os nossos ',
                        style: ThemeTypography.regular12.apply(
                          color: ThemeColors.grey5,
                        ),
                        children: [
                          TextSpan(
                            text: 'Termos e Condições',
                            style: ThemeTypography.semiBold12.apply(
                              color: ThemeColors.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(
                                    () => const TermsAndConditions(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void verification() {
    Get.to(() => CodeVerificationView(controller: controller));
  }

  @override
  void register() {
    Get.off(
      () => const UserEditView(),
    );
  }

  @override
  void home() {
    Get.offAllNamed('/home');
  }
}
