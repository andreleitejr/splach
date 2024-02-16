import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/group_chat/repositories/group_chat_repository.dart';
import 'package:splach/features/group_chat/views/group_chat_edit_view.dart';
import 'package:splach/features/group_chat/views/group_chat_view.dart';
import 'package:splach/features/home/controllers/home_controller.dart';
import 'package:splach/models/chat_category.dart';
import 'package:splach/repositories/chat_repository.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/shimmer_box.dart';

class HomeView extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());

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
                backgroundColor: Colors.white,
                pinned: true,
                centerTitle: true,
                title: Text(
                  'Splach',
                  style: ThemeTypography.semiBold16
                      .apply(color: ThemeColors.primary),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.to(
                      () => GroupChatEditView(),
                    ),
                    child: Text('Criar'),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 88,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final category = categories[index];
                      return _buildCategoryButton(
                        category,
                      );
                    },
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final chat = _controller.filteredGroupChats[index];
                    return GestureDetector(
                      onTap: () async {
                        await _controller.addChatParticipant(chat);
                        Get.to(
                          () => ChatView(chat: chat),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    chat.images.first,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(chat.title),
                            const SizedBox(height: 4),
                            Text(chat.description),
                            const SizedBox(height: 4),
                            // Text(chat.distance!.toString()),
                            // const SizedBox(height: 4),
                            Text(
                              'Total participants: ${chat.participants.length.toString()}',
                            ),
                            // const SizedBox(height: 4),
                            // Text(
                            //     'Coordinates: ${chat.location.latitude}, ${chat.location.longitude}'),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _controller.filteredGroupChats.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(ChatCategory? category) {
    return Obx(
      () {
        final isSelected = _controller.category.value == category!;

        final loading = _controller.loading.value;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShimmerBox(
                  loading: false,
                  child: GestureDetector(
                    onTap: () {
                      _controller.category.value = category;
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? ThemeColors.primary
                            : ThemeColors.grey1,
                      ),
                      child: Center(
                          child: Icon(
                        Icons.access_alarm,
                      )),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 48,
                  height: 24,
                  color: Colors.white.withOpacity(0.00005),
                  child: ShimmerBox(
                    loading: loading,
                    child: Text(
                      category.name,
                      style: ThemeTypography.regular10,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
          ],
        );
      },
    );
  }
}
