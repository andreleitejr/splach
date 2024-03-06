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
        Input(controller: postalCodeController, hintText: 'CEP'),
        Input(controller: streetController, hintText: 'Rua'),
        Input(controller: numberController, hintText: 'Número'),
        Input(controller: cityController, hintText: 'Cidade'),
        Input(controller: stateController, hintText: 'Estado'),
        Input(controller: countryController, hintText: 'País'),
        Input(controller: complementController, hintText: 'Complemento'),
      ],
    );
  }
}
