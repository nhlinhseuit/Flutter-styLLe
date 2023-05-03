import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/pages/detail_page.dart';

class HomePageDelegated extends StatefulWidget {
  const HomePageDelegated({super.key});

  @override
  State<HomePageDelegated> createState() => _HomePageDelegatedState();
}

class _HomePageDelegatedState extends State<HomePageDelegated> {
  Icon firstIcon = Icon(
    color: Colors.pink[200],
    Icons.favorite_rounded,
  );
  Icon secondIcon = const Icon(
    color: Color.fromRGBO(255, 191, 202, 100),
    Icons.favorite_border_rounded,
  );

  int numberOfItem = 30;

  List<bool> toggle = List.generate(30, (index) => false);

  List<String> imgUrls = List.generate(
      30,
      (index) => index % 2 == 0
          ? 'https://picsum.photos/400/400?image=${index + 10}'
          : 'https://picsum.photos/300/600?image=${index + 18}');

  @override
  Widget build(BuildContext context) {
    if (numberOfItem > toggle.length) {
      toggle.addAll(
          List.generate(numberOfItem - toggle.length, (index) => false));
      imgUrls.addAll(List.generate(
          numberOfItem - toggle.length,
          (index) => index % 2 == 0
              ? 'https://picsum.photos/400/400?image=${index + 10}'
              : 'https://picsum.photos/300/600?image=${index + 18}'));
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                // forceElevated: true,
                // elevation: 2.5,
                centerTitle: true,
                snap: true,
                floating: true,
                shadowColor: Colors.black,
                toolbarHeight: 55,
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  preferredSize:
                      const Size.fromHeight(0.0), // chiều cao đường kẻ ngang
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 120,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.pink[200], // màu sắc của đường kẻ ngang
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 140),
                        color: Colors.pink[200], // màu sắc của đường kẻ ngang
                        height: 1.0, // độ dày của đường kẻ ngang
                      ),
                    ),
                  ),
                ),
                title: Container(
                  margin: const EdgeInsets.only(bottom: 4, top: 10),
                  child: Text(
                    'styLLe',
                    style: GoogleFonts.allura(
                      color: Colors.pink[200],
                      fontSize: 35,
                    ),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    color: Colors.pink[200],
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 28.0,
                    ),
                    onPressed: () {
                      // handle search action here
                    },
                  ),
                ],
              )
            ];
          },
          body: MasonryGridView.builder(
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
                              Navigator.of(context)
                                  .pushNamed(detailDemoRout, arguments: {'imgUrlString': imgUrls[index]});
                            },
                            child: Image.network(imgUrls[index]),
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 14),
                              child: Text(
                                'Michelle',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 120, 120, 120),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 45),
                              child: IconButton(
                                icon: toggle[index] ? firstIcon : secondIcon,
                                onPressed: () {
                                  setState(() {
                                    toggle[index] = !toggle[index];
                                  });
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return AlertDialog(
                                  //         title: Text(
                                  //             "Thông báo của tim có index = $index"),
                                  //         content: Text('Nội dung thông báo'),
                                  //       );
                                  // });
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ));
              }),
        ));
  }
}
