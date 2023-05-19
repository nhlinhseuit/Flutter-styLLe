import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:stylle/constants/routes.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as http;
import 'package:stylle/services/collections/my_images.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int numberOfItem = 30;

  List<String> imgUrls = List.generate(
      30,
      (index) => index % 2 == 0
          ? 'https://picsum.photos/400/400?image=${index + 10}'
          : 'https://picsum.photos/300/600?image=${index + 18}');

  Icon firstIcon = Icon(
    color: Colors.pink[200],
    Icons.favorite_rounded,
    size: 30,
  );
  Icon secondIcon = const Icon(
    color: Colors.black,
    size: 30,
    Icons.favorite_border_rounded,
  );
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as MyImage;
    final imageUrl = args.imagePath;

    List<String> imgUrlsRelated = List.generate(
        30,
        (index) => index % 2 == 0 
            ? 'https://picsum.photos/400/400?image=${index + 10}'
            : 'https://picsum.photos/300/600?image=${index + 18}');
    return SafeArea(
      child: Scaffold(
          floatingActionButton: Container(
            margin: EdgeInsets.only(top: 20),
            child: FloatingActionButton.small(
              elevation: 1,
              backgroundColor: Colors.black.withOpacity(.4),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartTop,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(children: [
              //////////////////////////////       HÌNH RENDER
              Stack(
                children: [
                  Positioned(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          // height: 610,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(38),
                                bottomRight: Radius.circular(38)),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              //////////////////////////////       THAO TÁC TIM, TẢI, COPY, SHARE
              Positioned(
                  child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: IconButton(
                        icon: toggle ? firstIcon : secondIcon,
                        onPressed: () {
                          setState(() {
                            toggle = !toggle;
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: IconButton(
                      icon: const Icon(
                        Icons.file_download_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () async {
                        try {
                          String path =
                              'https://firebasestorage.googleapis.com/v0/b/stylle.appspot.com/o/images%2F2023-05-18%2020%3A35%3A38.827456.png?alt=media&token=eb25a194-02db-45d8-834d-ca6db28fd3aa';
                          await GallerySaver.saveImage(path).then((success) {
                            if (success != null && success) {
                              showDialog(
                                  context: context,
                                  builder: (_) => const AlertDialog(
                                        title: Text('Notification'),
                                        content: Text('Download successful'),
                                      ));
                            }
                          });
                        } catch (e) {
                          print('ERROR: $e');
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: IconButton(
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () async {
                        String path =
                            'https://firebasestorage.googleapis.com/v0/b/stylle.appspot.com/o/images%2F2023-05-18%2020%3A35%3A38.827456.png?alt=media&token=eb25a194-02db-45d8-834d-ca6db28fd3aa';
                        await Clipboard.setData(ClipboardData(text: path));
                        // ignore: use_build_context_synchronously
                        showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(
                                  title: Text('Notification'),
                                  content: Text('Copy successful'),
                                ));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: IconButton(
                      icon: const Icon(
                        Icons.share,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () async {
                        String path =
                            'https://firebasestorage.googleapis.com/v0/b/stylle.appspot.com/o/images%2F2023-05-18%2020%3A35%3A38.827456.png?alt=media&token=eb25a194-02db-45d8-834d-ca6db28fd3aa';
                        // await Share.share(path, subject: "subject that I like");

                        // ignore: use_build_context_synchronously

                        final uri = Uri.parse(path);
                        final response = await http.get(uri);
                        final bytes = response.bodyBytes;
                        final temp = await getTemporaryDirectory();
                        final path2 = '${temp.path}/sharedImag.jpg';
                        File(path2).writeAsBytesSync(bytes);
                        Share.shareXFiles([XFile(path2)],
                            text: 'Great picture');
                        // ignore: use_build_context_synchronously
                      },
                    ),
                  )
                ],
              )),

              //////////////////////////////       DIVIDER
              const Divider(
                height: 2,
                color: Colors.grey,
                thickness: 1.5,
              ),

            //////////////////////////////       INFORMATION IMG
            Positioned(
              child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20, top: 20),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                             Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                args.userName,
                                style: TextStyle(
                                  color: Colors.pink[200],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 23, top: 20),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Minimalist Style',
                                style: TextStyle(
                                  color: Colors.pink[200],
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 80),
                              child: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.pink[200],
                                  size: 30,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Text(
                              '237',
                              style: TextStyle(
                                  color: Colors.pink[200], fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 32.0, right: 32, bottom: 10, top: 12),
                        child: Text(
                            textAlign: TextAlign.justify,
                            args.description,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              height: 1.3,
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 23, bottom: 20),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.tag,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                  Text(
                                    args.tags.join(", "),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),

              //////////////////////////////       DIVIDER
              const Divider(
                height: 2,
                color: Colors.grey,
                thickness: 1.5,
              ),

              //////////////////////////////       RELATED PHOTOS TITLE
              Container(
                margin: const EdgeInsets.only(left: 23, top: 20),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Related photos',
                    style: TextStyle(
                      color: Color.fromARGB(255, 183, 183, 183),
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              //////////////////////////////
              /// RELATED PHOTOS IMGS

              Stack(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 600,
                      child: MasonryGridView.builder(
                          itemCount: numberOfItem,
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 8, right: 8, bottom: 20),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              detailDemoRout,
                                              arguments: {
                                                'imgUrlString': imgUrls[index],
                                              });
                                        },
                                        child: Image.network(
                                          imgUrlsRelated[index],
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          }),
                    ),
                  ),
                ],
              ),
            ]),
          )),
    );
  }
}
