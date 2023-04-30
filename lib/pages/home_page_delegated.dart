import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePageDelegated extends StatelessWidget {
  const HomePageDelegated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: const Color.fromARGB(250, 250, 250, 255),
          toolbarHeight: 45,
          // elevation: 0.16,
          elevation: 2,
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(left: 124),
            child: Text(
              'styLLe',
              style: GoogleFonts.allura(
                color: Colors.pink[200],
                fontSize: 35,
                fontWeight: FontWeight.w600,
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
        ),

        body: MasonryGridView.builder(
          itemCount: 30,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 16),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(index % 2 == 0
                        ? 'https://picsum.photos/400/400?image=${index + 10}'
                        : 'https://picsum.photos/300/600?image=${index + 10}'),
                  ),
                  Row(
                    children:  [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 15),
                        child: Text(
                          'Climothee',
                          style: TextStyle(
                            color: Colors.pink[200]!,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 9, left: 53),
                        child: Icon(
                          color: Color.fromRGBO(255, 191, 202, 100),
                          Icons.favorite_border_rounded,
                          size: 24.0,
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }
}
