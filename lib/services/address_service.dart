import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';
import 'package:splach/features/address/models/address.dart';

class AddressService {
  Future<Map<String, dynamic>?> getAddressDetails(String postalCode) async {
    final response =
        await get(Uri.parse('https://viacep.com.br/ws/$postalCode/json/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      return null;
    }
  }

  Future<GeoPoint?> getCoordinatesFromAddress(Address address) async {
    try {
      final fullAddress =
          '${address.street}, ${address.number}, ${address.city}, ${address.state}, ${address.country}';
      final locations = await locationFromAddress(fullAddress);
      if (locations.isNotEmpty) {
        final location = locations[0];
        return GeoPoint(location.latitude, location.longitude);
      }
    } catch (e) {
      print('Erro na obtenção de coordenadas a partir do endereço: $e');
    }
    return null;
  }
}
