import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/home/views/home_view.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class BaseController extends GetxController {
  // final HomeController homeController = HomeController();
  // BaseController();

  // final User tenant = Get.find();

  // final int? index;

  var selectedIndex = 0.obs;
}

class BaseView extends StatefulWidget {
  final int selectedIndex;

  const BaseView({super.key, this.selectedIndex = 0});

  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  late BaseController controller;

  final List<Widget> _pages = [
    HomeView(),
    // UserProfileView(user: Get.find<User>()),
  ];

  @override
  void initState() {
    controller = Get.put(BaseController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedIndex(widget.selectedIndex);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          selectedLabelStyle: ThemeTypography.regular9.apply(
            color: ThemeColors.primary,
          ),
          unselectedLabelStyle: ThemeTypography.regular9.apply(
            color: ThemeColors.grey4,
          ),
          items: _buildBottomNavBarItems(),
          currentIndex: controller.selectedIndex.value,
          unselectedItemColor: ThemeColors.grey3,
          selectedItemColor: ThemeColors.primary,
          onTap: controller.selectedIndex,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavBarItems() {
    return [
      _buildNavBarItem('', 'Home'),
      _buildNavBarItem('', 'Profile'),
    ];
  }

  BottomNavigationBarItem _buildNavBarItem(String icon, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.home),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.add),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildNavBarItemWithAvatar() {
    return BottomNavigationBarItem(
      icon: Container(
        margin: const EdgeInsets.only(top: 8),
        height: 38,
        width: 38,
        child: Text(''),
      ),
      activeIcon: Container(
        margin: const EdgeInsets.only(top: 8),
        height: 38,
        width: 38,
        child: Icon(Icons.access_alarm),
      ),
      label: '',
    );
  }
}
