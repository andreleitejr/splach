import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageViewer extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const ImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.75),
      insetPadding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          Container(
            height: MediaQuery.of(context).size.width,
            child: PageView.builder(
              itemCount: images.length,
              controller: PageController(
                initialPage: initialIndex,
              ),
              itemBuilder: (context, index) {
                final image = images[index];
                return Container(
                  constraints: const BoxConstraints(
                    maxHeight: 180,
                    maxWidth: 180,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(
                        base64Decode(image),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 64),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
