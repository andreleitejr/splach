import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Position? _userLocation;

  Position? get userLocation => _userLocation;
  StreamSubscription<Position>? _positionStreamSubscription;

  Future<bool> requestLocationPermission() async {
    try {
      final LocationPermission permission =
          await Geolocator.requestPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      debugPrint('Erro ao solicitar permissão de localização: $e');
      return false;
    }
  }

  Future<Position?> getCurrentLocation() async {
    try {

      if (!await Geolocator.isLocationServiceEnabled()) {
        await requestLocationPermission();
        debugPrint('Serviço de localização desativado.');
        return null;
      }

      final LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final LocationPermission permission =
            await Geolocator.requestPermission();
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          debugPrint('Permissões de localização não concedidas.');
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      return position;
    } catch (e) {
      debugPrint('Erro ao obter a localização: $e');
      return null;
    }
  }

  Future<bool> checkLocationPermission() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
  }

  StreamSubscription<Position?> startListeningToLocationChanges(
      void Function(Position) onLocationChanged) {
    _positionStreamSubscription?.cancel();

    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 3,
      ),
    ).listen((Position position) {
      onLocationChanged(position);
    });
  }

  double calculateDistanceInMeters(Position origin, Position destination) {
    return Geolocator.distanceBetween(
      origin.latitude,
      origin.longitude,
      destination.latitude,
      destination.longitude,
    );
  }
}
