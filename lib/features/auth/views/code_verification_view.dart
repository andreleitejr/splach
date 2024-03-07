import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/auth/controllers/login_controller.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/code_widget.dart';
import 'package:splach/widgets/flat_button.dart';

class CodeVerificationView extends StatelessWidget {
  final LoginController controller;

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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // const Expanded(child: Center()),
              CodeWidget(
                controller: controller.smsController,
                onSubmit: () => controller.verifySmsCode(),
                phoneNumber: controller.phoneController.text,
                focusNode: _pinFocus,
              ),
              const SizedBox(height: 8),
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
                    isValid: controller.isValid.value,
                    backgroundColor: controller.isValid.isTrue
                        ? ThemeColors.primary
                        : ThemeColors.grey5,
                  );
                },
              ),
              Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 8),
                      TextButton(
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
                                  color: ThemeColors.grey5,
                                ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
