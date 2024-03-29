import 'package:splach/models/selectable_item.dart';

class ReportMessageTopic extends SelectableItem {
  final String name;
  late final String category;
  final String description;

  ReportMessageTopic({
    this.category = ReportMessageTopic.spam,
    this.name = 'Todos',
    required this.description,
  });

  @override
  String get title => name;

  // static const doNotLike = 'doNotLike';
  static const spam = 'spam';
  static const fakeNews = 'fakeNews';
  static const sexualActivity = 'sexualActivity';
  static const harassment = 'harassment';
  static const hateSpeech = 'hateSpeech';
  static const violence = 'violence';
  static const misinformation = 'misinformation';
  static const inappropriateLanguage = 'inappropriateLanguage';
  static const bullying = 'bullying';
  static const discrimination = 'discrimination';
  static const sensitiveContent = 'sensitiveContent';
  static const copyrightViolation = 'copyrightViolation';
  static const illegalActivities = 'illegalActivities';
  static const graphicContent = 'graphicContent';
  static const drugRelated = 'drugRelated';
  // static const gambling = 'gambling';
  // static const politicalPropaganda = 'politicalPropaganda';
  static const extremism = 'extremism';
  static const defamation = 'defamation';
  static const invasionOfPrivacy = 'invasionOfPrivacy';
  // static const selfHarm = 'selfHarm';
  static const other = 'other';
}

final reportMessageTopics = <ReportMessageTopic>[
  ReportMessageTopic(
      category: ReportMessageTopic.spam,
      name: 'Eu não gosto disso',
      description: 'Conteúdo irrelevante ou indesejado que não contribui para a discussão do grupo.'
  ),
  // ReportMessageTopic(
  //     category: ReportMessageTopic.fakeNews,
  //     name: 'Notícia falsa',
  //     description: 'Informação falsa ou enganosa, que pode causar confusão ou desinformação.'
  // ),
  ReportMessageTopic(
      category: ReportMessageTopic.sexualActivity,
      name: 'Atividade sexual',
      description: 'Conteúdo sexual explícito ou inadequado para o ambiente do grupo.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.harassment,
      name: 'Assédio',
      description: 'Comportamento ofensivo, abusivo ou intimidatório direcionado a outros membros do grupo.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.hateSpeech,
      name: 'Discurso de ódio',
      description: 'Mensagens que promovem a violência, discriminação ou intolerância contra grupos ou indivíduos.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.violence,
      name: 'Violência',
      description: 'Conteúdo que mostra ou promove violência física, danos ou abuso.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.misinformation,
      name: 'Desinformação',
      description: 'Propagação de informações falsas ou imprecisas que podem enganar ou confundir outros membros do grupo.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.inappropriateLanguage,
      name: 'Linguagem inadequada',
      description: 'Uso de linguagem vulgar, obscena ou ofensiva.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.bullying,
      name: 'Bullying',
      description: 'Comportamento repetitivo e hostil destinado a intimidar, humilhar ou prejudicar outros membros.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.discrimination,
      name: 'Discriminação',
      description: 'Tratamento injusto ou preconceituoso com base em características como raça, gênero, religião, etc.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.sensitiveContent,
      name: 'Conteúdo sensível',
      description: 'Mensagens que contêm material gráfico ou sensível, como violência gráfica, imagens perturbadoras, etc.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.copyrightViolation,
      name: 'Violação de direitos autorais',
      description: 'Uso não autorizado de material protegido por direitos autorais.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.illegalActivities,
      name: 'Atividades ilegais',
      description: 'Mensagens relacionadas a atividades ilegais, como venda de drogas, tráfico de armas, etc.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.graphicContent,
      name: 'Conteúdo gráfico',
      description: 'Imagens ou vídeos que mostram violência, ferimentos graves ou morte.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.drugRelated,
      name: 'Conteúdo relacionado a drogas',
      description: 'Mensagens que promovem o uso ou venda de drogas ilegais ou substâncias controladas.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.extremism,
      name: 'Extremismo',
      description: 'Promoção de ideias ou comportamentos extremistas, violentos ou radicais.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.defamation,
      name: 'Difamação',
      description: 'Espalhar informações falsas ou prejudiciais sobre uma pessoa ou organização.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.invasionOfPrivacy,
      name: 'Invasão de privacidade',
      description: 'Violação da privacidade pessoal de um indivíduo, como publicação não autorizada de informações privadas.'
  ),
  ReportMessageTopic(
      category: ReportMessageTopic.other,
      name: 'Outro',
      description: 'Qualquer assunto não listado acima que você considera ser uma violação das regras do grupo.'
  ),
];