import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stylle/services/collections/my_images.dart';

class DetailDemo extends StatefulWidget {
  const DetailDemo({
    super.key,
  });

  @override
  State<DetailDemo> createState() => _DetailDemoState();
}

class _DetailDemoState extends State<DetailDemo> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MyImage;
    final imageUrl = args.imagePath;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned(
              child: SizedBox(
                width: double.infinity,
                height: 630,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black.withOpacity(.15)),
              ),
            ),
            Positioned(
                top: 60,
                left: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            Positioned(
                top: 530,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_drop_up,
                        color: Color.fromARGB(255, 234, 233, 233),
                        size: 40,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Text(
                      'Swipe up for detail',
                      style: TextStyle(
                          color: Color.fromARGB(255, 207, 207, 207),
                          fontSize: 16),
                    ),
                  ],
                )),
            Positioned(
              top: 640,
                child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.file_download_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                    },
                  ),
                )
              ],
            ))
          ],
        ));
  }
}
