
import 'package:splach/models/selectable_item.dart';

class Gender extends SelectableItem {

  final String name;
  final String value;

  static const male = 'male';
  static const female = 'female';
  static const transgender = 'transgender';
  static const other = 'other';

  Gender(this.name, this.value);

  @override
  String get title => name;
}

final genders = <Gender>[
  Gender('Masculino', Gender.male),
  Gender('Feminino', Gender.female),
  Gender('Transgênero', Gender.transgender),
  Gender('Outros', Gender.other),
];
