// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:splach/features/rating/models/rating.dart';
// import 'package:splach/features/rating/repositories/rating_repository.dart';
// import 'package:splach/features/user/models/user.dart';
// import 'package:splach/widgets/flat_button.dart';
//
// class RatingBottomSheet extends StatefulWidget {
//   final String ratedId;
//   final String ratedTitle;
//
//   const RatingBottomSheet({
//     super.key,
//     required this.ratedId,
//     required this.ratedTitle,
//   });
//
//   @override
//   _RatingBottomSheetState createState() => _RatingBottomSheetState();
// }
//
// class _RatingBottomSheetState extends State<RatingBottomSheet> {
//   late RatingController controller;
//
//   @override
//   void initState() {
//     controller = Get.put(RatingController(widget.ratedId));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Avalie ${widget.ratedTitle}',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18.0,
//             ),
//           ),
//           const SizedBox(height: 16.0),
//         ],
//       ),
//     );
//   }
// }
