import 'selectable_item.dart';

class ChatCategory extends SelectableItem {
  final String name;
  late final String tag;

  ChatCategory({
    this.tag = ChatCategory.all,
    this.name = 'Todos',
  });

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  static ChatCategory fromMap(Map<String, dynamic> map) {
    return ChatCategory(
      tag: map['tag'],
      name: map['name'],
    );
  }

  @override
  String get title => name;

  static const all = 'all';
  static const chat = 'chat';
  static const dating = 'dating';
  static const event = 'event';
  static const friendship = 'friendship';
  static const studyGroup = 'studyGroup';
  static const work = 'work';
}

final categories = <ChatCategory>[
  ChatCategory(
    tag: ChatCategory.all,
    name: 'Todos',
  ),
  ChatCategory(
    tag: ChatCategory.chat,
    name: 'Bate-papo',
  ),
  ChatCategory(
    tag: ChatCategory.dating,
    name: 'Namoro',
  ),
  ChatCategory(
    tag: ChatCategory.friendship,
    name: 'Amizade',
  ),
  ChatCategory(
    tag: ChatCategory.event,
    name: 'Eventos',
  ),
  ChatCategory(
    tag: ChatCategory.studyGroup,
    name: 'Grupo de Estudo',
  ),
  ChatCategory(
    tag: ChatCategory.work,
    name: 'Trabalho',
  ),
];
