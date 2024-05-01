import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/models/chat_category.dart';
import 'package:splach/features/home/controllers/home_controller.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/custom_icon.dart';
import 'package:splach/widgets/shimmer_box.dart';

class CategoryButton extends StatelessWidget {
  final HomeController controller;
  final ChatCategory category;

  const CategoryButton({
    super.key,
    required this.controller,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isSelected = controller.category.value == category;

        final loading = controller.loading.value;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                controller.category.value = category;
              },
              child: Column(
                children: [
                  ShimmerBox(
                    loading: loading,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? ThemeColors.primary
                            : ThemeColors.grey1,
                      ),
                      child: Center(
                        child: CustomIcon(
                          category.icon,
                          color: isSelected ? Colors.white : ThemeColors.grey4,
                          height: 26,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 48,
                    height: 16,
                    color: Colors.white.withOpacity(0.00005),
                    child: ShimmerBox(
                      loading: loading,
                      child: Text(
                        category.name,
                        style: ThemeTypography.regular10.apply(
                          color: isSelected
                              ? ThemeColors.primary
                              : ThemeColors.grey4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
        );
      },
    );
  }
}
