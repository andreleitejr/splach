import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/components/chat_input.dart';
import 'package:splach/features/group_chat/components/chat_message_box.dart';
import 'package:splach/features/group_chat/components/chat_system_message.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/models/message.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/avatar_image.dart';
import 'package:splach/widgets/top_navigation_bar.dart';

class ChatView extends StatefulWidget {
  final GroupChat chat;

  const ChatView({super.key, required this.chat});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late GroupChatController groupChatController;

  final TextEditingController messageController = TextEditingController();

  final ScrollController _controller = ScrollController();
  bool _showButton = false;

  @override
  void initState() {
    groupChatController = Get.put(GroupChatController(widget.chat));
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    // Remove o listener quando o widget for descartado
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  // Função chamada quando há uma alteração de rolagem
  void _scrollListener() {
    // Verifica se a posição da rolagem está próxima do fim da lista
    if (_controller.position.pixels >= MediaQuery.of(context).size.height) {
      setState(() {
        _showButton = true;
      });
    } else {
      setState(() {
        _showButton = false;
      });
    }
  }

  // Função chamada quando o botão é pressionado para rolar até o fim da lista
  void _scrollToBottom() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.arrow_back,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.people_alt_outlined,
                      ),
                      Icon(
                        Icons.notifications_outlined,
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Expanded(
                    child: Stack(
                      children: [
                        NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            _scrollListener();
                            return false;
                          },
                          child: ListView.builder(
                            controller: _controller,
                            reverse: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: groupChatController.messages.length,
                            itemBuilder: (context, index) {
                              final message =
                                  groupChatController.messages[index];
                              return Column(
                                children: [
                                  message.isFromSystem
                                      ? ChatSystemMessage(message: message)
                                      : ChatMessageBox(message: message),
                                  const SizedBox(height: 16),
                                ],
                              );
                            },
                          ),
                        ),
                        if (_showButton)
                          Positioned(
                            right: 24,
                            bottom: 24,
                            child: GestureDetector(
                              onTap: () => _scrollToBottom(),
                              child: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: ThemeColors.tertiary.withOpacity(0.85),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ThemeColors.tertiary.withOpacity(0.25),
                                      spreadRadius: 4,
                                      blurRadius: 20,
                                      offset: const Offset(-2, 5),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.keyboard_double_arrow_down,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                ChatInput(controller: groupChatController),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
