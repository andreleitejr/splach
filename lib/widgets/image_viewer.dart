import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/themes/theme_typography.dart';

class ImageViewer extends StatelessWidget {
  final List<String> images;
  final int initialIndex;
  final String? title;
  final String? description;

  const ImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.75),
      insetPadding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (title != null) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                title!,
                style: ThemeTypography.semiBold14.apply(
                  color: Colors.white,
                ),
              ),
            ),
          ],
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.width,
              child: PageView.builder(
                itemCount: images.length,
                controller: PageController(
                  initialPage: initialIndex,
                ),
                itemBuilder: (context, index) {
                  final image = images[index];
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                description!,
                style: ThemeTypography.regular14.apply(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
