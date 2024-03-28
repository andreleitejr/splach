import '../../../models/selectable_item.dart';

class ChatCategory extends SelectableItem {
  final String name;
  late final String category;

  ChatCategory({
    this.category = ChatCategory.all,
    this.name = 'Todos',
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
  ),
  ChatCategory(
    category: ChatCategory.chat,
    name: 'Bate-papo',
  ),
  ChatCategory(
    category: ChatCategory.dating,
    name: 'Namoro',
  ),
  ChatCategory(
    category: ChatCategory.friendship,
    name: 'Amizade',
  ),
  ChatCategory(
    category: ChatCategory.event,
    name: 'Eventos',
  ),
  ChatCategory(
    category: ChatCategory.studyGroup,
    name: 'Grupo de Estudo',
  ),
  ChatCategory(
    category: ChatCategory.work,
    name: 'Trabalho',
  ),
  ChatCategory(
    category: ChatCategory.work,
    name: 'Outros',
  ),
];
