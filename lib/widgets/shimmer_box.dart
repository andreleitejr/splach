import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:splach/themes/theme_colors.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    Key? key,
    required this.loading,
    required this.child,
  }) : super(key: key);

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return loading ? shimmer() : child;
  }

  Widget shimmer() {
    return Shimmer.fromColors(
      baseColor: ThemeColors.grey2,
      highlightColor: Colors.white,
      child: child is Text
          ? Container(
              height: (child as Text).style?.fontSize,
              width: (child as Text).data!.length * 10,
              constraints: const BoxConstraints(
                minWidth: 100,
                maxWidth: 350,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(100),
              ),
            )
          : child,
    );
  }
}
