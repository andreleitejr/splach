import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/home/views/home_view.dart';
import 'package:splach/features/notification/controllers/notification_controller.dart';
import 'package:splach/features/notification/views/notification_view.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

import 'package:splach/widgets/avatar_image.dart';
import 'package:badges/badges.dart' as badges;

class BaseController extends GetxController {
  final User user = Get.find();
  var selectedIndex = 0.obs;
  final NotificationController notificationController = Get.find();
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
    Container(),
    NotificationView(),
    UserProfileView(user: Get.find<User>()),
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
            color: ThemeColors.grey5,
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
      _buildNavBarItem('', 'History'),
      _buildNavBarItemWithBadge('Notifications'),
      _buildNavBarItemWithAvatar(),
    ];
  }

  BottomNavigationBarItem _buildNavBarItem(String icon, String label) {
    return BottomNavigationBarItem(
      icon: const Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.home),
      ),
      activeIcon: const Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.add),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildNavBarItemWithBadge(String label) {
    return BottomNavigationBarItem(
      icon:  badges.Badge(
        showBadge: controller.notificationController.notifications.isNotEmpty,
        position: badges.BadgePosition.topEnd(
          top: -5,
          end: -5,
        ),
        badgeContent: Text(
          controller.notificationController.notifications.length.toString(),
          style: ThemeTypography.semiBold12.apply(
            color: Colors.white,
          ),
        ),
        child: const Icon(
          Icons.notifications,
          color: Colors.black,
        ),
      ),
      activeIcon: badges.Badge(
        position: badges.BadgePosition.topEnd(
          top: -5,
          end: -5,
        ),
        badgeContent: Text(
          controller.notificationController.notifications.length.toString(),
          style: ThemeTypography.semiBold12.apply(
            color: Colors.white,
          ),
        ),
        child: const Icon(
          Icons.notifications,
          color: ThemeColors.primary,
        ),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildNavBarItemWithAvatar() {
    return BottomNavigationBarItem(
      icon: AvatarImage(
        image: controller.user.image!,
      ),
      activeIcon: Container(
        margin: const EdgeInsets.only(top: 8),
        height: 38,
        width: 38,
        child: const Icon(Icons.access_alarm),
      ),
      label: '',
    );
  }
}
