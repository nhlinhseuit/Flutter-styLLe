import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stylle/constants/routes.dart';

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
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final imageUrl = args['imgUrlString'] ?? '';
    final idx = args['index'];

    List<String> imgUrlsRelated = List.generate(
      30,
      (index) => index % 2 == 0 && index != idx
          ? 'https://picsum.photos/400/400?image=${index + 10}'
          : 'https://picsum.photos/300/600?image=${index + 18}');
    return Scaffold(
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
                        height: 650,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: Container(
                    height: 650,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.2),
                        borderRadius: BorderRadius.circular(50)),
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
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 40,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const Text(
                          'Swipe up for detail',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16),
                        ),
                      ],
                    )),
              ],
            ),

            //////////////////////////////       THAO TÁC TIM, TẢI, COPY, SHARE
            Positioned(
                child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: IconButton(
                      icon: toggle ? firstIcon : secondIcon,
                      onPressed: () {
                        setState(() {
                          toggle = !toggle;
                        });
                      }),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.file_download_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {},
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
                                'Timothée Chalamet',
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
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 32.0, right: 32, bottom: 10, top: 12),
                        child: Text(
                            textAlign: TextAlign.justify,
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s.....',
                            style: TextStyle(
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
                                children: const [
                                  Icon(
                                    Icons.tag,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                  Text(
                                    '  minimalist, fashion, black, pink',
                                    style: TextStyle(
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
              child: Row(
                children: const [
                  Padding(
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
                ],
              ),
            ),

            //////////////////////////////      
            /// RELATED PHOTOS IMGS

            Stack(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 560,
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
                                              'idx': idx
                                            });
                                      },
                                      child: Image.network(imgUrlsRelated[index]),
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
        ));
  }
}

