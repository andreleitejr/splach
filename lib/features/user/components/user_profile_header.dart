import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_images.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/image_viewer.dart';

class UserProfileHeader extends StatefulWidget {
  final User user;

  const UserProfileHeader({super.key, required this.user});

  @override
  State<UserProfileHeader> createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              if (widget.user.image != null)
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ImageViewer(
                          images: [
                            widget.user.image!,
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeColors.tertiary.withOpacity(
                            0.5,
                          ),
                          spreadRadius: -8,
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.user.image!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              if (widget.user.rating != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgPicture.asset(
                      ThemeImages.ratingStar,
                      height: 15,
                      colorFilter: const ColorFilter.mode(
                        ThemeColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.only(top: 1),
                      height: 16,
                      child: Text(
                        widget.user.rating!.toDouble().toString(),
                        style: ThemeTypography.nickname,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ],
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    widget.user.name,
                    style: ThemeTypography.nickname,
                  ),
                  // const SizedBox(height: 2),
                  _buildDescriptionText(),
                  if (widget.user.instagram != null) ...[
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        if (!widget.user.isCurrentUser) {
                          // Abrir ads e redirecionar ao Instagram
                        }
                      },
                      child: Text(
                        'Instagram: @${widget.user.instagram!}',

                        /// TODO: Descomentar quando implementar o Ads
                        // widget.user.isCurrentUser
                        //     ? 'Instagram: @${widget.user.instagram!}'
                        //     : 'See on Instagram',
                        style: ThemeTypography.semiBold12.apply(
                          color: ThemeColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool showEntireDescription = false;

  Widget _buildDescriptionText() {
    final description = widget.user.description;
    final showAllButtonText = description.length > 50;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: description.length <= 50 || showEntireDescription
                ? description
                : description.substring(0, 50) +
                    (showAllButtonText ? "..." : ""),
            style: ThemeTypography.regular14.apply(
              color: ThemeColors.grey4,
            ),
          ),
          if (showAllButtonText) ...[
            TextSpan(
              text: showEntireDescription ? ' See less' : ' See all',
              style: ThemeTypography.regular14.apply(
                color: ThemeColors.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(
                    () {
                      showEntireDescription = !showEntireDescription;
                    },
                  );
                },
            ),
          ],
        ],
      ),
    );
  }
}
