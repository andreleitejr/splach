import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/models/selectable_item.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class ReportMessageBottomSheet<T extends SelectableItem>
    extends StatelessWidget {
  final List<T> items;
  final Function(T) onItemSelected;

  ReportMessageBottomSheet({
    super.key,
    required this.items,
    required this.onItemSelected,
  });

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          // const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Center(
              child: Text(
                'Por que gostaria de denunciar mensagem?',
                style: ThemeTypography.medium16.apply(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => _buildListItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildListItem(T item) {
    return GestureDetector(
      onTap: () {
        onItemSelected(item);
        Get.back();
      },
      child: Container(
        color: Colors.white.withOpacity(0),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                item.title,
                style: ThemeTypography.medium14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 0.75,
              width: double.infinity,
              color: ThemeColors.grey2,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
