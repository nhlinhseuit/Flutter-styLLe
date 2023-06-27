import 'package:flutter/material.dart';
import 'package:stylle/components/image_stream_viewer.dart';
import 'package:stylle/services/collections/my_images.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  String _searchInput ='';
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
      // backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 255, 255, 255), Theme.of(context).colorScheme.primary],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchInput = value.trim();
            });
          },
        ),
      ),
      body: _searchInput.isEmpty
      ? const CircularProgressIndicator()
      : ImageStreamView(imagesStream: MyImage.searchImages(_searchInput)),
    );
  }
}