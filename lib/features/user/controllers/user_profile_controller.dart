import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/rating/repositories/rating_repository.dart';
import 'package:splach/features/user/models/gallery.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/gallery_repository.dart';
import 'package:splach/features/user/repositories/gallery_storage_repository.dart';
import 'package:splach/repositories/firestore_repository.dart';

class UserProfileController extends GetxController {
  UserProfileController(this.user);

  final RatingRepository _ratingRepository = Get.find();
  final _galleryStorageRepository = Get.put(GalleryStorageRepository());
  final _galleryRepository = Get.put(GalleryRepository());

  final User user;
  final User currentUser = Get.find();
  final image = Rx<File?>(null);
  final galleryImages = <Gallery>[].obs;
  final description = TextEditingController();

  final loading = false.obs;

  bool get isCurrentUser => user.id == currentUser.id;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getTotalRatings();
    _listenToGalleryImages();
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
      var totalRatingValue = 0;
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
}
