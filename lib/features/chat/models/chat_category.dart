import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/selectable_item.dart';

class ChatCategory extends SelectableItem {
  final String name;
  late final String category;
  final IconData icon;

  /// TROCAR TIPO

  ChatCategory({
    this.category = ChatCategory.all,
    this.name = 'Todos',
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
    name: 'Todos',
    icon: Icons.message_outlined,
  ),
  ChatCategory(
    category: ChatCategory.chat,
    name: 'Bate-papo',
    icon: Icons.chat_bubble_outline_rounded,
  ),
  ChatCategory(
    category: ChatCategory.dating,
    name: 'Namoro',
    icon: Icons.heart_broken_outlined,
  ),
  ChatCategory(
    category: ChatCategory.friendship,
    name: 'Amizade',
    icon: Icons.person_2_outlined,
  ),
  ChatCategory(
    category: ChatCategory.event,
    name: 'Eventos',
    icon: Icons.date_range,
  ),
  ChatCategory(
    category: ChatCategory.studyGroup,
    name: 'Grupo de Estudo',
    icon: Icons.file_open_outlined,
  ),
  ChatCategory(
    category: ChatCategory.work,
    name: 'Trabalho',
    icon: Icons.work_outline_outlined,
  ),
  ChatCategory(
    category: ChatCategory.other,
    name: 'Outros',
    icon: Icons.more_horiz_outlined,
  ),
];
