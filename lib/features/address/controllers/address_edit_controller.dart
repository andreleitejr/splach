import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/address/models/address.dart';
import 'package:splach/services/address_service.dart';

class AddressEditController extends GetxController {
  @override
  Future<void> onInit() async {
    postalCodeController.addListener(() {
      fetchAddressDetails();
      update();
    });
    numberController.addListener(() async {
      if (streetController.text.isNotEmpty &&
          cityController.text.isNotEmpty &&
          stateController.text.isNotEmpty) {
        coordinates.value =
            await _addressService.getCoordinatesFromAddress(address);
        update();
      }
    });
    super.onInit();
  }

  final AddressService _addressService = AddressService();

  final currentAddress = Rx<Address?>(null);

  final isPostalCodeLoading = false.obs;

  final showErrors = RxBool(false);

  final coordinates = Rx<GeoPoint?>(null);
  final postalCodeController = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final countyController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final complementController = TextEditingController();

  void fillFormWithUserData() {
    final address = currentAddress.value!;

    postalCodeController.text = address.postalCode;
    streetController.text = address.street;
    numberController.text = address.number;
    cityController.text = address.city;
    stateController.text = address.state;
    countryController.text = address.country;
    complementController.text = address.complement ?? '';
  }

  Future<void> fetchAddressDetails() async {
    if (isPostalCodeValid.isTrue) {
      isPostalCodeLoading.value = true;
      final addressDetails =
          await _addressService.getAddressDetails(postalCodeClean.value);

      if (addressDetails != null) {
        streetController.text = addressDetails['logradouro'] ?? '';
        countyController.text = addressDetails['bairro'] ?? '';
        cityController.text = addressDetails['localidade'] ?? '';
        stateController.text = addressDetails['uf'] ?? '';
        countryController.text = 'Brasil';
        coordinates.value =
            await _addressService.getCoordinatesFromAddress(address);
      }

      isPostalCodeLoading.value = false;
    }
  }

  RxString get postalCodeClean =>
      postalCodeController.text.replaceAll('.', '').replaceAll('-', '').obs;

  RxString get postalCodeError =>
      (isPostalCodeValid.isTrue ? '' : 'Insira um CEP').obs;

  RxString get streetError =>
      (isStreetValid.isTrue ? '' : 'Insira o nome da rua').obs;

  RxString get numberError =>
      (isNumberValid.isTrue ? '' : 'Insira o número').obs;

  RxString get cityError => (isCityValid.isTrue ? '' : 'Insira uma cidade').obs;

  RxString get stateError =>
      (isStateValid.isTrue ? '' : 'Insira um estado').obs;

  String getError(RxString error) {
    if (showErrors.isTrue) {
      return error.value;
    }
    return '';
  }

  RxBool get isPostalCodeValid =>
      (postalCodeClean.isNotEmpty && postalCodeClean.value.length >= 8).obs;

  RxBool get isStreetValid => streetController.text.isNotEmpty.obs;

  RxBool get isNumberValid => numberController.text.isNotEmpty.obs;

  RxBool get isCityValid => cityController.text.isNotEmpty.obs;

  RxBool get isStateValid => stateController.text.isNotEmpty.obs;

  RxBool get isAddressValid => (isPostalCodeValid.isTrue &&
          isNumberValid.isTrue &&
          isStreetValid.isTrue &&
          isCityValid.isTrue &&
          isStateValid.isTrue)
      .obs;

  Address get address => Address(
        postalCode: postalCodeController.text,
        street: streetController.text,
        number: numberController.text,
        city: cityController.text,
        state: stateController.text,
        country: countryController.text,
        complement: complementController.text,
      );
}
