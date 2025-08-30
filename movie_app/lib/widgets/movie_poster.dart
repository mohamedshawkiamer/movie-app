import 'package:flutter/material.dart';
import '../core/config.dart';

class MoviePoster extends StatelessWidget {
  final String? path;
  final double width;
  final double height;
  final BorderRadius radius;

  const MoviePoster({super.key, required this.path, this.width = 120, this.height = 180, this.radius = const BorderRadius.all(Radius.circular(16))});

  @override
  Widget build(BuildContext context) {
    final url = path != null ? '${AppConfig.imageBaseUrl}${AppConfig.imageSizeW500}$path' : null;
    return ClipRRect(
      borderRadius: radius,
      child: url != null
          ? Image.network(url, width: width, height: height, fit: BoxFit.cover)
          : Container(width: width, height: height, color: Colors.grey.shade800, child: const Icon(Icons.movie, size: 48)),
    );
  }
}
