
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/models/selectable_item.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class CustomBottomSheet<T extends SelectableItem> extends StatelessWidget {
  final List<T> items;
  final String title;
  final Function(T) onItemSelected;

  CustomBottomSheet({
    super.key,
    required this.items,
    required this.title,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return items.length <= 15
        ? _buildSimpleBottomSheet()
        : _buildFullBottomSheet(context);
  }


  final searchController = TextEditingController();

  Widget _buildSimpleBottomSheet() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ListView(
        // mainAxisSize: MainAxisSize.min,
        shrinkWrap: true,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                title,
                style: ThemeTypography.medium16.apply(
                  color: ThemeColors.primary,
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

  Widget _buildFullBottomSheet(BuildContext context) {
    return Container(
      constraints:
      BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            title,
            style: ThemeTypography.medium16.apply(
              color: ThemeColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          // SearchInput(
          //   searchText: '',
          //   onSearch: (String v) {},
          //   hintText: 'Buscar itens',
          // ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              // controller: scrollController,
              itemCount: items.length,
              itemBuilder: (context, index) => _buildListItem(items[index]),
            ),
          ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                item.title,
                // textAlign: TextAlign.center,
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
