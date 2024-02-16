import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/auth/controllers/auth_controller.dart';
import 'package:splach/features/legal/terms_and_conditions.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/code_widget.dart';
import 'package:splach/widgets/flat_button.dart';
import 'package:splach/widgets/phone_input.dart';

class LoginView extends StatelessWidget {
  final AuthController controller;

  LoginView({super.key, required this.controller});

  final _loginFocus = FocusNode();

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
              // Expanded(
              //   child: Center(
              //     child: const Logo(),
              //   ),
              // ),
              Text(
                'Bem-vindo,',
                style: ThemeTypography.semiBold16.apply(
                  color: ThemeColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Entre com seu número de celular',
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
                // onChanged: controller.phoneController,
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
                          color: ThemeColors.grey4,
                        ),
                        children: [
                          TextSpan(
                            text: 'Termos e Condições',
                            style: ThemeTypography.semiBold12.apply(
                              color: ThemeColors.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(
                                    () => TermsAndConditions(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => FlatButton(
                  actionText: 'Enviar',
                  onPressed: () async {
                    if (controller.isLoginValid.isTrue) {
                      await controller.sendVerificationCode();
                    } else {
                      // snackBar(
                      //   'Erro de autenticação',
                      //   controller.inputError,
                      //   icon: Coolicon(
                      //     icon: Coolicons.squareWarning,
                      //     color: Colors.white,
                      //   ),
                      // );
                    }
                  },
                  isValid: controller.isLoginValid.value,
                ),
              ),
              // Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}

class CodeVerificationView extends StatelessWidget {
  final AuthController controller;

  CodeVerificationView({super.key, required this.controller});

  final _pinFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    _pinFocus.requestFocus();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Expanded(
              //   child: Center(
              //     child: const Logo(),
              //   ),
              // ),
              const SizedBox(height: 64),
              CodeWidget(
                controller: controller.smsController,
                onSubmit: () => controller.verifySmsCode(),
                phoneNumber: controller.phoneController.text,
                // onChanged: controller.sms,
                focusNode: _pinFocus,
              ),
              Obx(
                () {
                  return FlatButton(
                    actionText: controller.loading.isTrue
                        ? 'Verificando os dados...'
                        : 'Verificar código',
                    onPressed: () async {
                      await controller.verifySmsCode();

                      _pinFocus.unfocus();
                    },
                    isValid: controller.isSmsValid.value,
                    backgroundColor: controller.loading.isTrue
                        ? ThemeColors.secondary
                        : ThemeColors.primary,
                  );
                },
              ),
              const SizedBox(height: 16),
              Obx(
                () => TextButton(
                  onPressed: () async {
                    if (controller.isCountdownFinished.isTrue) {
                      await controller.sendVerificationCode();
                    }
                  },
                  child: Text(
                    controller.isCountdownFinished.isTrue
                        ? 'Reenviar código '
                            '(${controller.minutes.value.toString().padLeft(2, '0')}'
                            ':${controller.seconds.value.toString().padLeft(2, '0')})'
                        : '',
                    style: controller.isCountdownFinished.isTrue
                        ? ThemeTypography.semiBold14.apply(
                            color: ThemeColors.primary,
                          )
                        : ThemeTypography.regular14.apply(
                            color: ThemeColors.grey4,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
