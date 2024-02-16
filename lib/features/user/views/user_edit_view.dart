import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/address/components/address_inputs.dart';
import 'package:splach/features/user/controllers/user_edit_controller.dart';
import 'package:splach/widgets/input.dart';

class UserEditView extends StatelessWidget {
  final controller = Get.put(UserEditController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Input(
                controller: controller.imageController,
                labelText: 'Imagem URL',
              ),
              Input(
                controller: controller.documentController,
                labelText: 'Documento',
              ),
              Input(
                controller: controller.firstNameController,
                labelText: 'Nome',
              ),
              Input(
                controller: controller.lastNameController,
                labelText: 'Sobrenome',
              ),
              Input(
                controller: controller.nicknameController,
                labelText: 'Apelido',
              ),
              Input(
                controller: controller.phoneController,
                labelText: 'Telefone',
              ),
              Input(
                controller: controller.genderController,
                labelText: 'Gênero',
              ),
              Input(
                controller: controller.birthdayController,
                labelText: 'Data de Nascimento',
              ),
              AddressInputs(
                postalCodeController: controller.postalCodeController,
                streetController: controller.streetController,
                numberController: controller.numberController,
                cityController: controller.cityController,
                stateController: controller.stateController,
                countryController: controller.countryController,
                complementController: controller.complementController,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  controller.save();
                  Get.back(); // Volte para a tela anterior
                },
                child: Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
