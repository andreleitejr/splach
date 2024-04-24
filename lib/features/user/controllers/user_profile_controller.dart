import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/rating/models/rating.dart';
import 'package:splach/features/rating/repositories/rating_repository.dart';
import 'package:splach/features/user/models/gallery.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/gallery_repository.dart';
import 'package:splach/features/user/repositories/gallery_storage_repository.dart';
import 'package:splach/repositories/firestore_repository.dart';

class UserProfileController extends GetxController {
  UserProfileController(this.user) {
    _galleryRepository = GalleryRepository(user);
  }

  final RatingRepository _ratingRepository = Get.find();
  final _galleryStorageRepository = Get.put(GalleryStorageRepository());
  late GalleryRepository _galleryRepository;

  final User user;
  final image = Rx<File?>(null);
  final galleryImages = <Gallery>[].obs;
  final description = TextEditingController();
  final score = 0.toDouble().obs;
  final userRatings = <Rating>[].obs;

  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    loading.value = true;
    await getTotalRatings();
    _listenToGalleryImages();
    await _fetchUserRatings();
    checkRatingValue();
    loading.value = false;
  }

  void _listenToGalleryImages() async {
    _galleryRepository.streamAll().listen((galleryImageData) async {
      galleryImages.assignAll(galleryImageData);
      galleryImages.sort((b, a) => a.createdAt.compareTo(b.createdAt));
    });
  }

  Future<void> getTotalRatings() async {
    final ratings = await _ratingRepository.getRating(user.id!);
    if (ratings.isNotEmpty) {
      double totalRatingValue = 0;
      var numberOfRatings = 0;

      for (final rating in ratings) {
        if (rating.score >= 0 && rating.score <= 5) {
          totalRatingValue += rating.score;
          numberOfRatings++;
        }
      }

      if (numberOfRatings > 0) {
        final averageRating = totalRatingValue / numberOfRatings;
        user.rating = averageRating.round();
        update();
      }
    }
  }

  Future<SaveResult?> save() async {
    loading.value = true;

    final imageUrl = await _uploadImageIfRequired();

    /// UPLOAD DE FOTO AQUI
    final galleryImage = Gallery(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      image: imageUrl!,
      description: description.text,
    );

    final result = await _galleryRepository.save(galleryImage);

    loading.value = false;
    return result;
  }

  Future<String?> _uploadImageIfRequired() async {
    if (image.value == null) return null;
    return await _galleryStorageRepository.upload(image.value!);
  }

  Future<void> _fetchUserRatings() async {
    userRatings.value = await _ratingRepository.getRating(Get.find<User>().id!,
        isUserRatings: true);
  }

  Future<void> checkRatingValue() async {
    if (user.isCurrentUser) return;

    final rating = await _ratingRepository.checkRatingExists(user.id!);
    if (rating != null) {
      score.value = rating.score.toDouble();
      // ratings.add(rating);
    }
  }

  bool alreadyRated(String ratedId) {
    return userRatings.any((rating) => rating.ratedId == ratedId);
  }

  Future<SaveResult?> rate(String ratedId) async {
    if (alreadyRated(ratedId)) {
      final rating = userRatings.firstWhere((r) => r.ratedId == ratedId);

      rating.score = score.value;
      await _ratingRepository.update(rating);
    } else {
      final newRating = Rating(
        userId: user.id!,
        userNickname: user.nickname,
        ratedId: ratedId,
        score: score.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return await _ratingRepository.save(newRating);
    }
  }
}
