import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:splach/features/auth/views/auth_view.dart';
import 'package:splach/features/home/views/base_view.dart';
import 'package:splach/themes/theme_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      title: 'Splach',
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: ThemeColors.primary,
          ),
        ),
      ),
      initialRoute: '/auth',
      getPages: [
        GetPage(
          name: '/auth',
          page: () => const AuthView(),
        ),
        GetPage(
          name: '/home',
          page: () => const BaseView(),
        ),
      ],
    );
  }
}
