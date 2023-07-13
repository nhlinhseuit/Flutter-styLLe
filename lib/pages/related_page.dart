import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stylle/constants/routes.dart';

import '../utilities/check_connectivity.dart';

class RelatedPage extends StatefulWidget {
  const RelatedPage({super.key});

  @override
  State<RelatedPage> createState() => _RelatedPageState();
}

class _RelatedPageState extends State<RelatedPage> {
  int numberOfItem = 30;

  List<bool> toggle = List.generate(30, (index) => false);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final idx = args['index'] ?? 0;

    List<String> imgUrls = List.generate(
        30,
        (index) => index % 2 == 0 && index != idx
            ? 'https://picsum.photos/400/400?image=${index + 10}'
            : 'https://picsum.photos/300/600?image=${index + 18}');

    return Scaffold(
      body: NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [];
      },
      body: Stack(
        children: [
          MasonryGridView.builder(
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
                            onTap: () async {
                              if (!(await checkInternetConnectivity())) {
                                displayNoInternet();
                                return;
                              }
                              Navigator.of(context).pushNamed(detailPageRout,
                                  arguments: {
                                    'imgUrlString': imgUrls[index],
                                    'idx': idx
                                  });
                            },
                            child: CachedNetworkImage(
                                  imageUrl: imgUrls[index],
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  fit: BoxFit.cover,  
                                ),
                          ),
                        ),
                      ],
                    ));
              }),
        ],
      ),
    )
    );
        
  }
}
