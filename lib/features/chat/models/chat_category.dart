import 'package:flutter/material.dart';

import '../../../models/selectable_item.dart';

class ChatCategory extends SelectableItem {
  final String name;
  late final String category;
  final IconData icon;

  /// TROCAR TIPO

  ChatCategory({
    this.category = ChatCategory.all,
    this.name = 'All',
    this.icon = Icons.chat_bubble_outline_rounded,
  });

  @override
  String get title => name;

  static const all = 'all';
  static const chat = 'chat';
  static const dating = 'dating';
  static const event = 'event';
  static const friendship = 'friendship';
  static const other = 'other';
  static const studyGroup = 'studyGroup';
  static const work = 'work';
}

final categories = <ChatCategory>[
  /// "ALL" ALWAYS MUST BE THE FIRST ITEM
  ChatCategory(
    category: ChatCategory.all,
    name: 'All',
    icon: Icons.message_outlined,
  ),
  ChatCategory(
    category: ChatCategory.chat,
    name: 'Just Chat',
    icon: Icons.chat_bubble_outline_rounded,
  ),
  ChatCategory(
    category: ChatCategory.dating,
    name: 'Dating',
    icon: Icons.heart_broken_outlined,
  ),
  ChatCategory(
    category: ChatCategory.friendship,
    name: 'Friendship',
    icon: Icons.person_2_outlined,
  ),
  ChatCategory(
    category: ChatCategory.event,
    name: 'Events',
    icon: Icons.date_range,
  ),
  // ChatCategory(
  //   category: ChatCategory.studyGroup,
  //   name: 'Grupo de Estudo',
  //   icon: Icons.file_open_outlined,
  // ),
  ChatCategory(
    category: ChatCategory.work,
    name: 'Work',
    icon: Icons.work_outline_outlined,
  ),
  ChatCategory(
    category: ChatCategory.other,
    name: 'Other',
    icon: Icons.more_horiz_outlined,
  ),
];
