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
                        ? 'Verifying your data...'
                        : 'Verify code',
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
              Obx(
                () => Column(
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
                        controller.countdownText,
                        style: controller.isCountdownFinished.isTrue
                            ? ThemeTypography.semiBold14.apply(
                                color: ThemeColors.primary,
                              )
                            : ThemeTypography.regular14.apply(
                                color: ThemeColors.grey3,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
