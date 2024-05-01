import 'package:flutter/material.dart';
import 'package:splach/themes/theme_icons.dart';

import '../../../models/selectable_item.dart';

class ChatCategory extends SelectableItem {
  final String name;
  late final String category;
  final String icon;

  /// TROCAR TIPO

  ChatCategory({
    this.category = ChatCategory.all,
    this.name = 'All',
    this.icon = ThemeIcons.chat,
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
    icon: ThemeIcons.chat,
  ),
  ChatCategory(
    category: ChatCategory.chat,
    name: 'Just Chat',
    icon: ThemeIcons.chatAlt,
  ),
  ChatCategory(
    category: ChatCategory.dating,
    name: 'Dating',
    icon: ThemeIcons.heart,
  ),
  ChatCategory(
    category: ChatCategory.friendship,
    name: 'Friendship',
    icon:  ThemeIcons.people,
  ),
  ChatCategory(
    category: ChatCategory.event,
    name: 'Events',
    icon: ThemeIcons.calendar,
  ),
  // ChatCategory(
  //   category: ChatCategory.studyGroup,
  //   name: 'Grupo de Estudo',
  //   icon: Icons.file_open_outlined,
  // ),
  ChatCategory(
    category: ChatCategory.work,
    name: 'Work',
    icon: ThemeIcons.suitcase,
  ),
  ChatCategory(
    category: ChatCategory.other,
    name: 'Other',
    icon:  ThemeIcons.iceCream,
  ),
];
