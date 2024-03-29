import 'package:get/get.dart';
import 'package:splach/features/rating/repositories/rating_repository.dart';
import 'package:splach/features/user/models/user.dart';

class UserProfileController extends GetxController {
  UserProfileController(this.user);

  final RatingRepository _ratingRepository = Get.find();

  final User user;
  final User currentUser = Get.find();

  bool get isCurrentUser => user.id == currentUser.id;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getTotalRatings();
  }

  Future<void> getTotalRatings() async {
    final ratings = await _ratingRepository.getRating(user.id!);
    if (ratings.isNotEmpty) {
      var totalRatingValue = 0;
      var numberOfRatings = 0;

      for (final rating in ratings) {
        if (rating.ratingValue >= 0 && rating.ratingValue <= 5) {
          totalRatingValue += rating.ratingValue;
          numberOfRatings++;
        }
      }

      if (numberOfRatings > 0) {
        final averageRating = totalRatingValue / numberOfRatings;
        user.rating = averageRating.round();
      }
    }
  }
}
