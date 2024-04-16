import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/components/group_chat_list_item.dart';
import 'package:splach/features/chat/views/chat_edit_view.dart';
import 'package:splach/features/chat/views/chat_view.dart';
import 'package:splach/features/home/components/category_button.dart';
import 'package:splach/features/chat/components/shimmer_chat_group_list_item.dart';
import 'package:splach/features/home/controllers/home_controller.dart';
import 'package:splach/features/chat/models/chat_category.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

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
                  IconButton(
                    onPressed: () => Get.to(
                      () => ChatEditView(),
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
