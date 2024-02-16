import 'package:flutter/material.dart';
import 'package:splach/widgets/input.dart';

class AddressInputs extends StatelessWidget {
  final TextEditingController postalCodeController;
  final TextEditingController streetController;
  final TextEditingController numberController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController countryController;
  final TextEditingController complementController;

  AddressInputs({
    required this.postalCodeController,
    required this.streetController,
    required this.numberController,
    required this.cityController,
    required this.stateController,
    required this.countryController,
    required this.complementController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Input(controller: postalCodeController, labelText: 'CEP'),
        Input(controller: streetController, labelText: 'Rua'),
        Input(controller: numberController, labelText: 'Número'),
        Input(controller: cityController, labelText: 'Cidade'),
        Input(controller: stateController, labelText: 'Estado'),
        Input(controller: countryController, labelText: 'País'),
        Input(controller: complementController, labelText: 'Complemento'),
      ],
    );
  }
}
