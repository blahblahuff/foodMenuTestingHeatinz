import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final Function()? onTap;

  const ProductTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title ?? 'Title not available'),
      subtitle: Text(subtitle ?? 'Subtitle not available'),
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image_not_supported, size: 50),
        ),
      ),
      onTap: onTap as void Function()?,
    );
  }
}
