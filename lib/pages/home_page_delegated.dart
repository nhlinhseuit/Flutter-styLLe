import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylle/services/auth/auth_service.dart';
import '../constants/enums.dart';
import '../constants/routes.dart';
import 'home_page.dart';
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

        // GRID VIEW

        // body: GridView(
        //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        //     maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
        //     crossAxisSpacing: 50,
        //     mainAxisSpacing: 30,
        //     childAspectRatio: MediaQuery.of(context).size.width /
        //         (MediaQuery.of(context).size.height / 2),
        //   ),
        //   children: [
        //     // for (var i = 0; i < 50; i++)
        //     //   Image.network(
        //     //     'https://picsum.photos/250?image=$i',
        //     //     fit: BoxFit.contain,
        //     //     width: 100,
        //     //   ),
        //     Container(
        //       color: Colors.yellow,
        //       width: 0,
        //       height: 100,
        //       // child: Image.network(
        //       //   'https://picsum.photos/400/600',
        //       //   width: MediaQuery.of(context).size.width,
        //       // ),
        //     ),

        //     Container(
        //       color: Colors.red,
        //       width: 0,
        //       height: 200,
        //       // child: Image.network(
        //       //   'https://picsum.photos/400/300',
        //       //   width: MediaQuery.of(context).size.width,
        //       // ),
        //     ),
        //   ],
        // ),

        // MANSONRY VIEW

        // body: MasonryGridView.count(
        //   crossAxisCount: 2,
        //   mainAxisSpacing: 4,
        //   crossAxisSpacing: 4,
        // staggeredTiles: [
        //     StaggeredTile.count(1, 1),
        //     StaggeredTile.count(1, 2),
        //     StaggeredTile.count(1, 1),
        //     StaggeredTile.count(1, 1),
        //     StaggeredTile.count(1, 1),
        //     StaggeredTile.count(2, 1),
        //     StaggeredTile.count(1, 1),
        //     StaggeredTile.count(1, 1),
        //     StaggeredTile.count(1, 1),
        //   ],
        //   itemBuilder: (BuildContext context, int index) {
        //     return containers[index];
        //   },
        // ));

        // STAGGRED VIEW

        // body: StaggeredGridView.countBuilder(
        //   crossAxisCount: 2,
        //   itemCount: 10,
        //   itemBuilder: (BuildContext context, int index) {
        //     return Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //     child: ClipRRect(
        //       borderRadius: BorderRadius.circular(8.0),
        //       child: Image.network(
        //         'https://picsum.photos/250?image=$index',
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   );
        //   },
        //       // Container(
        //       //   color: Colors.blue,
        //       //   height: index.isEven ? 200 : 100,
        //       // ),

        //   staggeredTileBuilder: (int index) =>
        //       StaggeredTile.count(1, index.isEven ? 2 : 1),
        //   mainAxisSpacing: 4.0,
        //   crossAxisSpacing: 4.0,
        // ),

        body: StaggeredGridView.countBuilder(
          padding: EdgeInsets.all(10),
          crossAxisCount: 2,
          itemCount: 50,
          itemBuilder: (BuildContext context, int index) {
            return CustomWidget(
              imageUrl: index%2==0 ? 'https://picsum.photos/250?image=${index + 10}' : 'https://paradepets.com/.image/c_limit%2Ccs_srgb%2Cq_auto:good%2Cw_700/MTkxMzY1Nzg4NjczMzIwNTQ2/cutest-dog-breeds-jpg.webp',
            );
          },
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ));
  }
}

class CustomWidget extends StatefulWidget {
  final String imageUrl;

  CustomWidget({required this.imageUrl});

  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  double _aspectRatio = 1.0;

  @override
  void initState() {
    super.initState();

    // Lấy kích thước ảnh từ URL
    Image.network(widget.imageUrl)
        .image
        .resolve(const ImageConfiguration())
        .addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        setState(() {
          // Tính tỷ lệ khung hình của ảnh
          _aspectRatio = info.image.width / info.image.height;
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio - 0.2,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.scaleDown,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Alexander',
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 60.0),
                  child: Icon(
                    color: Color.fromRGBO(255, 191, 202, 100),
                    Icons.heart_broken,
                    size: 24.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
