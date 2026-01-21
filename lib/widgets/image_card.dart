import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pheditor/design/pallete.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const ImageCard({super.key, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Pallete.inputFieldBG,
            child: const Center(
              child: CircularProgressIndicator(
                color: Pallete.secondaryGreyText,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Pallete.inputFieldBG,
            child: const Icon(Icons.error_outline, color: Pallete.error),
          ),
          memCacheWidth: 300,
        ),
      ),
    );
  }
}
