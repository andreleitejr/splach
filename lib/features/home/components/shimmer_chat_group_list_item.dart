import 'package:flutter/material.dart';
import 'package:splach/widgets/shimmer_box.dart';

class ShimmerChatGroupListItem extends StatelessWidget {
  const ShimmerChatGroupListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      loading: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 175,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 14,
              width: MediaQuery.of(context).size.width * 0.65,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 24,
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(96),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
