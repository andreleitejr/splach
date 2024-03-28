import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/rating/models/rating.dart';
import 'package:splach/features/rating/repositories/rating_repository.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/widgets/flat_button.dart';

class RatingController extends GetxController {
  RatingController(this.ratedId);

  final _repository = Get.put(RatingRepository());
  final userRatings = <Rating>[].obs;
  final rating = Rx<Rating?>(null);
  final String ratedId;
  final ratingValue = 0.obs;

  final loading = false.obs;

  @override
  Future<void> onInit() async {
    loading.value = true;
    await _fetchUserRatings();
    loading.value = false;
    super.onInit();
  }

  Future<void> _fetchUserRatings() async {
    userRatings.value = await _repository.getAll(userId: Get.find<User>().id);

    if (alreadyRated) {
      rating.value =
          userRatings.firstWhere((rating) => rating.ratedId == ratedId);

      ratingValue.value = rating.value!.ratingValue;
    }
  }

  bool get alreadyRated {
    return userRatings.any((rating) => rating.ratedId == ratedId);
  }

  Future<void> rate() async {
    if (alreadyRated) {
      rating.value!.ratingValue = ratingValue.value;
      print(' HUASDHUDASHAUHUSDAHSDAHAUHDASU ${ rating.value!.ratingValue} ${rating.value?.id}');
      await _repository.update(rating.value!);
    } else {
      final newRating = Rating(
        ratedId: ratedId,
        ratingValue: ratingValue.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _repository.save(newRating);
    }
  }
}

class RatingBottomSheet extends StatefulWidget {
  final String ratedId;
  final String ratedTitle;

  const RatingBottomSheet({
    super.key,
    required this.ratedId,
    required this.ratedTitle,
  });

  @override
  _RatingBottomSheetState createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  late RatingController controller;

  @override
  void initState() {
    controller = Get.put(RatingController(widget.ratedId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Avalie ${widget.ratedTitle}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Obx(() {
            if (controller.loading.isTrue) {
              return Container();
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () {
                    controller.ratingValue.value = index + 1;
                  },
                  icon: Icon(
                    index < controller.ratingValue.value
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.orange,
                    size: 40.0,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16.0),
          Align(
            alignment: Alignment.center,
            child: FlatButton(
              onPressed: () {
                controller.rate();
                Get.back();
              },
              actionText: 'Avaliar',
            ),
          ),
        ],
      ),
    );
  }
}
