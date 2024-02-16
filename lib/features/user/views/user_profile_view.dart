import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/user/controllers/user_profile_controller.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/widgets/flat_button.dart';

class UserProfileView extends StatefulWidget {
  final User user;

  const UserProfileView({super.key, required this.user});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late UserProfileController controller;

  @override
  void initState() {
    controller = Get.put(UserProfileController(widget.user));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibir informações do usuário, como nome, foto, etc.

            SizedBox(height: 16),

            Obx(
              () => Text(
                'Seguidores: ${controller.followers.length}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

           const  SizedBox(height: 16),

            Obx(
              () => Text(
                'Seguindo: ${controller.followings.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            Obx(() {
              if (controller.isFollowingUser) {
                return FlatButton(
                  backgroundColor: Colors.red,
                  actionText: 'Deixar de seguir',
                  onPressed: () => controller.unfollow(),
                );
              }
              return FlatButton(
                actionText:
                    'Seguir${controller.isFollowedByUser ? ' de volta' : ''}',
                onPressed: () => controller.follow(),
              );
            })
          ],
        ),
      ),
    );
  }
}
