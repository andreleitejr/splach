import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/top_navigation_bar.dart';

class ChatParticipantsView extends StatelessWidget {
  final List<User> users;

  const ChatParticipantsView({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigationBar(
        title: 'Members',
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 192,
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return _buildUserCard(users[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return GestureDetector(
      onTap: () => Get.to(
        () => UserProfileView(user: user),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: MemoryImage(
                  base64Decode(user.image),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Text(
          //   user.name,
          //   style: ThemeTypography.medium14.apply(
          //     color: ThemeColors.primary,
          //   ),
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          // ),
          Text(
            '@${user.nickname}',
            style: ThemeTypography.medium14.apply(
              color: ThemeColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${user.followers.length} followers',
            style: ThemeTypography.regular12.apply(
              color: ThemeColors.grey5,
            ),
          ),
        ],
      ),
    );
  }
}
