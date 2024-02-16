import 'package:splach/models/selectable_item.dart';

class BrazilianState extends SelectableItem{
  final String name;
  final String acronym;

  BrazilianState(this.name, this.acronym);

  static const acre = 'AC';
  static const alagoas = 'AL';
  static const amapa = 'AP';
  static const amazonas = 'AM';
  static const bahia = 'BA';
  static const ceara = 'CE';
  static const distritoFederal = 'DF';
  static const espiritoSanto = 'ES';
  static const goias = 'GO';
  static const maranhao = 'MA';
  static const matoGrosso = 'MT';
  static const matoGrossoDoSul = 'MS';
  static const minasGerais = 'MG';
  static const para = 'PA';
  static const paraiba = 'PB';
  static const parana = 'PR';
  static const pernambuco = 'PE';
  static const piaui = 'PI';
  static const rioDeJaneiro = 'RJ';
  static const rioGrandeDoNorte = 'RN';
  static const rioGrandeDoSul = 'RS';
  static const rondonia = 'RO';
  static const roraima = 'RR';
  static const santaCatarina = 'SC';
  static const saoPaulo = 'SP';
  static const sergipe = 'SE';
  static const tocantins = 'TO';

  @override
  String get title => name;
}

final statesList = <BrazilianState>[
  BrazilianState('Acre', BrazilianState.acre),
  BrazilianState('Alagoas', BrazilianState.alagoas),
  BrazilianState('Amapá', BrazilianState.amapa),
  BrazilianState('Amazonas', BrazilianState.amazonas),
  BrazilianState('Bahia', BrazilianState.bahia),
  BrazilianState('Ceará', BrazilianState.ceara),
  BrazilianState('Distrito Federal', BrazilianState.distritoFederal),
  BrazilianState('Espírito Santo', BrazilianState.espiritoSanto),
  BrazilianState('Goiás', BrazilianState.goias),
  BrazilianState('Maranhão', BrazilianState.maranhao),
  BrazilianState('Mato Grosso', BrazilianState.matoGrosso),
  BrazilianState('Mato Grosso do Sul', BrazilianState.matoGrossoDoSul),
  BrazilianState('Minas Gerais', BrazilianState.minasGerais),
  BrazilianState('Pará', BrazilianState.para),
  BrazilianState('Paraíba', BrazilianState.paraiba),
  BrazilianState('Paraná', BrazilianState.parana),
  BrazilianState('Pernambuco', BrazilianState.pernambuco),
  BrazilianState('Piauí', BrazilianState.piaui),
  BrazilianState('Rio de Janeiro', BrazilianState.rioDeJaneiro),
  BrazilianState('Rio Grande do Norte', BrazilianState.rioGrandeDoNorte),
  BrazilianState('Rio Grande do Sul', BrazilianState.rioGrandeDoSul),
  BrazilianState('Rondônia', BrazilianState.rondonia),
  BrazilianState('Roraima', BrazilianState.roraima),
  BrazilianState('Santa Catarina', BrazilianState.santaCatarina),
  BrazilianState('São Paulo', BrazilianState.saoPaulo),
  BrazilianState('Sergipe', BrazilianState.sergipe),
  BrazilianState('Tocantins', BrazilianState.tocantins),
];
