import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/components/group_chat_list_item.dart';
import 'package:splach/features/group_chat/views/group_chat_edit_view.dart';
import 'package:splach/features/group_chat/views/group_chat_view.dart';
import 'package:splach/features/home/components/category_button.dart';
import 'package:splach/features/group_chat/components/shimmer_chat_group_list_item.dart';
import 'package:splach/features/home/controllers/home_controller.dart';
import 'package:splach/features/notification/views/notification_view.dart';
import 'package:splach/models/chat_category.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:badges/badges.dart' as badges;

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 76,
                expandedHeight: 56,
                elevation: 3,
                shadowColor: Colors.black54,
                stretch: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                pinned: true,
                // centerTitle: true,
                title: Text(
                  'splach',
                  style: ThemeTypography.logotype.apply(
                    color: ThemeColors.primary,
                  ),
                ),
                actions: [
                  Center(
                    child: badges.Badge(
                      position: badges.BadgePosition.topEnd(
                        top: 5,
                        end: 5,
                      ),
                      badgeContent: Text(
                        controller.notifications.length.toString(),
                        style: ThemeTypography.semiBold12.apply(
                          color: Colors.white,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => Get.to(
                          () => NotificationView(
                            notifications: controller.notifications,
                          ),
                        ),
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.to(
                      () => GroupChatEditView(),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 88,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final category = categories[index];
                      return CategoryButton(
                        controller: controller,
                        category: category,
                      );
                    },
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (controller.loading.isTrue) {
                      return const ShimmerChatGroupListItem();
                    }
                    final chat = controller.filteredGroupChats[index];
                    return ChatLargeListItem(
                      chat: chat,
                      onPressed: () async {
                        await controller.addParticipantToChat(chat);
                        Get.to(
                          () => ChatView(chat: chat),
                        );
                      },
                    );
                  },
                  childCount: controller.loading.value
                      ? 5
                      : controller.filteredGroupChats.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
