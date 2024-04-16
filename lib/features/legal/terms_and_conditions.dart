import 'package:flutter/material.dart';
import 'package:splach/themes/theme_typography.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos e Condições'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: '1. Introdução\n',
                style: ThemeTypography.semiBold16.apply(color: Colors.black),
                children: [
                  textSpan(
                    text:
                        '1.1 Bem-vindo ao Vagali, uma plataforma online operada pela Vagali Serviços Digitais Ltda., localizada na Rua Exemplo, 123, São Paulo, SP, CEP: 12345-678, inscrita no CNPJ sob o número 12.345.678/0001-90. O Vagali facilita o aluguel de vagas de garagem entre usuários cadastrados ("Locadores") e usuários em busca de vagas de estacionamento ("Locatários"). Ao utilizar os serviços oferecidos pelo Vagali, você concorda com os seguintes Termos e Condições.\n\n',
                  ),
                  textSpan(
                    text: '2. Cadastro e Responsabilidades dos Usuários\n',
                  ),
                  textSpan(
                    text:
                        '2.1 Ao se cadastrar no Vagali, os Locadores e Locatários concordam em fornecer informações precisas e atualizadas.\n',
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: '3. Reservas e Pagamentos\n',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  textSpan(
                    text:
                    '3.1 Os Locatários podem reservar vagas disponíveis através da plataforma Vagali. Os pagamentos serão processados eletronicamente, e o Vagali não se responsabiliza por transações financeiras fora da plataforma.\n',
                  ),
                  textSpan(
                    text:
                    '3.2 O Vagali poderá cobrar uma taxa de serviço sobre as transações realizadas na plataforma.\n',
                  ),
                  textSpan(
                    text:
                    '3.3 O Vagali reserva-se o direito de recusar ou cancelar reservas por razões legais, de segurança ou outras considerações.\n',
                  ),
                  textSpan(
                    text:
                    '3.4 Caso o Locatário cancele a reserva após a confirmação, será aplicada uma taxa de reserva, a critério do Vagali.\n\n',
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: '4. Responsabilidades do Locador\n',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  textSpan(
                    text:
                    '4.1 Os Locadores são responsáveis por garantir que as informações sobre a vaga e o espaço sejam precisas e atualizadas.\n',
                  ),
                  textSpan(
                    text:
                    '4.2 O Locador é exclusivamente responsável por quaisquer danos causados ao veículo do Locatário ou a qualquer propriedade durante o período de aluguel.\n',
                  ),
                  textSpan(
                    text:
                    '4.3 O Locador concorda em isentar o Vagali de quaisquer responsabilidades relacionadas a disputas, danos ou perdas decorrentes do uso da plataforma.\n',
                  ),
                  textSpan(
                    text:
                    '4.4 O Locador tem a responsabilidade de manter um ambiente seguro na área da vaga de estacionamento, seguindo todas as normas e regulamentos locais de segurança.\n\n',
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: '5. Responsabilidades do Locatário\n',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  textSpan(
                    text:
                    '5.1 Os Locatários concordam em utilizar as vagas de garagem de acordo com as informações fornecidas pelo Locador e respeitar as regras estabelecidas.\n',
                  ),
                  textSpan(
                    text:
                    '5.2 Os Locatários são responsáveis por quaisquer danos causados à vaga ou a quaisquer itens na vaga do Locador durante o período de aluguel.\n',
                  ),
                  textSpan(
                    text:
                    '5.3 O Locatário concorda em isentar o Vagali de quaisquer responsabilidades relacionadas a disputas, danos ou perdas decorrentes do uso da plataforma.\n',
                  ),
                  textSpan(
                    text:
                    '5.4 O Locatário é responsável por seguir todas as instruções e diretrizes fornecidas pelo Locador para garantir uma utilização adequada da vaga.\n\n',
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: '6. Conflitos e Resolução\n',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  textSpan(
                    text:
                    '6.1 O Vagali não é responsável por resolver conflitos entre Locadores e Locatários. Recomendamos que as partes envolvidas busquem resolver quaisquer disputas de forma amigável e cooperativa.\n',
                  ),
                  textSpan(
                    text:
                    '6.2 Os usuários concordam em participar de mediação ou arbitragem, quando necessário, para resolver disputas de forma rápida e eficiente, isentando o Vagali de responsabilidades decorrentes dessas disputas.\n\n',
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: '7. Segurança e Privacidade\n',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  textSpan(
                    text:
                    '7.1 O Vagali compromete-se a manter a segurança e a privacidade dos dados dos usuários, seguindo as melhores práticas de proteção de informações pessoais.\n',
                  ),
                  textSpan(
                    text:
                    '7.2 Os usuários concordam em adotar medidas adequadas para proteger suas informações de acesso não autorizado.\n',
                  ),
                  textSpan(
                    text:
                    '7.3 Qualquer violação da segurança ou suspeita de atividade fraudulenta deve ser imediatamente relatada ao Vagali para investigação.\n\n',
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: '8. Reembolso\n',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  textSpan(
                    text:
                    '8.1 Em casos excepcionais e a critério exclusivo do Vagali, poderá ser concedido o reembolso total ou parcial aos Locatários em situações de cancelamento por parte do Locador, indisponibilidade da vaga ou outras circunstâncias extraordinárias.\n',
                  ),
                  textSpan(
                    text:
                    '8.2 O Locatário compreende e concorda que o Vagali não é obrigado a reembolsar em casos de violação dos Termos e Condições por parte do Locatário.\n\n',
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: '9. Taxa de Reserva\n',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  textSpan(
                    text:
                    '9.1 Ao cancelar uma reserva após a confirmação, o Locatário concorda em pagar uma taxa de reserva, a ser determinada pelo Vagali.\n\n',
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: '10. Limitação de Responsabilidade\n',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  textSpan(
                    text:
                    '10.1 O Vagali não será responsável por danos diretos, indiretos, incidentais, especiais, consequentes ou punitivos resultantes do uso ou incapacidade de usar a plataforma.\n',
                  ),
                  textSpan(
                    text:
                    '10.2 O Vagali não garante a disponibilidade contínua e ininterrupta da plataforma e reserva-se o direito de interromper ou modificar os serviços a qualquer momento.\n\n',
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: '11. Alterações nos Termos e Condições\n',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  textSpan(
                    text:
                        '11.1 O Vagali se reserva o direito de alterar estes Termos e Condições a qualquer momento, mediante aviso prévio aos usuários.\n\n',
                  ),
                  textSpan(
                    text:
                        'Ao utilizar a plataforma Vagali, você concorda integralmente com estes Termos e Condições. Se tiver dúvidas ou preocupações, entre em contato conosco através dos canais de suporte disponíveis na plataforma.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan textSpan({required String text}) {
    return TextSpan(
      text: text,
      style: ThemeTypography.regular14.apply(
        color: Colors.black,
      ),
    );
  }
}
