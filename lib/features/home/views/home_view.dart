import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/group_chat/repositories/group_chat_repository.dart';
import 'package:splach/features/group_chat/views/group_chat_edit_view.dart';
import 'package:splach/features/group_chat/views/group_chat_view.dart';
import 'package:splach/features/home/controllers/home_controller.dart';
import 'package:splach/repositories/chat_repository.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

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
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final chat = _controller.groupChats[index];
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
                  childCount: _controller.groupChats.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
