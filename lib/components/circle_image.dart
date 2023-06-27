import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImage extends StatefulWidget {
  const CircleImage({super.key, required this.size, required this.imgUrl});
  final double size;
  final String imgUrl;

  @override
  State<CircleImage> createState() => _CircleImageState();
}

class _CircleImageState extends State<CircleImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size/2),
        child: CachedNetworkImage(
          imageUrl: widget.imgUrl,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
