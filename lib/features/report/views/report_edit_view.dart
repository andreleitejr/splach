// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:splach/features/report/controllers/report_controller.dart';
// import 'package:splach/widgets/top_navigation_bar.dart';
//
// class SupportEditView extends StatelessWidget {
//   final controller = Get.put(ReportController());
//
//   final subjectController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final phoneController = TextEditingController();
//
//   SupportEditView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: TopNavigationBar(
//         title: 'Suporte',
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Obx(() {
//                 return Input2(
//                   value: controller.subject.value,
//                   controller: subjectController,
//                   hintText: 'Assunto',
//                   required: true,
//                   onChanged: controller.subject,
//                 );
//               }),
//               const SizedBox(height: 16),
//               Obx(
//                 () => Input2(
//                   value: controller.description.value,
//                   controller: descriptionController,
//                   hintText: 'Descrição do problema',
//                   required: true,
//                   maxLines: 5,
//                   onChanged: controller.description,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Obx(() {
//                 return Input2(
//                   value: controller.phone.value,
//                   controller: phoneController,
//                   hintText: 'Telefone para contato',
//                   required: true,
//                   onChanged: controller.phone,
//                 );
//               }),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'O número inserido permite contato via WhatsApp?',
//                       style: ThemeTypography.regular12.apply(
//                         color: ThemeColors.grey4,
//                       ),
//                     ),
//                   ),
//                   Obx(
//                     () => SwitchButton(
//                       value: controller.isWhatsApp.value,
//                       onChanged: controller.isWhatsApp,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               FlatButton(
//                 actionText: 'Solicitar Suporte',
//                 onPressed: () => handleButtonPress(),
//                 isValid: controller.isValid.value,
//               ),
//               Obx(() {
//                 if (controller.isWhatsApp.isFalse) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 16),
//                       Text(
//                         'Aviso: entraremos em contato pelo e-mail ${controller.user.email}',
//                         style: ThemeTypography.regular12.apply(
//                           color: ThemeColors.primary,
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//                 return Container();
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void showSnackBar(String title, String message) {
//     snackBar(
//       title,
//       message,
//       icon: Coolicon(
//         icon: Coolicons.squareWarning,
//         color: Colors.white,
//       ),
//     );
//   }
//
//   void showErrorMessageSnackbar(String title, String message) {
//     showSnackBar(title, message);
//   }
//
//   void showSuccessMessageSnackbar(String title, String message) {
//     showSnackBar(title, message);
//   }
//
//   void handleButtonPress() async {
//     if (controller.isValid.isTrue) {
//       final result = await controller.save();
//       if (result == SaveResult.success) {
//         Get.back();
//         showSuccessMessageSnackbar(
//           'Suporte enviado',
//           'Seu pedido de suporte foi enviado com sucesso. Entraremos em contato após a análise. Desde já, muito obrigado.',
//         );
//       } else {
//         showErrorMessageSnackbar(
//           'Erro inesperado',
//           'Um erro inesperado ocorreu. Tente novamente.',
//         );
//       }
//     } else {
//       showErrorMessageSnackbar(
//         'Erro de suporte',
//         controller.supportError,
//       );
//     }
//   }
// }
