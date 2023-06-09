import 'package:flutter/material.dart';
import 'package:stylle/components/image_stream_viewer.dart';
import 'package:stylle/constants/colors.dart';
import 'package:stylle/services/collections/my_images.dart';

import '../components/image_stream_viewer_short.dart';
import '../components/images_stream_popular_search.dart';
import '../services/collections/my_users.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  String _searchInput = '';

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
            style: const TextStyle(color: primaryPinkColor),
            cursorColor: primaryPinkColor,
            decoration: const InputDecoration(
              suffixIcon: Padding(
                padding: EdgeInsetsDirectional.only(end: 12.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 28,
                ), // myIcon is a 48px-wide widget.
              ),
              contentPadding: EdgeInsets.only(left: 20),
              filled: true, //<-- SEE HERE
              fillColor: primaryPinkColor,
              hintText: 'Find you style...',
              hintStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
              border: OutlineInputBorder(
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
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // POPULAR STYLES
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'POPULAR STYLES:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: whiteColor,
                            ),
                          ),
                        ),
                  
                        // LIST POPULAR IMG
                        Container(
                          margin: EdgeInsets.only( top: 20, bottom: 20),
                          child: ImageStreamPopularSearch(
                              user: currentUser,
                              imagesPopularStream: MyImage.imagesPopularStream()),
                        ),
                  
                        // IDEAS FOR YOU
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'IDEAS FOR YOU:',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: whiteColor,
                              ),
                          ),
                        ),
                  
                        // LIST COLLECTION
                        // ListView(
                        //   shrinkWrap: true,
                        //   scrollDirection: Axis.vertical,
                        //   children: const [
                        //     // Your vertical image widgets go here
                        //   ],
                        // ),
                      ],
                    ),
                  );
                }
              })
          : ImageStreamView(imagesStream: MyImage.searchImages(_searchInput)),
    );
  }
}
