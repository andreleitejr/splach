import 'package:badges/badges.dart' as badges;
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

class BaseController extends GetxController {
  final User user = Get.find();
  var selectedIndex = 0.obs;
  final notificationController = Get.put( NotificationController());

}

class BaseView extends StatefulWidget {
  final int selectedIndex;

  const BaseView({super.key, this.selectedIndex = 0});

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  late BaseController controller;

  List<Widget> get _pages => [
        HomeView(),
        NotificationView(
          controller: controller.notificationController,
        ),
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
        () => SizedBox(
          height: 75,
          child: BottomNavigationBar(
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
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavBarItems() {
    return [
      _buildNavBarItem('', 'Home'),
      _buildNavBarItemWithBadge('Notifications'),
      _buildNavBarItemWithAvatar(),
    ];
  }

  BottomNavigationBarItem _buildNavBarItem(String icon, String label) {
    return BottomNavigationBarItem(
      icon: const Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.home_outlined),
      ),
      activeIcon: const Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.home),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildNavBarItemWithBadge(String label) {
    return BottomNavigationBarItem(
      icon: _badge(
        Icons.notifications_outlined,
        Colors.black,
      ),
      activeIcon: _badge(
        Icons.notifications,
        ThemeColors.primary,
      ),
      label: label,
    );
  }

  Widget _badge(IconData icon, Color iconColor) {
    return badges.Badge(
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
      child: Icon(
        icon,
        color: iconColor,
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItemWithAvatar() {
    return BottomNavigationBarItem(
      icon: AvatarImage(
        image: controller.user.image!,
      ),
      activeIcon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ThemeColors.primary,
          ),
        ),
        child: AvatarImage(
          image: controller.user.image!,
        ),
      ),
      label: '',
    );
  }
}
