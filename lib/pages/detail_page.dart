import 'package:flutter/material.dart';
import 'package:stylle/services/collections/my_images.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as MyImage;
    final imageUrl = args.imagePath;
    return Scaffold(
      body: Stack(children: [
        ClipRRect(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
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
        const Positioned(
          top: 150,
          left: 300,
          child: Icon(
            Icons.favorite_outline_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        const Positioned(
          top: 200,
          left: 300,
          child: Icon(
            Icons.file_download_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
        const Positioned(
          top: 250,
          left: 300,
          child: Icon(
            Icons.copy,
            color: Colors.white,
            size: 30,
          ),
        ),
        const Positioned(
          top: 300,
          left: 300,
          child: Icon(
            Icons.share,
            color: Colors.white,
            size: 30,
          ),
        ),
        Positioned(
          bottom: 40,
          right: 30,
          left: 30,
          child: Container(
            width: 300,
            height: 170,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.3),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  // author
                  Text(
                    args.userName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                  //description
                  Text(
                    textAlign: TextAlign.justify,
                    args.description,
                    style: const TextStyle(
                        fontSize: 16, color: Colors.white, height: 1.3),
                  ),
                  //tag
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      args.tags.join(", "),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
