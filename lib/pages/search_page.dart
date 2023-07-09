import 'package:flutter/material.dart';
import 'package:stylle/components/image_stream_viewer.dart';
import 'package:stylle/constants/colors.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/services/collections/my_images.dart';
import 'dart:ui';
import '../components/images_stream_popular_search.dart';
import '../services/collections/my_users.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class MyObject {
  String imageUrl;
  String name;

  MyObject({required this.imageUrl, required this.name});
}

List<MyObject> myObjects = [
  MyObject(
    imageUrl: "assets/images/cat.jpg",
    name: 'Cat',
  ),
  MyObject(
    imageUrl: "assets/images/kitchen.jpg",
    name: 'Kitchen',
  ),
  MyObject(
    imageUrl: "assets/images/dog.jpg",
    name: 'Dog',
  ),
  MyObject(
    imageUrl: "assets/images/uit.jpg",
    name: 'Uit',
  ),
  MyObject(
    imageUrl: "assets/images/school.jpg",
    name: 'School',
  ),
  MyObject(
    imageUrl: "assets/images/nvhsv.jpg",
    name: 'NVHSV',
  ),
];

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  String _searchInput = '';

  // DEFAULT TAGS IN SEARCH
  List<String> tags = ['cat', 'kitchen', 'dog', 'uit', 'school', 'nvhsv'];
  // List<String> tags = ['cat'];

  get args => null;
  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(_performSearch);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _searchInput = _searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 80,
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryPinkColor,
        elevation: 0,
        title: SizedBox(
          height: 50,
          width: 600,
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            cursorColor: primaryPinkColor,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: primaryPinkColor2, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              suffixIcon: const Padding(
                padding: EdgeInsetsDirectional.only(end: 12.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 28,
                ), // myIcon is a 48px-wide widget.
              ),
              contentPadding: const EdgeInsets.only(left: 30),
              filled: true, //<-- SEE HERE
              fillColor: const Color(0xFF303030),
              hintText: 'Find you style...',
              hintStyle: const TextStyle(
                color: Colors.white,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchInput = value.trim();
              });
            },
          ),
        ),
      ),
      body: _searchInput.isEmpty
          ? FutureBuilder(
              future: MyUser.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Show a loading indicator while waiting
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final MyUser currentUser = snapshot.data!;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // POPULAR STYLES
                          Container(
                            margin: const EdgeInsets.only(left: 10, top: 15),
                            child: const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'POPULAR:',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),

                          // LIST POPULAR IMG
                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 10),
                            child: ImageStreamPopularSearch(
                                user: currentUser,
                                imagesPopularStream:
                                    MyImage.imagesPopularStream()),
                          ),

                          // IDEAS FOR YOU
                          Container(
                            margin: const EdgeInsets.only(left: 10, top: 5),
                            child: const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'IDEAS FOR YOU:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),

                          // LIST COLLECTION
                          // Container(
                          //   margin: const EdgeInsets.only(top: 20, bottom: 20),
                          //   child: ImageStreamIdeas(
                          //       user: currentUser,
                          //       imagesTagsStream: MyImage.imagesTagsStream(tags)),
                          // ),

                          GridView.count(
                            padding: const EdgeInsets.only(top: 12, bottom: 20),
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 6,
                            childAspectRatio: (size.width - 52) / 200,
                            children: List.generate(myObjects.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(tagRoute,
                                  arguments: 
                                    [tags[index]],
                                  );
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {},
                                        child: Image.asset(
                                          height: 100,
                                          width: (size.width - 52) / 2,
                                          myObjects[index].imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2, sigmaY: 2),
                                          child: Container(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Text(
                                          myObjects[index].name.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              })
          : ImageStreamView(imagesStream: MyImage.searchImages(_searchInput)),
    );
  }
}
