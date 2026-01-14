import 'package:flutter/material.dart';
import 'package:pheditor/widgets/image_card.dart';

class ImageGrid extends StatelessWidget {
  final List<ImageGridItem> items;

  const ImageGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ImageCard(imageUrl: item.thumbnailUrl, onTap: item.onTap);
      },
    );
  }
}

class ImageGridItem {
  final String thumbnailUrl;
  final VoidCallback onTap;

  const ImageGridItem({required this.thumbnailUrl, required this.onTap});
}
